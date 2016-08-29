/* sp_update_learner_toolkit_stats */

CREATE OR REPLACE FUNCTION sp_update_learner_toolkit_stats()
RETURNS TRIGGER AS $$
DECLARE
  MAX_PROGRESS_PERCENTAGE numeric = 100.0;
  v_stats_date date;
  v_prev_id integer;
  v_prev_created_at timestamp without time zone;
  v_delta_inc double precision;
  v_progress double precision;
  v_correct_actions_inc integer;
  v_incorrect_actions_inc integer;
  v_max_progress double precision;
  v_mini_skill_finished boolean;
  v_block_number integer = 1;
BEGIN
  v_stats_date := date_trunc('day', NEW.created_at);

  SELECT id, created_at
  INTO v_prev_id, v_prev_created_at
  FROM toolkit_actions
  WHERE learner_id = NEW.learner_id
    AND id < NEW.id
  ORDER BY id DESC
  LIMIT 1;

  UPDATE toolkit_actions
  SET prev_id = v_prev_id
  WHERE id = NEW.id;

  v_delta_inc := fn_toolkit_actions_distance(NEW.created_at, v_prev_created_at);

  v_correct_actions_inc := (CASE WHEN (New.action = 2) THEN 1 ELSE 0 END);
  v_incorrect_actions_inc := (CASE WHEN (New.action = 0) THEN 1 ELSE 0 END);
  v_block_number := v_block_number + fn_find_block_number(NEW.learner_id, NEW.story_id, NEW.created_at, 'story_id');

  UPDATE learner_toolkit_stats_breakdown
  SET delta = delta + v_delta_inc,
    correct_actions = correct_actions + v_correct_actions_inc,
    incorrect_actions = incorrect_actions + v_incorrect_actions_inc,
    block_number = v_block_number
  WHERE learner_id = NEW.learner_id
    AND stats_date = v_stats_date
    AND COALESCE(toolkit_lesson_id, -1) = COALESCE(NEW.toolkit_lesson_id, -1)
    AND step = NEW.step
    AND block_number = v_block_number;

  IF NOT FOUND THEN
    INSERT INTO learner_toolkit_stats_breakdown (learner_id, stats_date, story_id, toolkit_session_id, toolkit_lesson_id, skill_type, step, need_accuracy, delta, correct_actions, incorrect_actions, block_number)
    VALUES (NEW.learner_id, v_stats_date, NEW.story_id, NEW.toolkit_session_id, NEW.toolkit_lesson_id, NEW.skill_type, NEW.step, NEW.answer_type, v_delta_inc, v_correct_actions_inc, v_incorrect_actions_inc, v_block_number);
  END IF;

  IF (NEW.action = 1) THEN
    v_progress := fn_mini_skill_progress(NEW.lesson_type, NEW.step);
    UPDATE learner_toolkit_attempts_progresses
    SET learner_id = NEW.learner_id,
      stats_date = v_stats_date,
      story_id = NEW.story_id,
      toolkit_session_id = NEW.toolkit_session_id,
      toolkit_lesson_id = NEW.toolkit_lesson_id,
      skill_type = NEW.skill_type,
      attempt = NEW.attempt_number,
      progress = v_progress,
      data = NEW.data

    WHERE learner_id = NEW.learner_id
      AND COALESCE(toolkit_lesson_id, -1) = COALESCE(NEW.toolkit_lesson_id, -1)
      AND COALESCE(attempt, -1) = NEW.attempt_number;

    IF NOT FOUND THEN
      INSERT INTO learner_toolkit_attempts_progresses (learner_id, stats_date, story_id, toolkit_session_id, toolkit_lesson_id, skill_type, attempt, progress, data)
      VALUES (NEW.learner_id, v_stats_date, NEW.story_id, NEW.toolkit_session_id, NEW.toolkit_lesson_id, NEW.skill_type, NEW.attempt_number, v_progress, NEW.data);
    END IF;
  END IF;

  UPDATE learner_toolkit_stats_totals
  SET delta = delta + v_delta_inc,
    correct_actions = correct_actions + v_correct_actions_inc,
    incorrect_actions = incorrect_actions + v_incorrect_actions_inc
  WHERE learner_id = NEW.learner_id
        AND story_id = NEW.story_id
        AND block_number = v_block_number;

  IF NOT FOUND THEN
    INSERT INTO learner_toolkit_stats_totals (learner_id, story_id, delta, correct_actions, incorrect_actions, block_number)
    VALUES (NEW.learner_id, NEW.story_id, v_delta_inc, v_correct_actions_inc, v_incorrect_actions_inc, v_block_number);
  END IF;

  v_max_progress := fn_find_max_mini_skill_progress(NEW.learner_id, NEW.toolkit_lesson_id);
  v_mini_skill_finished := MAX_PROGRESS_PERCENTAGE = v_max_progress;

  UPDATE learner_toolkit_total_progresses
  SET progress = v_max_progress,
    finished = v_mini_skill_finished
  WHERE learner_id = NEW.learner_id
    AND COALESCE(toolkit_lesson_id, -1) = COALESCE(NEW.toolkit_lesson_id, -1);

  IF NOT FOUND THEN
    INSERT INTO learner_toolkit_total_progresses (learner_id, story_id, toolkit_session_id, toolkit_lesson_id, skill_type, progress, finished)
    VALUES (NEW.learner_id, NEW.story_id, NEW.toolkit_session_id, NEW.toolkit_lesson_id, NEW.skill_type, v_max_progress, v_mini_skill_finished);
  END IF;

  RETURN null;
END;
$$
LANGUAGE plpgsql;
