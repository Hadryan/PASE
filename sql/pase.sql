---------------------------------------------------------------------------
--
-- pase.sql-
--    This file shows how to use pase extension.
--
---------------------------------------------------------------------------

SET client_min_messages TO 'WARNING';
-- create extension
DROP EXTENSION pase;
CREATE EXTENSION pase;
DROP INDEX IF EXISTS v_hnsw_idx_t;
DROP TABLE IF EXISTS vectors_hnsw_test;
DROP INDEX IF EXISTS v_ivfflat_idx;
DROP TABLE IF EXISTS vectors_ivfflat_test;

---------------------------------------------------------------------------
--
-- test new type pase
-- create pase and cal g_pase_distance.
--     vectors_hnsw_test - [3, 1, 1]
--     extra   - 82
--     ds      - 1/0
-- 
---------------------------------------------------------------------------

-- with constructor
SELECT  ARRAY[2, 1, 1]::float4[]     <?>    pase(ARRAY[3, 1, 1]::float4[])          AS distance;
SELECT  ARRAY[2, 1, 1]::float4[]     <?>    pase(ARRAY[3, 1, 1]::float4[], 82)      AS distance;
SELECT  ARRAY[2, 1, 1]::float4[]     <?>    pase(ARRAY[3, 1, 1]::float4[], 82, 1)   AS distance;
SELECT  ARRAY[2, 1, 1]::float4[]     <?>    pase(ARRAY[3, 1, 1]::float4[], 82, 0)   AS distance;

-- with io function
SELECT  ARRAY[2, 1, 1]::float4[]    <?>    '3,1,1'::pase       AS distance;
SELECT  ARRAY[2, 1, 1]::float4[]    <?>    '3,1,1:82'::pase    AS distance;
SELECT  ARRAY[2, 1, 1]::float4[]    <?>    '3,1,1:82:1'::pase  AS distance;
SELECT  ARRAY[2, 1, 1]::float4[]    <?>    '3,1,1:82:0'::pase  AS distance;

-- create a table and insert test data.
CREATE TABLE vectors_hnsw_test (
      id serial,
        vector float4[]
    );


INSERT INTO vectors_hnsw_test SELECT id, ARRAY[id
,1,1,1,1,1,1,1,1,1,1
,1,1,1,1,1,1,1,1,1,1
,1,1,1,1,1,1,1,1,1,1
,1,1,1,1,1,1,1,1,1,1
,1,1,1,1,1,1,1,1,1,1
,1,1,1,1,1,1,1,1,1,1
,1,1,1,1,1,1,1,1,1,1
,1,1,1,1,1,1,1,1,1,1
,1,1,1,1,1,1,1,1,1,1
,1,1,1,1,1,1,1,1,1,1
,1,1,1,1,1,1,1,1,1,1
,1,1,1,1,1,1,1,1,1,1
,1,1,1,1,1,1,1,1,1,1
,1,1,1,1,1,1,1,1,1,1
,1,1,1,1,1,1,1,1,1,1
,1,1,1,1,1,1,1,1,1,1
,1,1,1,1,1,1,1,1,1,1
,1,1,1,1,1,1,1,1,1,1
,1,1,1,1,1,1,1,1,1,1
,1,1,1,1,1,1,1,1,1,1
,1,1,1,1,1,1,1,1,1,1
,1,1,1,1,1,1,1,1,1,1
,1,1,1,1,1,1,1,1,1,1
,1,1,1,1,1,1,1,1,1,1
,1,1,1,1,1,1,1,1,1,1
,1,1,1,1,1
]::float4[] FROM generate_series(1, 50000) id;


