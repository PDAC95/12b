# Bippi Database Setup

SQL scripts for setting up the Bippi database schema in Supabase.

## Prerequisites

1. Supabase project created: https://supabase.com/project/scandizhjakdgfzgvucz
2. Project is active (not paused)
3. SQL Editor access

## Execution Order

Run these scripts **in order** in the Supabase SQL Editor:

### 1. Create Tables
**File:** `001_create_tables.sql`

Creates all database tables:
- `users` - User profiles
- `purchases` - Shopping sessions
- `items` - Individual items in purchases
- `products` - Product catalog (crowdsourced)
- `price_history` - Price tracking across stores

```sql
-- Copy and paste the content of 001_create_tables.sql
-- into Supabase SQL Editor and run
```

### 2. Create Indexes
**File:** `002_create_indexes.sql`

Creates performance indexes for fast queries:
- User email lookups
- Purchase history queries
- Barcode lookups
- Price comparisons

### 3. Configure Row-Level Security
**File:** `003_create_rls_policies.sql`

Enables RLS and creates security policies:
- Users can only access their own data
- Cascade permissions for related data
- Public read access for products/price_history

### 4. Seed Test Data (Optional)
**File:** `004_seed_test_data.sql`

**⚠️ Development Only - DO NOT run in production**

Creates test data:
- Test user: `dev@jappi.ca` / `Password123`
- 2 sample purchases (Loblaws, No Frills)
- 28 items with realistic Canadian grocery data
- 13 products in catalog
- Price history for comparison

**Before running:** Create the test user in Supabase Auth first:
1. Go to **Authentication → Users** in Supabase Dashboard
2. Click **Invite User**
3. Email: `dev@jappi.ca`
4. Auto-generate password OR set to: `Password123`
5. Run the seed script

---

## How to Execute

### Option 1: Supabase SQL Editor (Recommended)

1. Go to https://supabase.com/project/scandizhjakdgfzgvucz/editor
2. Click **+ New query**
3. Copy content from `001_create_tables.sql`
4. Click **Run** (or press Cmd/Ctrl + Enter)
5. Verify success message appears
6. Repeat for scripts 002, 003, 004

### Option 2: Command Line (psql)

```bash
# Ensure you have the DATABASE_URL configured
source .env.development

# Run each script in order
psql $DATABASE_URL < sql/001_create_tables.sql
psql $DATABASE_URL < sql/002_create_indexes.sql
psql $DATABASE_URL < sql/003_create_rls_policies.sql
psql $DATABASE_URL < sql/004_seed_test_data.sql  # Optional
```

---

## Verification

After running all scripts, verify the setup:

```sql
-- Check tables exist
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

-- Should return:
-- items
-- price_history
-- products
-- purchases
-- users

-- Check indexes
SELECT indexname, tablename
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename, indexname;

-- Check RLS is enabled
SELECT tablename, rowsecurity
FROM pg_tables
WHERE schemaname = 'public';

-- Should show rowsecurity = true for users, purchases, items
```

---

## Test Data Summary

If you ran `004_seed_test_data.sql`:

**Test User:**
- Email: `dev@jappi.ca`
- Password: `Password123`
- Budget: $800/month

**Purchase 1 (Loblaws - 3 days ago):**
- Total: $87.43
- 14 items (milk, bread, eggs, chicken, bananas, etc.)

**Purchase 2 (No Frills - 1 day ago):**
- Total: $62.18
- 14 items (milk, bread, eggs, potatoes, beef, etc.)

**Price Comparison Data:**
- Milk 2% 2L: $5.49 (Loblaws), $4.99 (No Frills), $4.79 (Costco)
- Eggs 12pk: $4.99 (Loblaws), $4.49 (No Frills)
- Cheese 400g: $7.99 (Loblaws), $6.99 (No Frills), $6.49 (Walmart)

---

## Troubleshooting

### "relation already exists" error
The scripts use `IF NOT EXISTS` - safe to re-run.

### "auth.uid() does not exist" error
RLS policies depend on Supabase Auth. Ensure:
1. User is authenticated
2. Query is executed with user JWT token

### Cannot connect to database
Check:
1. Project is not paused (reactivate in Supabase dashboard)
2. `DATABASE_URL` in `.env.development` is correct
3. Password contains no special characters that need URL encoding

### Test data script fails
Ensure test user `dev@jappi.ca` exists in **Authentication → Users** before running seed script.

---

## Schema Diagram

```
users (1) ─────< purchases (N)
                    │
                    └────< items (N)
                              │
                              └───> products (1) ────< price_history (N)
```

---

## Next Steps

After database setup:
1. Test connection from backend: `python test_connection.py`
2. Create FastAPI models matching the schema
3. Implement API endpoints for CRUD operations
4. Test with mobile app

---

**Last Updated:** October 29, 2025
**Sprint:** Sprint 1 - US-002
