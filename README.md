# Healthcare Data Platform Modernization — SQL Server to Databricks

> **Data Engineering Portfolio | SQL Server / SSMS → Databricks | Lakebridge | Unity Catalog | PySpark | Argo Workflows**

A sanitized portfolio demonstrating the data-engineering patterns, migration techniques, validation strategies, and workflow-orchestration concepts used during a healthcare data-platform modernization project.

> **Confidentiality Notice**
>
> This repository contains **independently recreated examples using synthetic data**. It does not contain client source code, proprietary data, credentials, internal URLs, production configurations, screenshots, or confidential artifacts.

---

## Project Overview

As a Data Engineer, I contributed to the modernization of legacy **SQL Server/SSMS-based data-processing workloads** to a cloud-based **Databricks** platform.

The migration focused on preserving existing business functionality while modernizing SQL processing, data objects, validation, scheduling, and operational workflows.

### High-Level Migration Flow

```text
SQL Server / SSMS
       |
       | Legacy SQL / Views / Data Processing
       v
Lakebridge
       |
       | Automated Initial Conversion
       v
Manual SQL Remediation
       |
       | Compatibility + Business Logic Review
       v
Databricks SQL / PySpark
       |
       v
Unity Catalog
       |
       | Data Validation & Reconciliation
       v
Argo CronWorkflow
       |
       | Scheduling / Dependencies / Parameters
       v
File Generation / S3 / SFTP / Downstream Delivery
```

---

## Project Experience

**Role:** Data Engineer  
**Client:** Definitive Healthcare  
**Project:** SQL Server to Databricks Migration & Data Platform Modernization  
**Duration:** June 2026 – September 2026

### Key Responsibilities

- Contributed to migration of legacy SQL Server/SSMS views and data-processing logic to Databricks.
- Converted and remediated SQL Server logic into **Databricks SQL and PySpark**.
- Worked with complex SQL involving:
  - Multiple joins
  - `UNION` / `UNION ALL`
  - `GROUP BY` and aggregations
  - `CASE` business rules
  - `PIVOT`
  - Date/time logic
  - SQL Server-specific functions and constructs
- Used **Lakebridge** as a migration accelerator for initial SQL conversion.
- Performed manual remediation where automated conversion required compatibility or business-logic changes.
- Migrated legacy database/schema/table references into **Unity Catalog** structures.
- Created and validated Databricks tables from source extracts, including CSV-based ingestion and schema/data-type handling.
- Performed detailed **source-to-target validation and reconciliation**.
- Modernized legacy **VisualCron** scheduling and processing logic into **Argo CronWorkflow YAML**.
- Worked with workflow scheduling, parameters, dependencies, file generation, archival, and downstream S3/SFTP delivery processes.
- Used Git for source control, branching, merge activities, and controlled deployment changes.
- Supported Dev testing and production-oriented troubleshooting across Databricks, YAML workflows, and file-transfer processes.

---

## Technology Stack

| Area | Technologies |
|---|---|
| Data Platform | Databricks |
| Processing | Apache Spark, PySpark |
| SQL | SQL Server, Databricks SQL |
| Governance | Unity Catalog |
| Migration | Lakebridge |
| Orchestration | Argo Workflows / CronWorkflow |
| Legacy Scheduler | VisualCron |
| Version Control | Git |
| Storage / Delivery | Cloud Storage, S3, SFTP |
| Validation | SQL, PySpark, Data Reconciliation |

---

# Migration Approach

## 1. Understand the Legacy Workload

Before converting the workload, the existing SQL Server logic was reviewed to understand:

- Source and target objects
- Table relationships
- Join conditions
- Filters
- Business rules
- Aggregations
- PIVOT logic
- Data types
- Dependencies
- Scheduling and downstream processing

The goal was to understand the **business behavior**, not just translate SQL syntax.

---

## 2. Automated SQL Conversion with Lakebridge

Lakebridge was used to accelerate the initial conversion of legacy SQL workloads.

