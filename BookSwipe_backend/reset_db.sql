\c postgres;

-- Terminate all connections
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE datname = 'BinderDBTest' AND pid <> pg_backend_pid();

-- Drop and recreate the database
DROP DATABASE IF EXISTS "BinderDBTest";
CREATE DATABASE "BinderDBTest";

-- Connect to the new database and reset its schema
\c BinderDBTest;

DROP SCHEMA IF EXISTS public CASCADE;
CREATE SCHEMA public;

-- Grant privileges (optional but recommended)
ALTER SCHEMA public OWNER TO postgres;

