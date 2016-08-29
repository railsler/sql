/* fn_find_max_mini_skill_progress */

CREATE OR REPLACE FUNCTION fn_find_max_mini_skill_progress (
  user_id integer,
  lesson_id integer
)
RETURNS double precision AS $$
DECLARE
  v_max_progress double precision;
BEGIN
  SELECT MAX(progress)
  INTO v_max_progress
  FROM learner_toolkit_attempts_progresses
  WHERE learner_id = user_id AND toolkit_lesson_id = lesson_id
  LIMIT 1;

  RETURN v_max_progress;
END;
$$
LANGUAGE plpgsql IMMUTABLE;