The generated output was then reviewed manually because automated conversion does not guarantee complete compatibility or business-equivalent behavior.

Typical remediation areas included:

- SQL Server-specific functions
- Object references
- Data types
- Temporary objects
- Date/time functions
- PIVOT logic
- Unsupported syntax
- Business-rule differences

### Migration principle

```text
Automated Conversion
        ↓
Manual Review
        ↓
Compatibility Remediation
        ↓
Functional Validation
        ↓
Data Reconciliation
```

---

# SQL Server → Databricks SQL

A simplified example:

### Legacy-style SQL

```sql
SELECT
    provider_id,
    SUM(amount) AS total_amount
FROM claims
WHERE status = 'PAID'
GROUP BY provider_id;
```

### Databricks SQL

```sql
SELECT
    provider_id,
    SUM(amount) AS total_amount
FROM claims
WHERE status = 'PAID'
GROUP BY provider_id;
```

The syntax may look similar for simple queries, but migration complexity increases with platform-specific functions, temporary objects, data types, PIVOT operations, date logic, and object references.

---

# SQL Concepts Demonstrated

## JOINs

Example:

```sql
SELECT
    c.claim_id,
    c.provider_id,
    p.provider_name
FROM claims c
LEFT JOIN providers p
    ON c.provider_id = p.provider_id;
```

Important migration consideration:

> A join can change row counts if the join key is not unique on the joined side.

For example, an unexpected row increase can indicate a one-to-many relationship or duplicate join keys.

---

## UNION vs UNION ALL

```sql
SELECT provider_id FROM claims_2025
UNION
SELECT provider_id FROM claims_2026;
```

`UNION` removes duplicate rows.

```sql
SELECT provider_id FROM claims_2025
UNION ALL
SELECT provider_id FROM claims_2026;
```

`UNION ALL` preserves duplicates and is generally more efficient because it does not perform duplicate elimination.

During migration, the distinction must be preserved because changing `UNION` to `UNION ALL` can change business results.

---

## CASE / Business Rules

```sql
SELECT
    claim_id,
    CASE
        WHEN amount >= 10000 THEN 'HIGH'
        WHEN amount >= 5000 THEN 'MEDIUM'
        ELSE 'LOW'
    END AS claim_band
FROM claims;
```

Migration validation should confirm:

- Condition order
- NULL behavior
- Data types
- Boundary conditions
- Business-rule equivalence

---

# PIVOT

PIVOT is a key transformation used to convert values from rows into columns.

### Input

```text
provider_id | metric  | amount
------------|---------|-------
101         | Paid    | 500
101         | Allowed | 700
```

### Output

```text
provider_id | Paid | Allowed
------------|------|--------
101         | 500  | 700
```

A PIVOT migration must validate:

- Pivot columns
- Aggregation
- Input grain
- NULL behavior
- Duplicate records
- Final column mapping
- Business totals

### Conditional Aggregation Alternative

```sql
SELECT
    provider_id,
    SUM(CASE WHEN metric = 'Paid'
             THEN amount ELSE 0 END) AS Paid,
    SUM(CASE WHEN metric = 'Allowed'
             THEN amount ELSE 0 END) AS Allowed
FROM metrics
GROUP BY provider_id;
```

Conditional aggregation can be useful when a direct PIVOT translation is not appropriate or when explicit logic is easier to validate.

---

# Unity Catalog

Unity Catalog provides centralized governance and organization for Databricks data assets.

A common three-level namespace is:

```text
catalog.schema.object
```

For example:

```text
healthcare_prod.claims.claim_details
```

### Migration consideration

Legacy references such as:

```text
database.schema.table
```

needed to be mapped correctly to the target Databricks catalog structure.

Incorrect mapping can produce a technically valid query that reads from the wrong dataset, so object-level validation is important.

---

# CSV Ingestion and Table Creation

CSV-based ingestion requires careful handling because CSV is a weakly typed format.

Example:

```python
df = (
    spark.read
    .option("header", "true")
    .option("inferSchema", "true")
    .csv(input_path)
)
```

