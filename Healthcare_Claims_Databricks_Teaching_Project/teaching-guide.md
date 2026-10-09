# Teaching Guide

## Recommended Class Story

Start with the business problem:

> A healthcare company has claims data in a legacy SQL Server system.
> The company wants to modernize the data-processing platform and move
> analytical workloads to Databricks.

Then introduce the pipeline:

```text
Source → Transform → Validate → Curate → Schedule → Deliver
```

## Module 1 — SQL

Teach:

- Tables
- Primary keys
- JOIN
- LEFT JOIN
- CASE
- GROUP BY
- Aggregation
- UNION vs UNION ALL
- PIVOT

### Exercise

Ask students:

> Find the total PAID claim amount for each provider.

Expected approach:

```sql
SELECT
    provider_id,
    SUM(amount) AS total_paid
FROM claims
WHERE status = 'PAID'
GROUP BY provider_id;
```

## Module 2 — Migration

Ask:

> What changes when SQL Server logic is moved to Databricks?

Expected discussion:

- SQL dialect
- Functions
- Data types
- Object names
- Temporary objects
- PIVOT
- Date/time functions
- Validation

Key lesson:

> Code conversion does not guarantee data equivalence.

## Module 3 — PySpark

Teach:

- SparkSession
- DataFrame
- filter
- select
- join
- groupBy
- agg
- write

Ask students to modify the pipeline to calculate:

- claim count
- total paid
- average paid claim
- maximum claim

## Module 4 — Validation

Give students an intentional defect:

Change the join from:

```python
on="provider_id"
```

to an incorrect join condition.

Ask:

> Why did the target row count or totals change?

This teaches join cardinality and reconciliation.

## Module 5 — Orchestration

Explain:

```text
Cron schedule
    ↓
Workflow
    ↓
ETL
    ↓
Validation
    ↓
Output
```

Students identify:

- Schedule
- Task
- Dependency
- Parameter
- Retry
- Failure

## Final Student Assignment

Ask students to add:

1. A new `facility` table.
2. A facility/provider join.
3. A new business rule using CASE.
4. A new validation check.
5. A new Argo workflow task.
6. A Git commit describing their changes.

## Viva Questions

1. Explain the complete architecture.
2. Why use PySpark?
3. What is lazy evaluation?
4. Why can a JOIN create duplicates?
5. What is PIVOT?
6. UNION vs UNION ALL?
7. How would you validate a migration?
8. What is Unity Catalog?
9. Why use Git?
10. What happens when a workflow task fails?
