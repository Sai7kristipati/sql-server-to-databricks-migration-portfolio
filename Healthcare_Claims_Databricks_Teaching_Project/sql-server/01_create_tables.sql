-- Synthetic healthcare claims database
-- Educational use only

CREATE TABLE patients (
    patient_id VARCHAR(20) PRIMARY KEY,
    patient_name VARCHAR(100),
    state VARCHAR(20)
);

CREATE TABLE providers (
    provider_id VARCHAR(20) PRIMARY KEY,
    provider_name VARCHAR(100),
    specialty VARCHAR(100)
);

CREATE TABLE claims (
    claim_id VARCHAR(20) PRIMARY KEY,
    patient_id VARCHAR(20),
    provider_id VARCHAR(20),
    service_date DATE,
    status VARCHAR(20),
    amount DECIMAL(12,2)
);

INSERT INTO patients VALUES
('P001', 'Patient One', 'TX'),
('P002', 'Patient Two', 'CA'),
('P003', 'Patient Three', 'NY'),
('P004', 'Patient Four', 'TX'),
('P005', 'Patient Five', 'FL');

INSERT INTO providers VALUES
('PR001', 'Dr. Rao', 'Cardiology'),
('PR002', 'Dr. Chen', 'Orthopedics'),
('PR003', 'Dr. Smith', 'Neurology');

INSERT INTO claims VALUES
('C001','P001','PR001','2026-01-05','PAID',2500.00),
('C002','P002','PR001','2026-01-06','PAID',4150.00),
('C003','P003','PR002','2026-01-07','PAID',1800.00),
('C004','P004','PR002','2026-01-08','DENIED',900.00),
('C005','P005','PR003','2026-01-10','PAID',1600.00),
('C006','P001','PR003','2026-01-12','PENDING',1200.00),
('C007','P002','PR001','2026-01-15','PAID',0.00);