Production-oriented pipelines should consider explicit schemas where appropriate.

Validation areas include:

- Column names
- Data types
- Headers
- Delimiters
- Quoted values
- NULL representation
- Malformed records
- Numeric precision
- Date formats
- Row counts

---

# PySpark

Example transformation:

```python
from pyspark.sql import functions as F

result = (
    claims
    .filter(F.col("status") == "PAID")
    .groupBy("provider_id")
    .agg(
        F.sum("amount").alias("total_paid")
    )
)
```

### Key Spark concepts

**DataFrame**

A distributed tabular data structure used by Spark for large-scale data processing.

**Transformation**

Operations such as:

```text
select
filter
join
groupBy
withColumn
```

build a logical execution plan.

**Action**

Operations such as:

```text
count
collect
show
write
```

trigger execution.

**Lazy Evaluation**

Spark delays execution of transformations until an action requires a result.

---

# Spark Performance Concepts

## Shuffle

A shuffle redistributes data across partitions.

Operations that can cause significant shuffling include:

- `groupBy`
- `distinct`
- `orderBy`
- Many joins

Large shuffles can increase network and disk I/O.

## Broadcast Join

When one side of a join is sufficiently small, Spark can broadcast it to executors.

```python
from pyspark.sql.functions import broadcast

result = large_df.join(
    broadcast(small_df),
    "provider_id",
    "left"
)
```

Broadcasting should be used carefully because broadcasting an unexpectedly large dataset can create memory pressure.

## Data Skew

Data skew occurs when some keys contain substantially more records than others, resulting in uneven workload across partitions.

Potential approaches depend on the workload and may include:

- Salting
- Different join strategies
- Filtering
- Separating heavy keys
- Better partitioning

---

# Data Validation & Reconciliation

Migration success is not determined only by whether the converted SQL executes successfully.

The target should produce results consistent with the legacy implementation.

## Validation Dimensions

| Validation | Purpose |
|---|---|
| Row Count | Detect missing or additional records |
| Distinct Count | Check population and uniqueness |
| Duplicate Check | Detect unexpected row multiplication |
| NULL Count | Detect missing-value behavior changes |
| Join Validation | Verify relationships and cardinality |
| Filter Validation | Confirm business conditions |
| Sample Records | Compare actual values |
| Aggregations | Compare SUM / COUNT / AVG |
| Distribution | Compare statuses/categories/date populations |
| Schema | Confirm columns and compatible data types |

### Example

```sql
SELECT
    COUNT(*) AS row_count,
    COUNT(DISTINCT claim_id) AS distinct_claims,
    SUM(amount) AS total_amount
FROM target_claims;
```

### Validation principle

```text
Source
  ↓
Source Metrics
  ↓
Transformation
  ↓
Target
  ↓
Target Metrics
  ↓
Compare
  ↓
Investigate Differences
```

---

# Troubleshooting Data Mismatches

### Scenario

Source:

```text
1,000,000 rows
```

Target:

```text
1,050,000 rows
```

Potential causes:

- Duplicate join keys
- One-to-many join
- Incorrect join condition
- `UNION ALL` instead of `UNION`
- Filter differences
- Duplicate source records
- Transformation logic

### Debugging approach

1. Compare source and target filters.
2. Check duplicate keys.
3. Validate joins individually.
4. Compare row counts after each major transformation.
5. Identify the first stage where the count diverges.
6. Trace the affected records.
7. Determine whether the difference is intentional or a defect.

---

# VisualCron → Argo CronWorkflow

Legacy scheduling logic was modernized into cloud-native workflow definitions.

A simplified Argo CronWorkflow:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: CronWorkflow

metadata:
  name: databricks-data-pipeline

spec:
  schedule: "0 5 * * *"

  workflowSpec:
    entrypoint: main

    templates:
      - name: main
        steps:
          - - name: run-processing
              template: processing
