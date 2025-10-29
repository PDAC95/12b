"""
Test Supabase connection
Run: python test_connection.py
"""
import os
import asyncio
from dotenv import load_dotenv
import asyncpg

# Load environment variables
load_dotenv('.env.development')

async def test_connection():
    """Test database connection"""
    database_url = os.getenv('DATABASE_URL')

    if not database_url:
        print("❌ DATABASE_URL not found in environment variables")
        return False

    print("Testing connection to Supabase...")
    print(f"URL: {database_url.split('@')[1].split(':')[0]}")  # Show only host

    try:
        # Try to connect
        conn = await asyncpg.connect(database_url)

        # Test query
        version = await conn.fetchval('SELECT version()')
        print("[SUCCESS] Connection successful!")
        print(f"PostgreSQL version: {version.split(',')[0]}")

        # Close connection
        await conn.close()
        return True

    except Exception as e:
        print(f"[FAIL] Connection failed: {e}")
        return False

if __name__ == "__main__":
    success = asyncio.run(test_connection())
    exit(0 if success else 1)
