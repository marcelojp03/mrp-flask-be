-- Script para aplicar todas las migraciones de Sprint 4
-- Ejecutar: psql -h <host> -U <user> -d <database> -f apply_sprint4_migrations.sql

\echo 'Aplicando migraciones Sprint 4...'
\echo ''

\echo '=== Migration 016: demand table ==='
\i migrations/016_create_demand_table.sql
\echo ''

\echo '=== Migration 017: mps_plan table ==='
\i migrations/017_create_mps_plan_table.sql
\echo ''

\echo '=== Migration 018: mrp_proposal table ==='
\i migrations/018_create_mrp_proposal_table.sql
\echo ''

\echo '✅ Migraciones Sprint 4 aplicadas exitosamente!'
