/* learner_toolkit_stats_totals */

TRUNCATE TABLE learner_toolkit_stats_totals;

INSERT INTO learner_toolkit_stats_totals (learner_id, story_id, delta, correct_actions, incorrect_actions, block_number)
  SELECT learner_id,
    story_id,
    SUM(delta) AS delta,
    SUM(correct_actions) AS correct_actions,
    SUM(incorrect_actions) AS incorrect_actions,
    block_number
  FROM learner_toolkit_stats_breakdown
  GROUP BY learner_id, story_id, block_number
  ORDER BY learner_id, story_id, block_number;
