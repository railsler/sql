/* tr_toolkit_actions_insert */

CREATE TRIGGER tr_toolkit_actions_insert
AFTER INSERT ON toolkit_actions
FOR EACH ROW EXECUTE PROCEDURE sp_update_learner_toolkit_stats();