---------------------------------------------------------------------------
--
-- test pase hnsw index
-- TODO(lyee.lit): hnsw index build is not implement
                   -- 
                   ---------------------------------------------------------------------------
                   -- create index
                   CREATE INDEX v_hnsw_idx_t ON vectors_hnsw_test
                   USING
                     pase_hnsw(vector)
                   WITH
                     (dim = 256, base_nb_num = 16, ef_build = 40, ef_search = 200, base64_encoded = 0);

                     -- test index scan in order by sql
                     SET enable_seqscan=off;
                     SET enable_indexscan=on;
                     SELECT vector <?> '31111,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1'::pase as distance
                     FROM vectors_hnsw_test
                     ORDER BY
                     vector <?> '31111,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1'::pase
                      ASC LIMIT 10;

                      -- bug fix
                      CREATE TABLE vectors_hnsw_test1 (
                            id serial,
                              vector float4[]
                          );

                      CREATE INDEX v_hnsw_idx_t1 ON vectors_hnsw_test1
                      USING
                        pase_hnsw(vector)
  WITH
    (dim = 256, base_nb_num = 16, ef_build = 40, ef_search = 200, base64_encoded = 0);

    SET enable_seqscan=off;
    SET enable_indexscan=on;
    SELECT vector <?> '31111,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1'::pase as distance
    FROM vectors_hnsw_test
    ORDER BY
    vector <?> '31111,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1'::pase
     ASC LIMIT 10;
    SELECT vector <?> pase((select vector from vectors_hnsw_test where id=111111111), 10, 1) as distance
    FROM vectors_hnsw_test
    ORDER BY
    vector <?> pase((select vector from vectors_hnsw_test where id=111111111), 10, 1)
     ASC LIMIT 10;

     INSERT INTO vectors_hnsw_test1 SELECT id, ARRAY[id
     ,1,1,1,1,1,1,1,1,1,1
     ,1,1,1,1,1,1,1,1,1,1
     ,1,1,1,1,1,1,1,1,1,1
     ,1,1,1,1,1,1,1,1,1,1
     ,1,1,1,1,1,1,1,1,1,1
     ,1,1,1,1,1,1,1,1,1,1
     ,1,1,1,1,1,1,1,1,1,1
     ,1,1,1,1,1,1,1,1,1,1
     ,1,1,1,1,1,1,1,1,1,1
     ,1,1,1,1,1,1,1,1,1,1
     ,1,1,1,1,1,1,1,1,1,1
     ,1,1,1,1,1,1,1,1,1,1
     ,1,1,1,1,1,1,1,1,1,1
     ,1,1,1,1,1,1,1,1,1,1
     ,1,1,1,1,1,1,1,1,1,1
     ,1,1,1,1,1,1,1,1,1,1
     ,1,1,1,1,1,1,1,1,1,1
     ,1,1,1,1,1,1,1,1,1,1
     ,1,1,1,1,1,1,1,1,1,1
     ,1,1,1,1,1,1,1,1,1,1
     ,1,1,1,1,1,1,1,1,1,1
     ,1,1,1,1,1,1,1,1,1,1
     ,1,1,1,1,1,1,1,1,1,1
     ,1,1,1,1,1,1,1,1,1,1
     ,1,1,1,1,1,1,1,1,1,1
     ,1,1,1,1,1
     ]::float4[] FROM generate_series(1, 1) id;

     SELECT vector <?> '31111,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1'::pase as distance
     FROM vectors_hnsw_test
     ORDER BY
     vector <?> '31111,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1'::pase
      ASC LIMIT 10;

      -- test index scan in order by sql

      INSERT INTO vectors_hnsw_test1 SELECT id, ARRAY[id
      ,1,1,1,1,1,1,1,1,1,1
      ,1,1,1,1,1,1,1,1,1,1
      ,1,1,1,1,1,1,1,1,1,1
      ,1,1,1,1,1,1,1,1,1,1
      ,1,1,1,1,1,1,1,1,1,1
      ,1,1,1,1,1,1,1,1,1,1
      ,1,1,1,1,1,1,1,1,1,1
      ,1,1,1,1,1,1,1,1,1,1
      ,1,1,1,1,1,1,1,1,1,1
      ,1,1,1,1,1,1,1,1,1,1
      ,1,1,1,1,1,1,1,1,1,1
      ,1,1,1,1,1,1,1,1,1,1
      ,1,1,1,1,1,1,1,1,1,1
      ,1,1,1,1,1,1,1,1,1,1
      ,1,1,1,1,1,1,1,1,1,1
      ,1,1,1,1,1,1,1,1,1,1
      ,1,1,1,1,1,1,1,1,1,1
      ,1,1,1,1,1,1,1,1,1,1
      ,1,1,1,1,1,1,1,1,1,1
      ,1,1,1,1,1,1,1,1,1,1
      ,1,1,1,1,1,1,1,1,1,1
      ,1,1,1,1,1,1,1,1,1,1
      ,1,1,1,1,1,1,1,1,1,1
      ,1,1,1,1,1,1,1,1,1,1
      ,1,1,1,1,1,1,1,1,1,1
      ,1,1,1,1,1
      ]::float4[] FROM generate_series(1, 20) id;

      SELECT vector <?> '15,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1'::pase as distance
      FROM vectors_hnsw_test
      ORDER BY
      vector <?> '15,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1'::pase
       ASC LIMIT 10;

       -- create a table and insert test data.
       CREATE TABLE vectors_ivfflat_test (
             id serial,
               vector float4[]
           );

       INSERT INTO vectors_ivfflat_test SELECT id, ARRAY[id
       ,1,1,1,1,1,1,1,1,1,1
       ,1,1,1,1,1,1,1,1,1,1
       ,1,1,1,1,1,1,1,1,1,1
       ,1,1,1,1,1,1,1,1,1,1
       ,1,1,1,1,1,1,1,1,1,1
       ,1,1,1,1,1,1,1,1,1,1
       ,1,1,1,1,1,1,1,1,1,1
       ,1,1,1,1,1,1,1,1,1,1
       ,1,1,1,1,1,1,1,1,1,1
       ,1,1,1,1,1,1,1,1,1,1
       ,1,1,1,1,1,1,1,1,1,1
       ,1,1,1,1,1,1,1,1,1,1
       ,1,1,1,1,1,1,1,1,1,1
       ,1,1,1,1,1,1,1,1,1,1
       ,1,1,1,1,1,1,1,1,1,1
       ,1,1,1,1,1,1,1,1,1,1
       ,1,1,1,1,1,1,1,1,1,1
       ,1,1,1,1,1,1,1,1,1,1
       ,1,1,1,1,1,1,1,1,1,1
       ,1,1,1,1,1,1,1,1,1,1
       ,1,1,1,1,1,1,1,1,1,1
       ,1,1,1,1,1,1,1,1,1,1
       ,1,1,1,1,1,1,1,1,1,1
       ,1,1,1,1,1,1,1,1,1,1
       ,1,1,1,1,1,1,1,1,1,1
       ,1,1,1,1,1
       ]::float4[] FROM generate_series(1, 50000) id;

       CREATE INDEX v_ivfflat_idx ON vectors_ivfflat_test
       USING
         pase_ivfflat(vector)
  WITH
    (clustering_type = 1, distance_type = 0, dimension = 256, clustering_params = "10,100");

    INSERT INTO vectors_ivfflat_test VALUES(50001, '{}');

    SELECT vector <#> '31111,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1'::pase as distance
    FROM vectors_ivfflat_test
    ORDER BY
    vector <#> '31111,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1'::pase
     ASC LIMIT 10;
    SELECT vector <#> pase((select vector from vectors_hnsw_test where id=111111111), 10, 1) as distance
    FROM vectors_ivfflat_test
    ORDER BY
    vector <#> pase((select vector from vectors_hnsw_test where id=111111111), 10, 1)
     ASC LIMIT 10;

     ---- clean up
     DROP INDEX v_hnsw_idx_t;
     DROP TABLE vectors_hnsw_test;
     DROP INDEX v_hnsw_idx_t1;
     DROP TABLE vectors_hnsw_test1;
     DROP INDEX v_ivfflat_idx;
     DROP TABLE vectors_ivfflat_test;
     RESET client_min_messages;
