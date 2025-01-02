import asyncpg
import os

class Database:
    def __init__(self, host, user, password, database, port=5432):
        self.host = host
        self.user = user
        self.password = password
        self.database = database
        self.port = port
        self.pool = None

    async def create_pool(self):
        """Create a connection pool."""
        self.pool = await asyncpg.create_pool(
            host=self.host,
            user=self.user,
            password=self.password,
            database=self.database,
            port=self.port,
            max_size=10,  # Max pool size
            max_queries=50000,  # Max queries per connection before being closed
            min_size=1,  # Minimum pool size
            timeout=60.0  # Timeout for acquiring a connection from the pool
        )
        print(f"Pool created: {self.pool}")
    
    async def close_pool(self):
        """Close the connection pool."""
        if self.pool:
            await self.pool.close()
            print(f"Pool closed.")
    
    async def execute(self, query, *args):
        """Execute a query without returning results."""
        async with self.pool.acquire() as conn:
            # print(f"Executing query: {query}")
            return await conn.execute(query, *args)

    async def fetch(self, query, *args):
        """Execute a query and return results."""
        async with self.pool.acquire() as conn:
            records = await conn.fetch(query, *args)
            if records:
                return [dict(record) for record in records]
            return None
 
    
    async def fetchone(self, query, *args):
        """Execute a query and return one result."""
        async with self.pool.acquire() as conn:
            # print(f"Fetching query: {query}")
            val = await conn.fetchval(query, *args)
            return dict(val) if val else None
    
    async def fetchrow(self, query, *args):
        """Execute a query and return one row."""
        async with self.pool.acquire() as conn:
            # print(f"Fetching query: {query}")
            record = await conn.fetchrow(query, *args)
            return dict(record) if record else None
    
    async def create_schema(self):
        """Create the database schema."""
        query = self.read_sql('create_schema')
        await self.execute(query)
        
    def read_sql(self, file_name):
        file_dir = os.path.dirname(os.path.realpath(__file__))
        with open(os.path.join(file_dir, f'{file_name}.sql'), 'r') as f:
            data = f.read()
        return data
