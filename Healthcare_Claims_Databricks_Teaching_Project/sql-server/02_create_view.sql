-- Legacy SQL Server-style view

CREATE VIEW v_paid_claims AS
SELECT
    c.claim_id,
    c.patient_id,
    c.provider_id,
    c.service_date,
    c.amount,
    CASE
        WHEN c.amount >= 4000 THEN 'HIGH'
        WHEN c.amount >= 2000 THEN 'MEDIUM'
        ELSE 'LOW'
    END AS claim_band
FROM claims c
WHERE c.status = 'PAID';
