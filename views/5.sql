select learner_id, delta,
CASE
 WHEN ((correct_actions + incorrect_actions) > 0 AND delta > 0) THEN
   (cast(correct_actions AS double precision) / (correct_actions + incorrect_actions) * 100.0)
 ELSE 0.0
END AS accuracy,
MAX(block_number) as block_number
from learner_toolkit_stats_totals
group by learner_id, delta, correct_actions, incorrect_actions
