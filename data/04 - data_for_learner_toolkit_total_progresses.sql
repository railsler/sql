/* learner_toolkit_total_progresses */

TRUNCATE TABLE learner_toolkit_total_progresses;

INSERT INTO learner_toolkit_total_progresses (learner_id, story_id, toolkit_session_id, toolkit_lesson_id, skill_type, progress, finished)
  SELECT learner_id,
    story_id,
    toolkit_session_id,
    toolkit_lesson_id,
    skill_type,
    MAX(progress) as max_progress,
    (MAX(progress) = 100) as finished
  FROM learner_toolkit_attempts_progresses
  GROUP BY learner_id, story_id, toolkit_session_id, toolkit_lesson_id, skill_type, data
  ORDER BY learner_id, story_id, toolkit_session_id, toolkit_lesson_id, skill_type, data;
