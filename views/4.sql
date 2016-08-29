with enabled_mini_skills_in_episodes as (
  select s.id as story_id, ts.id as episode_id, COUNT(tl) as enabled_mini_skills_count
  from stories as s
  inner join toolkit_sessions as ts
    on ts.story_id = s.id
  inner join toolkit_lessons as tl
    on tl.toolkit_session_id = ts.id and tl.enable = true
  group by s.id, ts.id
  order by ts.id
)

select ltp.learner_id, ltp.story_id, ltp.toolkit_session_id, array_agg(DISTINCT(ltp.toolkit_lesson_id)) as completed_mini_skill_ids, count(ltp.toolkit_lesson_id) as completed_mini_skills_number
from learner_toolkit_total_progresses as ltp
where ltp.finished = true
group by ltp.learner_id, ltp.story_id, ltp.toolkit_session_id