```

## Workflow Concepts

### Schedule

Defines when the workflow should execute.

### Parameters

Allow reusable workflows to receive values such as:

- Environment
- Processing date
- File path
- Dataset
- Execution mode

### Dependencies

Define execution order between tasks.

### Retry

Can recover from transient failures, but retry behavior must be considered carefully for file transfers and non-idempotent operations.

---

# File Generation / S3 / SFTP

The workflow processing included downstream file-related activities.

Typical flow:

```text
Databricks Processing
       ↓
Generate Output
       ↓
Validate File
       ↓
Transfer
       ↓
Archive
       ↓
Downstream Consumer
```

Validation includes:

- File existence
- Filename
- Extension
- Destination path
- Header
- Delimiter
- Row count
- File size
- Transfer status

---

# Git & Deployment

Git supported controlled development and deployment of migration code and workflow configuration.

Key concepts:

| Concept | Meaning |
|---|---|
| Branch | Isolated development line |
| Commit | Versioned change |
| Merge | Integrates branch changes |
| Pull/Merge Request | Review and controlled integration |
| Conflict | Overlapping changes requiring resolution |
| Revert | Creates a change that undoes an earlier change |

### Merge vs Squash

A merge preserves the branch's commit history.

Squashing combines multiple commits into a single commit before integration.

If the project requires a **merge commit**, the team's configured merge strategy should be followed rather than using squash.

---

# Dev vs Production

A common migration issue is code working in Dev but failing in Production because of:

- Hard-coded catalog names
- Environment-specific paths
- Schema differences
- Permissions
- Credentials/secrets
- Configuration differences
- Missing objects

### Best Practice

```text
Reusable Logic
      +
Environment-specific Configuration
      ↓
Parameterized Deployment
```

Avoid hard-coding environment-specific values inside reusable migration logic.

---

# Production Troubleshooting Framework

When a workflow fails:

```text
1. Identify failing task
        ↓
2. Read exact error
        ↓
3. Classify failure
   Code / Data / Config / Permission /
   Connectivity / Dependency / Infrastructure
        ↓
4. Check recent changes
        ↓
5. Compare with last known-good version
        ↓
6. Reproduce safely
        ↓
7. Implement targeted fix
        ↓
8. Validate output
        ↓
9. Deploy through approved process
        ↓
