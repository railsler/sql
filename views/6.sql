with learner_stats as (
  select lst.learner_id, lst.delta,
  CASE
   WHEN ((lst.correct_actions + lst.incorrect_actions) > 0 AND lst.delta > 0) THEN 
     (cast(lst.correct_actions AS double precision) / (lst.correct_actions + lst.incorrect_actions) * 100.0)
   ELSE 0.0
  END AS accuracy,
  MAX(lst.block_number) as block_number,
  MAX(lsb.last_use) as last_use
  from learner_toolkit_stats_totals as lst
  inner join
    (
    select learner_id, MAX(created_at) as last_use
    from toolkit_actions
    group by learner_id
    ) as lsb on lsb.learner_id = lst.learner_id
  group by lst.learner_id, lst.delta, lst.correct_actions, lst.incorrect_actions, lsb.last_use
)

select avg(delta) as time_on_site,
       avg(accuracy) as accuracy,
       current_timestamp as last_use,
       '' as progress,
       '' as focus
from learner_stats
union all
select delta as time_on_site,
       accuracy,
       last_use,
       '' as progress,
       '' as focus
from learner_stats
