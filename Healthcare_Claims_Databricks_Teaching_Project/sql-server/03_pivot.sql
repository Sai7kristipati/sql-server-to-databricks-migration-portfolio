-- Teaching example: conditional aggregation as a portable
-- alternative to a database-specific PIVOT implementation.

SELECT
    provider_id,
    SUM(CASE WHEN status = 'PAID' THEN amount ELSE 0 END) AS paid_amount,
    SUM(CASE WHEN status = 'DENIED' THEN amount ELSE 0 END) AS denied_amount,
    SUM(CASE WHEN status = 'PENDING' THEN amount ELSE 0 END) AS pending_amount
FROM claims
GROUP BY provider_id;
