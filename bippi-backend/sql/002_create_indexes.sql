-- Bippi Database Schema - Create Indexes
-- Sprint 1 - US-002
-- Run this in Supabase SQL Editor after 001_create_tables.sql

-- ============================================================================
-- INDEXES FOR PERFORMANCE
-- ============================================================================

-- Users indexes
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
COMMENT ON INDEX idx_users_email IS 'Fast lookup by email for authentication';

-- Purchases indexes
CREATE INDEX IF NOT EXISTS idx_purchases_user_id ON purchases(user_id);
CREATE INDEX IF NOT EXISTS idx_purchases_date ON purchases(purchase_date DESC);
CREATE INDEX IF NOT EXISTS idx_purchases_store ON purchases(store_name);
CREATE INDEX IF NOT EXISTS idx_purchases_user_date ON purchases(user_id, purchase_date DESC);

COMMENT ON INDEX idx_purchases_user_id IS 'Fast lookup of purchases by user';
COMMENT ON INDEX idx_purchases_date IS 'Fast sorting by date (newest first)';
COMMENT ON INDEX idx_purchases_store IS 'Filter purchases by store name';
COMMENT ON INDEX idx_purchases_user_date IS 'Composite index for user purchase history queries';

-- Items indexes
CREATE INDEX IF NOT EXISTS idx_items_purchase_id ON items(purchase_id);
CREATE INDEX IF NOT EXISTS idx_items_barcode ON items(barcode);
CREATE INDEX IF NOT EXISTS idx_items_product_name ON items(product_name);

COMMENT ON INDEX idx_items_purchase_id IS 'Fast lookup of items within a purchase';
COMMENT ON INDEX idx_items_barcode IS 'Fast barcode lookups for frequent products';
COMMENT ON INDEX idx_items_product_name IS 'Text search on product names';

-- Products indexes
CREATE INDEX IF NOT EXISTS idx_products_barcode ON products(barcode);
CREATE INDEX IF NOT EXISTS idx_products_category ON products(category);

COMMENT ON INDEX idx_products_barcode IS 'Fast barcode lookups (already unique, but explicit index)';
COMMENT ON INDEX idx_products_category IS 'Filter products by category';

-- Price History indexes
CREATE INDEX IF NOT EXISTS idx_price_history_product_id ON price_history(product_id);
CREATE INDEX IF NOT EXISTS idx_price_history_store ON price_history(store_name);
CREATE INDEX IF NOT EXISTS idx_price_history_date ON price_history(reported_at DESC);
CREATE INDEX IF NOT EXISTS idx_price_history_product_store ON price_history(product_id, store_name, reported_at DESC);

COMMENT ON INDEX idx_price_history_product_id IS 'Fast lookup of price history for a product';
COMMENT ON INDEX idx_price_history_store IS 'Filter price history by store';
COMMENT ON INDEX idx_price_history_date IS 'Sort price history by date';
COMMENT ON INDEX idx_price_history_product_store IS 'Composite index for price comparison queries';

-- ============================================================================
-- SUCCESS MESSAGE
-- ============================================================================
DO $$
BEGIN
    RAISE NOTICE 'SUCCESS: All indexes created successfully!';
    RAISE NOTICE 'Next step: Run 003_create_rls_policies.sql';
END $$;
