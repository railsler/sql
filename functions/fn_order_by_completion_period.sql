/* DROP FUNCTION fn_order_by_completion_period(integer, integer, character varying(50)); */
/* fn_order_by_completion_period */

DROP FUNCTION fn_order_by_completion_period(integer, integer, character varying(50));
CREATE OR REPLACE FUNCTION fn_order_by_completion_period (
  user_id integer,
  container_id integer,
  container_column character varying(50)
)
RETURNS TABLE (started_at timestamp, finished_at timestamp, seq_num integer) AS $$
BEGIN
  RETURN QUERY EXECUTE format('SELECT started_at, finished_at,
           ROW_NUMBER() OVER(PARTITION BY %I ORDER BY id)::integer AS seq_num
            FROM learner_completed_plans
            WHERE learner_id = $1
                  AND %I = $2', container_column, container_column)
  USING user_id, container_id;
END;
$$
LANGUAGE plpgsql IMMUTABLE;
