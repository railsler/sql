select ltp.learner_id, tl.toolkit_session_id,
       tl.id,
       COALESCE((case 
      when (ltp.finished = true) then 'completed'
      when (ltp.finished = false and ltp.progress > 0) then 'in progress'
      else 'grey'
    end), 'grey') AS is_mg_passed
from toolkit_lessons as tl
inner join learner_toolkit_total_progresses as ltp
  on ltp.toolkit_lesson_id = tl.id
where tl.enable = true
group by ltp.learner_id, tl.toolkit_session_id,tl.id, ltp.finished, ltp.progress
order by ltp.learner_id, tl.id