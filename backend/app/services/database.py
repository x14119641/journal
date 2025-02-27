import asyncpg
import os
from .logger_config import get_logger



db_logger = get_logger("DatabaseService", "database.log")


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
        try:
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
            # db_logger.info("Database connection pool created successfully.")
        except Exception as e:
            db_logger.error(f"Error in create_pool. <Error> {str(e)}")
            self.pool = None
    
    async def close_pool(self):
        """Close the connection pool."""
        if self.pool:
            await self.pool.close()
            # db_logger.info("Database connection pool closed.")
        else:
            db_logger.warning("Attempted to close an uninitialized connection pool.")
    
    async def execute(self, query, *args):
        """Execute a query without returning results."""
        if not self.pool:
            db_logger.error("Database connection pool is not initialized.")
            return None
        
        async with self.pool.acquire() as conn:
            try:
                async with conn.transaction():
                    # db_logger.info(query, args)
                    return await conn.execute(query, *args)
            except Exception as e:
                db_logger.error(f"Error exequting the query: {query}. <Error> {str(e)}")

    async def fetch(self, query, *args):
        """Execute a query and return results."""
        if not self.pool:
            db_logger.error("Database connection pool is not initialized.")
            return None
        async with self.pool.acquire() as conn:
            try:
                async with conn.transaction():
                    records = await conn.fetch(query, *args)
                    # db_logger.info(records)
                    return [dict(record) for record in records] if records else None
            except Exception as e:
                db_logger.error(f"Error fetching the query: {query}. <Error> {str(e)}")
                return None
 
    
    async def fetchone(self, query, *args):
        """Execute a query and return one result."""
        if not self.pool:
            db_logger.error("Database connection pool is not initialized.")
            return None
        
        async with self.pool.acquire() as conn:
            try:
                async with conn.transaction():
                    return await conn.fetchval(query, *args)
            except Exception as e:
                db_logger.error(f"Error fetching one value: {query}. <Error> {str(e)}")
                return None
    
    async def fetchrow(self, query, *args):
        """Execute a query returning a row."""
        if not self.pool:
            db_logger.error("Database connection pool is not initialized.")
            return None

        async with self.pool.acquire() as conn:
            try:
                async with conn.transaction():
                    record = await conn.fetchrow(query, *args)
                    # db.logger.info(record)
                    return dict(record) if record else None
            except Exception as e:
                db_logger.error(f"Error fetching row: {query}. <Error> {str(e)}")
                return None

    async def create_schema(self):
        """Create the database schema."""
        query = self.read_sql('create_schema')
        if not query:
            db_logger.error("Schema creation failed: SQL file is empty or not found.")
            return

        try:
            await self.execute(query)
            db_logger.info("Database schema created successfully.")
        except Exception as e:
            db_logger.error(f"Error in create_schema. <Error> {str(e)}")

    def read_sql(self, file_name):
        """Read an SQL file and return its contents."""
        file_dir = os.path.dirname(os.path.realpath(__file__))
        try:
            with open(os.path.join(file_dir, f'{file_name}.sql'), 'r') as f:
                return f.read()
        except FileNotFoundError:
            db_logger.error(f"SQL file {file_name}.sql not found.")
            return None
