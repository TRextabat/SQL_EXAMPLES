-- Staging: Customer demographic data
CREATE TABLE IF NOT EXISTS staging.customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    customer_segment VARCHAR(20), -- 'retail', 'premium', 'corporate'
    registration_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Load customer data
INSERT INTO staging.customers 
SELECT * FROM external_data.customer_info;

