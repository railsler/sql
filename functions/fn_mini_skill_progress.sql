/* fn_mini_skill_progress */

CREATE OR REPLACE FUNCTION fn_mini_skill_progress (
      lesson_kind character varying(50),
      step integer
)
RETURNS double precision AS $$
DECLARE
  v_steps_count integer;
BEGIN
  SELECT sn.steps_count
  INTO v_steps_count
  FROM toolkit_stats_steps_number as sn
  WHERE sn.lesson_type = lesson_kind;

  IF (step >= v_steps_count OR v_steps_count IS NULL) THEN
    RETURN 100.0;
  ELSE
    RETURN round((step / cast(v_steps_count as double precision))::numeric * 100.0, 2);
  END IF;
END;
$$
LANGUAGE plpgsql IMMUTABLE;
