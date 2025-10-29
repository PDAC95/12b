-- Bippi Database Schema - Row Level Security (RLS) Policies
-- Sprint 1 - US-002
-- Run this in Supabase SQL Editor after 002_create_indexes.sql

-- ============================================================================
-- ENABLE ROW LEVEL SECURITY
-- ============================================================================

-- Enable RLS on all user-data tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE purchases ENABLE ROW LEVEL SECURITY;
ALTER TABLE items ENABLE ROW LEVEL SECURITY;

-- Products and price_history are public (crowdsourced data)
-- Do not enable RLS on these tables

-- ============================================================================
-- USERS TABLE POLICIES
-- ============================================================================

-- Users can view their own profile
CREATE POLICY "Users can view own profile"
    ON users
    FOR SELECT
    USING (auth.uid() = id);

-- Users can update their own profile
CREATE POLICY "Users can update own profile"
    ON users
    FOR UPDATE
    USING (auth.uid() = id)
    WITH CHECK (auth.uid() = id);

-- Users can insert their own profile (signup)
CREATE POLICY "Users can insert own profile"
    ON users
    FOR INSERT
    WITH CHECK (auth.uid() = id);

-- ============================================================================
-- PURCHASES TABLE POLICIES
-- ============================================================================

-- Users can view their own purchases
CREATE POLICY "Users can view own purchases"
    ON purchases
    FOR SELECT
    USING (auth.uid() = user_id);

-- Users can create their own purchases
CREATE POLICY "Users can create own purchases"
    ON purchases
    FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- Users can update their own purchases
CREATE POLICY "Users can update own purchases"
    ON purchases
    FOR UPDATE
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- Users can delete their own purchases
CREATE POLICY "Users can delete own purchases"
    ON purchases
    FOR DELETE
    USING (auth.uid() = user_id);

-- ============================================================================
-- ITEMS TABLE POLICIES
-- ============================================================================

-- Users can view items from their own purchases
CREATE POLICY "Users can view items from own purchases"
    ON items
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM purchases
            WHERE purchases.id = items.purchase_id
            AND purchases.user_id = auth.uid()
        )
    );

-- Users can create items for their own purchases
CREATE POLICY "Users can create items for own purchases"
    ON items
    FOR INSERT
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM purchases
            WHERE purchases.id = items.purchase_id
            AND purchases.user_id = auth.uid()
        )
    );

-- Users can update items from their own purchases
CREATE POLICY "Users can update items from own purchases"
    ON items
    FOR UPDATE
    USING (
        EXISTS (
            SELECT 1 FROM purchases
            WHERE purchases.id = items.purchase_id
            AND purchases.user_id = auth.uid()
        )
    )
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM purchases
            WHERE purchases.id = items.purchase_id
            AND purchases.user_id = auth.uid()
        )
    );

-- Users can delete items from their own purchases
CREATE POLICY "Users can delete items from own purchases"
    ON items
    FOR DELETE
    USING (
        EXISTS (
            SELECT 1 FROM purchases
            WHERE purchases.id = items.purchase_id
            AND purchases.user_id = auth.uid()
        )
    );

-- ============================================================================
-- SUCCESS MESSAGE
-- ============================================================================
DO $$
BEGIN
    RAISE NOTICE 'SUCCESS: All RLS policies created successfully!';
    RAISE NOTICE 'Next step: Run 004_seed_test_data.sql (optional for development)';
    RAISE NOTICE '';
    RAISE NOTICE 'SECURITY NOTE:';
    RAISE NOTICE '- Users table: Users can only access their own profile';
    RAISE NOTICE '- Purchases table: Users can only access their own purchases';
    RAISE NOTICE '- Items table: Users can only access items from their purchases';
    RAISE NOTICE '- Products & price_history: Public read access (no RLS)';
END $$;
