/* learner_toolkit_attempts_progresses */

CREATE TABLE learner_toolkit_attempts_progresses
(
  id serial NOT NULL,
  learner_id integer NOT NULL,
  stats_date date NOT NULL,
  story_id integer,
  toolkit_session_id integer,
  toolkit_lesson_id integer,
  skill_type integer,
  attempt integer NOT NULL,
  progress double precision,
  data text,
  CONSTRAINT learner_toolkit_attempts_progresses_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
