from pyspark.sql import SparkSession
from pyspark.sql import functions as F

spark = (
    SparkSession.builder
    .appName("HealthcareClaimsETL")
    .getOrCreate()
)

# In Databricks, these could be catalog/schema tables.
claims = spark.read.option("header", True).option("inferSchema", True).csv(
    "sample-data/claims.csv"
)

providers = spark.read.option("header", True).option("inferSchema", True).csv(
    "sample-data/providers.csv"
)

# 1. Select paid claims
paid_claims = claims.filter(F.col("status") == "PAID")

# 2. Join provider reference data
enriched = paid_claims.join(
    providers,
    on="provider_id",
    how="left"
)

# 3. Aggregate to provider level
provider_summary = (
    enriched
    .groupBy("provider_id", "provider_name", "specialty")
    .agg(
        F.countDistinct("claim_id").alias("claim_count"),
        F.sum("amount").alias("total_paid")
    )
    .orderBy(F.desc("total_paid"))
)

provider_summary.show()

# In Databricks, the final result could be written to a Delta table:
# provider_summary.write.format("delta").mode("overwrite").saveAsTable(
#     "healthcare.analytics.provider_summary"
# )
