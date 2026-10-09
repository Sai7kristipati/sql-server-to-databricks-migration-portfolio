-- Source-to-target validation examples

-- 1. Row count
SELECT COUNT(*) AS row_count
FROM claims;

-- 2. Distinct claim IDs
SELECT COUNT(DISTINCT claim_id) AS distinct_claims
FROM claims;

-- 3. Duplicate check
SELECT claim_id, COUNT(*) AS record_count
FROM claims
GROUP BY claim_id
HAVING COUNT(*) > 1;

-- 4. NULL provider IDs
SELECT COUNT(*) AS null_provider_count
FROM claims
WHERE provider_id IS NULL;

-- 5. Business total
SELECT
    SUM(CASE WHEN status = 'PAID' THEN amount ELSE 0 END) AS total_paid
FROM claims;

-- In a migration project, run equivalent checks on the target
-- and compare the results.
