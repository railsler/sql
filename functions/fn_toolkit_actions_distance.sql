/* fn_toolkit_actions_distance */

CREATE OR REPLACE FUNCTION fn_toolkit_actions_distance (
  curr_created_at timestamp without time zone,
  prev_created_at timestamp without time zone,
  curr_lesson_type_id integer DEFAULT -1,
  prev_lesson_type_id integer DEFAULT -1
)
RETURNS double precision AS $$
DECLARE
  DATA_THRESHOLD interval = interval '10 minutes';

  delta interval;
BEGIN
  IF (curr_created_at IS NULL OR prev_created_at IS NULL) THEN
    RETURN 0.0;
  END IF;

  delta := curr_created_at - prev_created_at;

  IF (delta < DATA_THRESHOLD) THEN
    RETURN extract(epoch FROM delta);
  ELSE
    RETURN 0.0;
  END IF;
END;
$$
LANGUAGE plpgsql IMMUTABLE;
