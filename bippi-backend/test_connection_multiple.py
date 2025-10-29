"""
Test multiple connection string formats
"""
import os
import asyncio
from dotenv import load_dotenv
import asyncpg

# Load environment variables
load_dotenv('.env.development')

async def test_connection_format(conn_string, name):
    """Test a specific connection string format"""
    print(f"\n[{name}]")
    print(f"Testing: {conn_string.split('@')[0].split(':')[0]}://...@{conn_string.split('@')[1]}")

    try:
        conn = await asyncpg.connect(conn_string, timeout=10)
        version = await conn.fetchval('SELECT version()')
        print(f"[SUCCESS] Connected!")
        print(f"PostgreSQL: {version.split(',')[0]}")
        await conn.close()
        return True
    except Exception as e:
        print(f"[FAIL] {str(e)[:80]}")
        return False

async def main():
    """Test all connection formats"""
    password = "2555Krugst@"
    password_encoded = "2555Krugst%40"

    formats = [
        # Direct connection (Session mode)
        (f"postgresql://postgres:{password_encoded}@db.scandizhjakdgfzgvucz.supabase.co:5432/postgres", "Direct Connection"),

        # Transaction pooling
        (f"postgresql://postgres.scandizhjakdgfzgvucz:{password_encoded}@aws-0-us-east-1.pooler.supabase.com:6543/postgres", "Transaction Pooling"),

        # Session pooling
        (f"postgresql://postgres.scandizhjakdgfzgvucz:{password_encoded}@aws-0-us-east-1.pooler.supabase.com:5432/postgres", "Session Pooling"),
    ]

    print("=" * 70)
    print("Testing Supabase Connection Formats")
    print("=" * 70)

    for conn_string, name in formats:
        success = await test_connection_format(conn_string, name)
        if success:
            print(f"\n{'='*70}")
            print(f"WORKING CONNECTION STRING FOUND!")
            print(f"{'='*70}")
            print(f"Use this in .env.development:")
            print(f"DATABASE_URL={conn_string}")
            break
        await asyncio.sleep(1)

if __name__ == "__main__":
    asyncio.run(main())
