/* toolkit_stats_steps_number */

CREATE TABLE toolkit_stats_steps_number
(
  lesson_type character varying(50) NOT NULL,
  steps_count integer NOT NULL,
  CONSTRAINT toolkit_stats_steps_number_pkey PRIMARY KEY (lesson_type)
)
WITH (
  OIDS=FALSE
);


INSERT INTO toolkit_stats_steps_number ( lesson_type, steps_count )
VALUES
        ( 'think_aloud', 3),
        ( 'key_word', 3),
        ( 'prediction_connection', 3),
        ( 'look_back_race', 8),
        ( 'digging_deeper', 2),
        ( 'discuss', 1),
        ( 'tricky_word', 2),
        ( 'word_web', 2),
        ( 'word_pair', 4),
        ( 'emotion_journey', 5),
        ( 'key_theme', 3),
        ( 'chain_of_event', 5)
