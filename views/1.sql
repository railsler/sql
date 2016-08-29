/* vw_learner_toolkit_stats_focus_raw */

CREATE OR REPLACE VIEW vw_learner_toolkit_stats_focus_raw
AS
  SELECT lst.learner_id, tw.week_num,
    (
      trim(to_char(lsb.stats_date, 'Day')) || '=>' ||
      (CASE WHEN (SUM(lsb.delta) < 1200.0 /* 20 minutes */) THEN (SUM(lsb.delta) / 1200.0 * 100.0) ELSE 100.0 END)
    ) AS key_value
  FROM learner_toolkit_stats_totals AS lst
    INNER JOIN vw_learner_stats_two_weeks AS tw
      ON 1 = 1
    INNER JOIN learner_toolkit_stats_breakdown AS lsb
      ON lst.learner_id = lsb.learner_id
      AND lsb.stats_date BETWEEN tw.start_date AND tw.end_date
  GROUP BY lst.learner_id, tw.week_num, lsb.stats_date
  HAVING SUM(lsb.delta) > 0.0;