10. Monitor and document
```

---

# Example Troubleshooting Scenarios

## Table Not Found

Possible causes:

- Wrong catalog
- Wrong schema
- Wrong table name
- Object not deployed
- Permission issue

Approach:

```text
Validate catalog
→ Validate schema
→ Check object existence
→ Check permissions
→ Verify environment mapping
```

---

## Unexpected Row Increase

Likely causes:

- Duplicate join keys
- One-to-many relationship
- Incorrect join condition
- `UNION ALL`
- Duplicate source data

Approach:

```text
Check join-key uniqueness
→ Compare counts before/after join
→ Identify multiplied records
→ Confirm expected business relationship
```

---

## S3/SFTP Upload Failure

Check:

- Source file existence
- Exact filename
- Destination path
- Credentials
- Permissions
- Connectivity
- File size
- Transfer command/configuration
- Workflow parameters
- Previous task status

---

## Workflow Works Manually but Fails on Schedule

Check:

- Cron expression
- Time zone
- Runtime parameters
- Service identity
- Permissions
- Environment variables
- Working directory/path
- Dependency status
- Scheduler/controller status

---

# Key Engineering Challenges

## 1. SQL Compatibility

Legacy SQL Server constructs may not have direct Databricks equivalents.

**Approach:**

```text
Identify construct
→ Understand business behavior
→ Find equivalent
→ Implement/remediate
→ Validate
```

## 2. Data Equivalence

A migrated pipeline can execute successfully but still produce incorrect results.

Therefore:

> **Execution success ≠ migration success**

The final result must be validated against the legacy implementation.

## 3. Workflow Modernization

Replacing a scheduler is more than converting the cron schedule.

You must also consider:

- Parameters
- Dependencies
- Retries
- File handling
- Error handling
- Environment configuration
- Downstream delivery

---

# Skills Demonstrated

### Data Engineering

- ETL / ELT
- SQL
- PySpark
- Data transformation
- Data validation
- Data reconciliation

### Databricks

- Databricks SQL
- Spark
- Notebooks
- Workflows
- Unity Catalog

### Migration

- SQL Server modernization
- SQL conversion
- Lakebridge
- Legacy workload migration

### Orchestration

- Argo Workflows
- CronWorkflow
- YAML
- Scheduling
- Parameters
- Dependencies

### DevOps

- Git
- Branching
- Merge workflows
- Deployment support
- Production troubleshooting

---

# Key Outcomes

- Contributed to modernization of legacy SQL Server workloads onto Databricks.
- Supported conversion of complex SQL logic while preserving business behavior.
- Implemented structured source-to-target validation and reconciliation.
- Supported migration of database objects into Unity Catalog.
- Modernized legacy scheduling patterns into Argo CronWorkflow definitions.
- Supported file generation, archival, and downstream delivery workflows.
- Strengthened Dev-to-Production deployment and troubleshooting practices.
- Developed practical experience across cloud data engineering, migration, orchestration, and production support.

---

# Interview Summary

### 30-Second Version

> I worked as a Data Engineer on a healthcare data-platform modernization project where legacy SQL Server/SSMS workloads were migrated to Databricks. My work included SQL conversion and remediation using Lakebridge, Databricks SQL and PySpark development, Unity Catalog object mapping, source-to-target data validation, and modernization of VisualCron jobs into Argo CronWorkflow YAML. I also worked on Git-based deployment, file-processing workflows, S3/SFTP delivery, troubleshooting, and production support.

### 90-Second Version

> I worked on a Definitive Healthcare modernization project from June to September 2026. The objective was to migrate legacy SQL Server and SSMS-based data-processing workloads to Databricks and modernize the surrounding workflow orchestration.
>
> My responsibilities included converting legacy SQL into Databricks SQL and PySpark, working with complex joins, UNIONs, PIVOT logic, aggregations, business rules, and SQL Server-specific functions. We used Lakebridge to accelerate the initial conversion, followed by manual remediation for unsupported syntax, functions, object references, data types, and temporary objects.
>
> I also worked on mapping legacy database and schema references into Unity Catalog, creating and validating Databricks tables, and performing source-to-target reconciliation. Validation included row counts, distinct counts, duplicate checks, NULL checks, joins, filters, sample records, aggregations, and business-level distributions.
>
> On the orchestration side, I worked on modernizing VisualCron jobs into Argo CronWorkflow YAMLs, including schedules, parameters, dependencies, file generation, archival, and S3/SFTP delivery. I also supported Git-based development, Dev testing, deployment activities, and troubleshooting of workflow and production-related issues.

---

# Portfolio Structure

Recommended repository structure:

```text
sql-server-to-databricks-healthcare-migration/
│
├── README.md
│
├── sql-migration/
│   ├── sql-server-example.sql
│   ├── databricks-sql-example.sql
│   └── pivot-example.sql
│
├── pyspark/
│   ├── etl-example.py
│   └── validation-example.py
│
├── validation/
│   └── reconciliation.sql
│
├── argo/
│   └── cronworkflow-example.yaml
│
├── sample-data/
│   └── synthetic-claims.csv
│
└── architecture/
    └── migration-architecture.png
```

---

## Important

This repository is a **portfolio demonstration**, not a copy of the client implementation.

It intentionally uses:

- Synthetic data
- Generic table names
- Recreated SQL examples
- Simplified workflow configurations
- Publicly safe technical concepts

It does **not** contain:

- Client source code
- Client data
- Credentials or secrets
- Internal URLs
- Production configuration
- Proprietary SQL
- Internal screenshots
- Confidential architecture
- Private S3/SFTP paths

The project description represents professional experience; the implementation examples are independently recreated for demonstration and learning purposes.
