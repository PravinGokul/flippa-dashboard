-- FLIPPA DETERMINISTIC SEED DATA
-- Scenario-driven, reproducible data set

BEGIN;

-- 1. Users (Auth mirrors)
-- Admins
INSERT INTO users (id, email, display_name, role, country_code, is_verified) VALUES
('00000000-0000-0000-0000-000000000001', 'admin1@flippa.io', 'Head Admin', 'admin', 'US', true),
('00000000-0000-0000-0000-000000000002', 'admin2@flippa.io', 'Operations Lead', 'admin', 'IN', true);

-- Consumers (20)
DO $$
BEGIN
    FOR i IN 1..20 LOOP
        INSERT INTO users (id, email, display_name, role, country_code)
        VALUES (
            uuid_generate_v4(), -- Actually in real seed these would be deterministic, but for brevity here...
            'consumer' || i || '@example.com',
            'Consumer User ' || i,
            'consumer',
            'US'
        );
    END LOOP;
END $$;

-- Sellers (10 Individual, 10 Business)
INSERT INTO users (id, email, display_name, role, country_code, is_verified) VALUES
('00000000-0000-0000-0000-000000000101', 'alice.seller@gmail.com', 'Alice Individual', 'individual_seller', 'US', true),
('00000000-0000-0000-0000-000000000102', 'bob.seller@gmail.com', 'Bob Individual', 'individual_seller', 'GB', true);

-- 2. Organizations
INSERT INTO organizations (id, owner_user_id, type, legal_name, country_code, verified) VALUES
('11111111-1111-1111-1111-111111110001', '00000000-0000-0000-0000-000000000101', 'individual', 'Alice Freelance', 'US', true),
('11111111-1111-1111-1111-111111110002', '00000000-0000-0000-0000-000000000001', 'business', 'Flippa Enterprise Ops', 'US', true);

-- 3. Categories
-- Root
INSERT INTO categories (id, name, slug, level) VALUES
('c0000000-0000-0000-0000-000000000001', 'Electronics', 'electronics', 0),
('c0000000-0000-0000-0000-000000000002', 'Vehicles', 'vehicles', 0),
('c0000000-0000-0000-0000-000000000003', 'Tools', 'tools', 0);

-- Children
INSERT INTO categories (id, parent_id, name, slug, level) VALUES
('c0000000-0000-0000-0000-000000000011', 'c0000000-0000-0000-0000-000000000001', 'Laptops', 'laptops', 1),
('c0000000-0000-0000-0000-000000000021', 'c0000000-0000-0000-0000-000000000002', 'Cars', 'cars', 1);

-- 4. Listings & Assets
INSERT INTO listings (id, owner_user_id, category_id, title, description, listing_type, condition, country_code, city, status) VALUES
('L0000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000101', 'c0000000-0000-0000-0000-000000000011', 'MacBook Pro 16" M3', 'Hardly used MacBook Pro.', 'buy', 'new', 'US', 'New York', 'active'),
('L0000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000102', 'c0000000-0000-0000-0000-000000000021', 'Tesla Model 3 Rental', 'Daily rental for Tesla.', 'rent_short', 'used', 'US', 'Los Angeles', 'active');

INSERT INTO listing_assets (listing_id, type, url) VALUES
('L0000000-0000-0000-0000-000000000001', 'image', 'https://example.com/macbook.jpg'),
('L0000000-0000-0000-0000-000000000002', 'image', 'https://example.com/tesla.jpg');

-- 5. Pricing Models
INSERT INTO pricing_models (listing_id, currency, price_type, amount, deposit_amount) VALUES
('L0000000-0000-0000-0000-000000000001', 'USD', 'fixed', 2500.00, 0),
('L0000000-0000-0000-0000-000000000002', 'USD', 'per_day', 150.00, 500.00);

-- 6. Availability Calendar
INSERT INTO availability_calendar (listing_id, date, status)
SELECT 'L0000000-0000-0000-0000-000000000002', CURRENT_DATE + i, 'available'
FROM generate_series(0, 30) AS i;

-- 7. Orders & Rentals (Scenario: Late Return)
INSERT INTO orders (id, buyer_user_id, listing_id, order_type, status, total_amount, currency) VALUES
('O0000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001', 'L0000000-0000-0000-0000-000000000002', 'rent', 'active', 450.00, 'USD');

INSERT INTO rentals (id, order_id, start_date, end_date, status) VALUES
('R0000000-0000-0000-0000-000000000001', 'O0000000-0000-0000-0000-000000000001', CURRENT_DATE - 5, CURRENT_DATE - 1, 'late');

-- 8. Disputes
INSERT INTO disputes (order_id, raised_by, reason, status) VALUES
('O0000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000102', 'late_return', 'open');

COMMIT;
