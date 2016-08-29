with enabled_episodes_mini_skills as (
  select ts.story_id, ts.id as episode_id, count(tl) as mini_skills_number
  from toolkit_sessions as ts
  left join toolkit_lessons as tl
    on tl.toolkit_session_id = ts.id AND tl.enable = true
  group by ts.story_id, ts.id
)

select ltp.learner_id, 
       ees.story_id,
       (CASE 
    WHEN (COUNT(DISTINCT ltp.toolkit_lesson_id) = ees.mini_skills_number AND ltp.finished = true) THEN 1
    ELSE 0
  END) as episode_completion
from learner_toolkit_total_progresses as ltp
left join enabled_episodes_mini_skills as ees
  on ees.story_id = ltp.story_id AND ees.episode_id = ltp.toolkit_session_id
group by ltp.learner_id, ees.story_id, ltp.finished, ees.mini_skills_number