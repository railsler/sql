/* learner_toolkit_total_progresses */

CREATE TABLE learner_toolkit_total_progresses (
  id serial NOT NULL,
  learner_id integer,
  story_id integer,
  toolkit_session_id integer,
  toolkit_lesson_id integer,
  skill_type integer,
  progress double precision,
  finished boolean DEFAULT false,
  CONSTRAINT learner_toolkit_total_progresses_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
