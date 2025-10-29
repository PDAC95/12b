-- Bippi Database Schema - Create Tables
-- Sprint 1 - US-002
-- Run this in Supabase SQL Editor: https://supabase.com/project/scandizhjakdgfzgvucz/editor

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================================
-- USERS TABLE
-- ============================================================================
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255),
    monthly_budget DECIMAL(10,2) DEFAULT 600.00,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

COMMENT ON TABLE users IS 'Users of the Bippi application';
COMMENT ON COLUMN users.monthly_budget IS 'Monthly grocery budget in CAD';

-- ============================================================================
-- PURCHASES TABLE
-- ============================================================================
CREATE TABLE IF NOT EXISTS purchases (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    store_name VARCHAR(100) NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL CHECK (total_amount >= 0),
    purchase_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

COMMENT ON TABLE purchases IS 'Shopping sessions at grocery stores';
COMMENT ON COLUMN purchases.store_name IS 'Name of the store (e.g., Loblaws, No Frills, Costco)';
COMMENT ON COLUMN purchases.latitude IS 'Optional: Store location latitude';
COMMENT ON COLUMN purchases.longitude IS 'Optional: Store location longitude';

-- ============================================================================
-- ITEMS TABLE
-- ============================================================================
CREATE TABLE IF NOT EXISTS items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    purchase_id UUID NOT NULL REFERENCES purchases(id) ON DELETE CASCADE,
    barcode VARCHAR(50),
    product_name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

COMMENT ON TABLE items IS 'Individual items within a purchase';
COMMENT ON COLUMN items.barcode IS 'Optional: UPC-A or EAN-13 barcode';
COMMENT ON COLUMN items.product_name IS 'User-entered or looked-up product name';

-- ============================================================================
-- PRODUCTS TABLE (Catalog)
-- ============================================================================
CREATE TABLE IF NOT EXISTS products (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    barcode VARCHAR(50) UNIQUE NOT NULL,
    common_name VARCHAR(255),
    category VARCHAR(50),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

COMMENT ON TABLE products IS 'Master product catalog (crowdsourced)';
COMMENT ON COLUMN products.barcode IS 'UPC-A or EAN-13 barcode (unique identifier)';
COMMENT ON COLUMN products.common_name IS 'Most common product name';
COMMENT ON COLUMN products.category IS 'Product category (e.g., Dairy, Produce, Meat)';

-- ============================================================================
-- PRICE HISTORY TABLE (Crowdsourced Pricing)
-- ============================================================================
CREATE TABLE IF NOT EXISTS price_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    store_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    reported_by UUID REFERENCES users(id) ON DELETE SET NULL,
    reported_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

COMMENT ON TABLE price_history IS 'Historical price data across stores (for future price comparison)';
COMMENT ON COLUMN price_history.reported_by IS 'User who reported this price (anonymized in queries)';

-- ============================================================================
-- SUCCESS MESSAGE
-- ============================================================================
DO $$
BEGIN
    RAISE NOTICE 'SUCCESS: All tables created successfully!';
    RAISE NOTICE 'Next step: Run 002_create_indexes.sql';
END $$;
