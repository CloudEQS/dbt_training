{{ config(
    tags=['mdl_daily'],
    materialized='incremental',        -- avoids full table rebuild; processes only new/changed rows each run, cutting compute cost and runtime
    incremental_strategy='merge',      -- MERGE (upsert) on unique_key instead of append/delete+insert; keeps one row per user, updates in place
    unique_key='id',                   -- column dbt uses to match existing rows during merge
    table_type='iceberg',              -- Iceberg format gives ACID transactions, time travel, schema evolution, and native compaction/vacuum support on Athena
    format='parquet',                  -- columnar storage; faster scans + better compression than row formats like CSV/JSON
    write_compression='zstd',          -- higher compression ratio than snappy/gzip at similar CPU cost -> smaller files, less S3 storage, faster reads
    table_properties={
        'optimize_rewrite_delete_file_threshold': '2',   -- after 2 delete files accumulate on a data file, auto-trigger compaction to merge them away
        'optimize_rewrite_data_file_threshold': '5',     -- after 5 small data files pile up, auto-trigger compaction into fewer larger files
        'vacuum_min_snapshots_to_keep': '5',             -- always retain at least the last 5 snapshots for rollback/time-travel safety
        'vacuum_max_snapshot_age_seconds': '259200'      -- expire snapshots older than 3 days to control metadata/storage growth
    },
    post_hook=[
        "OPTIMIZE {{ this }} REWRITE DATA USING BIN_PACK",  -- runs after every load: bin-packs small files into fewer, right-sized files -> fewer S3 GET requests, faster downstream queries
        "VACUUM {{ this }}"                                 -- runs after every load: expires old snapshots and removes orphaned data files per the thresholds above, keeping storage costs down
    ]
) }}

with users as (
    select *
    from {{ ref('sfdc_user') }}    -- source: base Salesforce user dimension, reused twice below (self + manager)
)

select
    u.id,
    u.last_modified_date_et,
    u.is_active,
    u.full_name,
    u.svp_srv_sales_team as srv_sales_team,
    u.svp_srv_team_group as srv_team_group,
    u.quote_approver_svp_id,
    u.manager_id,
    mgr.full_name as manager_name,      -- pulled from self-join so we don't need a separate lookup model
    u.quote_approver_manager_id
from users u
left join users mgr                     -- self-join: each user's manager is itself a row in the same source
    on u.manager_id = mgr.id
{% if is_incremental() %}
-- incremental filter: only reprocess a user if THEY changed, or if THEIR MANAGER's record changed
-- (needed because manager_name is denormalized here — a manager's name change must cascade to all their reports)
where u.last_modified_date_et > (select max(last_modified_date_et) from {{ this }})
   or mgr.last_modified_date_et > (select max(last_modified_date_et) from {{ this }})
{% endif %}
