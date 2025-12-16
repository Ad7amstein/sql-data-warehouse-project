-- Create Database 'DataWarehouse'

USE master;

CREATE DATABASE DataWarehouse;

-- Create Schemas

USE DataWarehouse;

CREATE SCHEMA bronze;
GO
CREATE SCHEMA sliver;
GO
CREATE SCHEMA gold;
GO