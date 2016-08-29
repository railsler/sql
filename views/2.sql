/* vw_learner_toolkit_stats_focus */

CREATE OR REPLACE VIEW vw_learner_toolkit_stats_focus
AS
  SELECT lst.learner_id,
    lst.delta AS time_on_site,
    CASE WHEN (lst.correct_actions + lst.incorrect_actions) > 0 THEN (cast(lst.correct_actions AS double precision) / (lst.correct_actions + lst.incorrect_actions) * 100.0) ELSE 0.0 END AS accuracy,
    ht.week_num,
    (ht.hstore_template || COALESCE(string_agg(fr.key_value, ',')::hstore, ht.hstore_template)) AS focus
  FROM learner_toolkit_stats_totals AS lst
    INNER JOIN (
      SELECT 0 AS week_num /* previous week */, 'Monday=>0.0,Tuesday=>0.0,Wednesday=>0.0,Thursday=>0.0,Friday=>0.0,Saturday=>0.0,Sunday=>0.0'::hstore AS hstore_template
      UNION
      SELECT 1 AS week_num /* this week */, 'Monday=>0.0,Tuesday=>0.0,Wednesday=>0.0,Thursday=>0.0,Friday=>0.0,Saturday=>0.0,Sunday=>0.0'::hstore AS hstore_template
    ) AS ht
      ON 1 = 1
    LEFT JOIN vw_learner_stats_focus_raw AS fr
      ON lst.learner_id = fr.learner_id
      AND ht.week_num = fr.week_num
  GROUP BY lst.learner_id, lst.delta, lst.correct_actions, lst.incorrect_actions, ht.week_num, ht.hstore_template
  ORDER BY lst.learner_id, ht.week_num;
