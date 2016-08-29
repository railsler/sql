TRUNCATE TABLE learner_toolkit_attempts_progresses;

WITH learner_toolkit_actions_ext AS ( 
  SELECT ta.learner_id,
    date_trunc('day', ta.created_at) AS stats_date,
    ta.story_id,
    ta.toolkit_session_id,
    ta.toolkit_lesson_id,
    ta.skill_type,
    ta.attempt_number,
    fn_mini_skill_progress(ta.lesson_type, ta.step) as progress,
    ta.data
  FROM toolkit_actions AS ta
)
INSERT INTO learner_toolkit_attempts_progresses (learner_id, stats_date, story_id, toolkit_session_id, toolkit_lesson_id, skill_type, attempt, progress, data)
SELECT learner_id,
  stats_date,
  story_id,
  toolkit_session_id,
  toolkit_lesson_id,
  skill_type,
  attempt_number,
  MAX(progress),
  data
FROM learner_toolkit_actions_ext
GROUP BY stats_date, learner_id, story_id, toolkit_session_id, toolkit_lesson_id, skill_type, attempt_number, data
ORDER BY stats_date, learner_id, story_id, toolkit_session_id, toolkit_lesson_id, skill_type, attempt_number, data

