-- Bippi Database Schema - Seed Test Data
-- Sprint 1 - US-002
-- Run this in Supabase SQL Editor (OPTIONAL - for development only)

-- ============================================================================
-- WARNING: This script creates test data for DEVELOPMENT ONLY
-- DO NOT run this in production!
-- ============================================================================

-- Note: You need to create a test user in Supabase Auth first
-- Email: dev@jappi.ca
-- Password: Password123

-- Then get the user UUID from the auth.users table and replace below

-- ============================================================================
-- INSERT TEST USER (Manual step required)
-- ============================================================================
-- 1. Go to Authentication > Users in Supabase Dashboard
-- 2. Create user: dev@jappi.ca / Password123
-- 3. Copy the user UUID
-- 4. Replace 'YOUR-USER-UUID-HERE' below with the actual UUID

DO $$
DECLARE
    test_user_id UUID;
    purchase1_id UUID;
    purchase2_id UUID;
    product1_id UUID;
    product2_id UUID;
    product3_id UUID;
BEGIN
    -- Get the test user ID from auth.users
    SELECT id INTO test_user_id
    FROM auth.users
    WHERE email = 'dev@jappi.ca'
    LIMIT 1;

    IF test_user_id IS NULL THEN
        RAISE EXCEPTION 'Test user dev@jappi.ca not found in auth.users. Please create it first in Supabase Auth.';
    END IF;

    RAISE NOTICE 'Found test user: %', test_user_id;

    -- ========================================================================
    -- INSERT TEST USER DATA
    -- ========================================================================
    INSERT INTO users (id, email, name, monthly_budget)
    VALUES (
        test_user_id,
        'dev@jappi.ca',
        'Dev User',
        800.00
    )
    ON CONFLICT (id) DO UPDATE
    SET name = EXCLUDED.name,
        monthly_budget = EXCLUDED.monthly_budget;

    RAISE NOTICE 'Created/Updated user profile';

    -- ========================================================================
    -- INSERT TEST PURCHASES
    -- ========================================================================

    -- Purchase 1: Loblaws
    INSERT INTO purchases (id, user_id, store_name, total_amount, purchase_date)
    VALUES (
        uuid_generate_v4(),
        test_user_id,
        'Loblaws',
        87.43,
        NOW() - INTERVAL '3 days'
    )
    RETURNING id INTO purchase1_id;

    -- Purchase 2: No Frills
    INSERT INTO purchases (id, user_id, store_name, total_amount, purchase_date)
    VALUES (
        uuid_generate_v4(),
        test_user_id,
        'No Frills',
        62.18,
        NOW() - INTERVAL '1 day'
    )
    RETURNING id INTO purchase2_id;

    RAISE NOTICE 'Created 2 test purchases';

    -- ========================================================================
    -- INSERT TEST ITEMS FOR PURCHASE 1 (Loblaws)
    -- ========================================================================

    INSERT INTO items (purchase_id, barcode, product_name, price)
    VALUES
        (purchase1_id, '061200010166', 'Milk 2% 2L Beatrice', 5.49),
        (purchase1_id, '057000004958', 'Bread Wonder White', 3.29),
        (purchase1_id, '063211004113', 'Eggs Large 12pk', 4.99),
        (purchase1_id, '068100092318', 'Chicken Breast 1kg', 15.99),
        (purchase1_id, NULL, 'Bananas (loose)', 2.87),
        (purchase1_id, '059749890137', 'Yogurt Greek Oikos Vanilla 4x100g', 5.99),
        (purchase1_id, '063211001258', 'Cheese Cheddar Black Diamond 400g', 7.99),
        (purchase1_id, '055451000192', 'Pasta Barilla Penne 500g', 1.99),
        (purchase1_id, '073400705902', 'Tomato Sauce Classico 650mL', 3.49),
        (purchase1_id, NULL, 'Apples Gala (3 lbs)', 5.97),
        (purchase1_id, '063211004441', 'Butter Lactantia 454g', 6.99),
        (purchase1_id, '061300341005', 'Orange Juice Tropicana 1.54L', 4.99),
        (purchase1_id, '062639401092', 'Coffee Folgers 920g', 12.99),
        (purchase1_id, '084114079411', 'Cereal Cheerios 430g', 5.49);

    RAISE NOTICE 'Created 14 items for Purchase 1 (Loblaws)';

    -- ========================================================================
    -- INSERT TEST ITEMS FOR PURCHASE 2 (No Frills)
    -- ========================================================================

    INSERT INTO items (purchase_id, barcode, product_name, price)
    VALUES
        (purchase2_id, '061200010166', 'Milk 2% 2L Beatrice', 4.99),
        (purchase2_id, '057000004958', 'Bread Wonder White', 2.99),
        (purchase2_id, '063211004113', 'Eggs Large 12pk', 4.49),
        (purchase2_id, NULL, 'Potatoes 5lb bag', 3.99),
        (purchase2_id, NULL, 'Tomatoes (1.5 lbs)', 4.47),
        (purchase2_id, NULL, 'Onions (3 lbs)', 2.97),
        (purchase2_id, '063211001258', 'Cheese Cheddar Black Diamond 400g', 6.99),
        (purchase2_id, '055451000192', 'Pasta Barilla Penne 500g', 1.79),
        (purchase2_id, '068100730039', 'Ground Beef 500g', 8.99),
        (purchase2_id, NULL, 'Carrots (2 lbs)', 2.98),
        (purchase2_id, '063211004441', 'Butter Lactantia 454g', 6.49),
        (purchase2_id, '084114079411', 'Cereal Cheerios 430g', 4.99),
        (purchase2_id, NULL, 'Green Peppers (2 units)', 3.98),
        (purchase2_id, NULL, 'Cucumber (1 unit)', 1.29);

    RAISE NOTICE 'Created 14 items for Purchase 2 (No Frills)';

    -- ========================================================================
    -- INSERT TEST PRODUCTS (Catalog)
    -- ========================================================================

    INSERT INTO products (id, barcode, common_name, category)
    VALUES
        (uuid_generate_v4(), '061200010166', 'Milk 2% 2L', 'Dairy'),
        (uuid_generate_v4(), '057000004958', 'Bread White Loaf', 'Bakery'),
        (uuid_generate_v4(), '063211004113', 'Eggs Large 12pk', 'Dairy'),
        (uuid_generate_v4(), '068100092318', 'Chicken Breast', 'Meat'),
        (uuid_generate_v4(), '059749890137', 'Greek Yogurt Vanilla', 'Dairy'),
        (uuid_generate_v4(), '063211001258', 'Cheddar Cheese 400g', 'Dairy'),
        (uuid_generate_v4(), '055451000192', 'Pasta Penne 500g', 'Grocery'),
        (uuid_generate_v4(), '073400705902', 'Tomato Sauce 650mL', 'Grocery'),
        (uuid_generate_v4(), '063211004441', 'Butter 454g', 'Dairy'),
        (uuid_generate_v4(), '061300341005', 'Orange Juice 1.54L', 'Beverages'),
        (uuid_generate_v4(), '062639401092', 'Coffee Ground 920g', 'Grocery'),
        (uuid_generate_v4(), '084114079411', 'Cereal Cheerios 430g', 'Grocery'),
        (uuid_generate_v4(), '068100730039', 'Ground Beef 500g', 'Meat')
    ON CONFLICT (barcode) DO NOTHING
    RETURNING id INTO product1_id;

    RAISE NOTICE 'Created test products in catalog';

    -- ========================================================================
    -- INSERT PRICE HISTORY (for future price comparison feature)
    -- ========================================================================

    -- Get product IDs for price history
    SELECT id INTO product1_id FROM products WHERE barcode = '061200010166' LIMIT 1;
    SELECT id INTO product2_id FROM products WHERE barcode = '063211004113' LIMIT 1;
    SELECT id INTO product3_id FROM products WHERE barcode = '063211001258' LIMIT 1;

    IF product1_id IS NOT NULL THEN
        INSERT INTO price_history (product_id, store_name, price, reported_by, reported_at)
        VALUES
            (product1_id, 'Loblaws', 5.49, test_user_id, NOW() - INTERVAL '3 days'),
            (product1_id, 'No Frills', 4.99, test_user_id, NOW() - INTERVAL '1 day'),
            (product1_id, 'Costco', 4.79, test_user_id, NOW() - INTERVAL '7 days');

        RAISE NOTICE 'Created price history for Milk';
    END IF;

    IF product2_id IS NOT NULL THEN
        INSERT INTO price_history (product_id, store_name, price, reported_by, reported_at)
        VALUES
            (product2_id, 'Loblaws', 4.99, test_user_id, NOW() - INTERVAL '3 days'),
            (product2_id, 'No Frills', 4.49, test_user_id, NOW() - INTERVAL '1 day');

        RAISE NOTICE 'Created price history for Eggs';
    END IF;

    IF product3_id IS NOT NULL THEN
        INSERT INTO price_history (product_id, store_name, price, reported_by, reported_at)
        VALUES
            (product3_id, 'Loblaws', 7.99, test_user_id, NOW() - INTERVAL '3 days'),
            (product3_id, 'No Frills', 6.99, test_user_id, NOW() - INTERVAL '1 day'),
            (product3_id, 'Walmart', 6.49, test_user_id, NOW() - INTERVAL '5 days');

        RAISE NOTICE 'Created price history for Cheese';
    END IF;

    -- ========================================================================
    -- SUCCESS MESSAGE
    -- ========================================================================
    RAISE NOTICE '';
    RAISE NOTICE '========================================';
    RAISE NOTICE 'SUCCESS: Test data seeded successfully!';
    RAISE NOTICE '========================================';
    RAISE NOTICE '';
    RAISE NOTICE 'Test User: dev@jappi.ca (UUID: %)', test_user_id;
    RAISE NOTICE 'Created:';
    RAISE NOTICE '  - 1 user profile (monthly budget: $800)';
    RAISE NOTICE '  - 2 purchases (Loblaws: $87.43, No Frills: $62.18)';
    RAISE NOTICE '  - 28 items across both purchases';
    RAISE NOTICE '  - 13 products in catalog';
    RAISE NOTICE '  - Price history for 3 products';
    RAISE NOTICE '';
    RAISE NOTICE 'You can now test the app with: dev@jappi.ca / Password123';

END $$;
