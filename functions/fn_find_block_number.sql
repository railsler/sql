/* DROP FUNCTION fn_find_block_number(integer, integer, timestamp, character varying(50)); */
/* fn_find_block_number */

DROP FUNCTION fn_find_block_number(integer, integer, timestamp, character varying(50));
CREATE OR REPLACE FUNCTION fn_find_block_number (
  user_id integer,
  container_id integer,
  creation_time timestamp,
  module_obj_type character varying(50)
)
RETURNS integer AS $$
DECLARE
  block_number integer;
BEGIN
  SELECT seq_num
  INTO block_number
  FROM fn_order_by_completion_period(user_id, container_id, module_obj_type)
  WHERE started_at <= creation_time
        AND finished_at >= creation_time
  LIMIT 1;

  IF block_number IS NULL THEN
    RETURN 0;
  ELSE
    RETURN block_number;
  END IF;
END;
$$
LANGUAGE plpgsql IMMUTABLE;
