/* learner_toolkit_stats_totals */

CREATE TABLE learner_toolkit_stats_totals
(
  id serial NOT NULL,
  learner_id integer NOT NULL,
  story_id integer NOT NULL,
  delta double precision NOT NULL,
  correct_actions integer NOT NULL,
  incorrect_actions integer NOT NULL,
  block_number integer NOT NULL,
  CONSTRAINT learner_toolkit_stats_totals_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);

CREATE UNIQUE INDEX ux__learner_toolkit_stats_totals__composite
  ON learner_toolkit_stats_totals
  USING btree
  (learner_id, story_id, block_number);
