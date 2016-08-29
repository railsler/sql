/* learner_toolkit_stats_breakdown */

CREATE TABLE learner_toolkit_stats_breakdown
(
  id serial NOT NULL,
  learner_id integer NOT NULL,
  stats_date date NOT NULL,
  story_id integer,
  toolkit_session_id integer,
  toolkit_lesson_id integer,
  skill_type integer,
  step integer NOT NULL,
  need_accuracy integer,
  delta double precision NOT NULL,
  correct_actions integer NOT NULL,
  incorrect_actions integer NOT NULL,
  block_number integer,
  CONSTRAINT learner_toolkit_stats_breakdown_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);

/*CREATE UNIQUE INDEX ux__learner_stats_breakdown__composite
  ON learner_toolkit_stats_breakdown
  USING btree
  (learner_id, stats_date, lesson_plan_id, chapter_id, lesson_id);

CREATE INDEX ix__learner_toolkit_stats_breakdown__learner_and_story
  ON learner_toolkit_stats_breakdown
  USING btree
  (learner_id, story_id);

CREATE INDEX ix__learner_toolkit_stats_breakdown__learner_and_toolkit_session
  ON learner_toolkit_stats_breakdown
  USING btree
  (learner_id, toolkit_session_id);

CREATE INDEX ix__learner_toolkit_stats_breakdown__learner_and_toolkit_lesson
  ON learner_toolkit_stats_breakdown
  USING btree
  (learner_id, toolkit_lesson_id);*/
