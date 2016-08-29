with 
episodes_positions as (
  select story_id, id as episode_id, enabled_skills, (ROW_NUMBER() OVER ( PARTITION BY story_id ORDER BY id ASC) - 1) AS episode_position
  from toolkit_sessions
  order by story_id, id ASC
),
compr_indexes_map as (
  select ep.story_id, 
         ep.episode_id, 
         ep.episode_position as session_index,
         tl.skill_type, 
         (CASE 
        when (idx(ep.enabled_skills, tl.skill_type) > 0) then (idx(ep.enabled_skills, tl.skill_type) - 1)
        else null
         end) as skill_index,
         tl.id as lesson_id, (ROW_NUMBER() OVER ( PARTITION BY tl.toolkit_session_id, tl.skill_type ORDER BY tl.id ASC ) - 1) AS mini_skill_index
  from episodes_positions as ep
  left join toolkit_lessons as tl
    on tl.toolkit_session_id = ep.episode_id
  group by ep.story_id, ep.episode_id, ep.episode_position, tl.skill_type, tl.id, ep.enabled_skills
  order by ep.story_id, ep.episode_id, tl.skill_type, tl.id ASC
),

current_learners_positions as (
  select lp.learner_id, lp.story_id, cim.episode_id, cim.skill_type, cim.lesson_id
  from learner_profiles as lp
  inner join compr_indexes_map as cim
    on lp.story_id = cim.story_id 
       and lp.session_index = coalesce(cim.session_index, 0)
       and lp.skill_index = coalesce(cim.skill_index, 0)
       and lp.toolkit_index = coalesce(cim.mini_skill_index, 0)
  where lp.deleted_at is null AND toolkit_mode = true
  group by lp.learner_id, lp.story_id, cim.episode_id, cim.skill_type, cim.lesson_id
)
