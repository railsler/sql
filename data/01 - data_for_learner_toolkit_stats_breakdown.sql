TRUNCATE TABLE learner_toolkit_stats_breakdown;

WITH learner_toolkit_actions_ext AS (
  SELECT ta.learner_id,
    date_trunc('day', ta.created_at) AS stats_date,
    ta.story_id,
    ta.toolkit_session_id,
    ta.toolkit_lesson_id,
    ta.skill_type,
    (CASE WHEN (ta.step IS NULL) THEN 1 ELSE ta.step END) as step,
    (CASE WHEN (ta.answer_type = 1) THEN 1 ELSE 0 END) AS need_accuracy,
    fn_toolkit_actions_distance(ta.created_at, ta_prev.created_at) AS delta,
    (CASE WHEN (ta.action = 2 OR ta.action = 1) THEN 1 ELSE 0 END) AS is_correct,
    (CASE WHEN (ta.action = 0) THEN 1 ELSE 0 END) AS is_not_correct,
    ta.prev_id,
    (fn_find_block_number(ta.learner_id, ta.story_id, ta.created_at, 'story_id') + 1) as block_number
  FROM toolkit_actions AS ta
    LEFT JOIN toolkit_actions AS ta_prev
      ON ta.prev_id = ta_prev.id
)

INSERT INTO learner_toolkit_stats_breakdown (learner_id, stats_date, story_id, toolkit_session_id, toolkit_lesson_id, skill_type, step, need_accuracy, delta, correct_actions, incorrect_actions, block_number)
  SELECT learner_id,
    stats_date,
    story_id,
    toolkit_session_id,
    toolkit_lesson_id,
    skill_type,
    step,
    need_accuracy,
    SUM(delta) AS delta,
    SUM(is_correct) AS correct_actions,
    SUM(is_not_correct) AS incorrect_actions,
    block_number
  FROM learner_toolkit_actions_ext
  GROUP BY stats_date, learner_id, story_id, toolkit_session_id, toolkit_lesson_id, skill_type, step, need_accuracy, block_number
  ORDER BY stats_date, learner_id, story_id, toolkit_session_id, toolkit_lesson_id, skill_type, step, need_accuracy, block_number
