with learner_toolkit_actions_ordered as (
	select id, learner_id, row_number() over(partition by learner_id order by id) as seq_num
	from toolkit_actions
)

update toolkit_actions as target
set prev_id = la_prev.id
from learner_toolkit_actions_ordered as la
	inner join learner_toolkit_actions_ordered as la_prev
		on la.learner_id = la_prev.learner_id
		and la.seq_num - 1 = la_prev.seq_num
where target.learner_id = la.learner_id
	and target.id = la.id;

CREATE UNIQUE INDEX ux__learner_toolkit_actions__learner_and_ids
  ON toolkit_actions
  USING btree
  (learner_id, id, prev_id);

CREATE INDEX ix__learner_toolkit_actions__created_at_and_prev_id
  ON toolkit_actions
  USING btree
  (created_at, prev_id);