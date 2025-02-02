\c postgres;

-- Terminate all connections
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE datname = 'BinderDBTest' AND pid <> pg_backend_pid();

-- Drop the database
DROP DATABASE IF EXISTS "BinderDBTest";
CREATE DATABASE "BinderDBTest";

DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
