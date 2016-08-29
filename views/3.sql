/* vw_learner_toolkit_stats */

CREATE OR REPLACE VIEW vw_learner_toolkit_stats
AS
  SELECT lf.learner_id, lf.time_on_site, lf.accuracy, array_agg(lf.focus) AS focus
  FROM vw_learner_toolkit_stats_focus AS lf
    INNER JOIN learner_profiles AS lp
      ON lf.learner_id = lp.learner_id
  GROUP BY lf.learner_id, lf.time_on_site, lf.accuracy
  ORDER BY lf.learner_id;
