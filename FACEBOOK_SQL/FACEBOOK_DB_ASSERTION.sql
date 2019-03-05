/* PROFILE owner must be a USER */
CREATE OR REPLACE TRIGGER Profile_Assertion_For_User AFTER INSERT OR UPDATE ON USER_PROFILE 
FOR EACH ROW
DECLARE user_count INTEGER := 0; 
BEGIN
SELECT count (*) INTO user_count
FROM   FACEBOOK_USER
WHERE  :new.CreatorId = CreatorId;
IF user_count = 0 THEN 
   raise_application_error (-20001, 'Profile owner must be a user');
END IF; 
END;
/
/* USER settings owner must be a USER */
CREATE OR REPLACE TRIGGER User_Settings_Assertion_For_User AFTER INSERT OR UPDATE ON USER_SETTINGS 
FOR EACH ROW
DECLARE user_count INTEGER := 0; 
BEGIN
SELECT count (*) INTO user_count
FROM   FACEBOOK_USER
WHERE  :new.CreatorId = CreatorId;
IF user_count <> 0 THEN 
   raise_application_error (-20002, 'User settings owner must be a user');
END IF; 
END;
/
/* PAGE settings owner must be a PAGE */
CREATE OR REPLACE TRIGGER Page_Settings_Assertion_For_Page AFTER INSERT OR UPDATE ON PAGE_SETTINGS 
FOR EACH ROW
DECLARE page_count INTEGER := 0; 
BEGIN
SELECT count (*) INTO page_count
FROM  PAGE,COMMUNITY
WHERE PAGE.CommunityId = COMMUNITY.CommunityId AND COMMUNITY.CreatorId = :new.CreatorId;
IF page_count = 0 THEN 
   raise_application_error (-20003, 'PAGE settings owner must be a PAGE');
END IF; 
END;
/
/* GROUP settings owner must be a GROUP */
CREATE OR REPLACE TRIGGER Group_Settings_Assertion_For_Group AFTER INSERT OR UPDATE ON GROUP_SETTINGS 
FOR EACH ROW
DECLARE group_count INTEGER := 0; 
BEGIN
SELECT count (*) INTO group_count
FROM  GROUP_FACEBOOK,COMMUNITY
WHERE GROUP_FACEBOOK.CommunityId = COMMUNITY.CommunityId AND COMMUNITY.CreatorId = :new.CreatorId;
IF group_count = 0 THEN 
   raise_application_error (-20004, 'GROUP settings owner must be a GROUP');
END IF; 
END;
/
/* ACTION owner can not be a GROUP */
CREATE OR REPLACE TRIGGER Action_Assertion_For_Group AFTER INSERT OR UPDATE ON ACTION 
FOR EACH ROW
DECLARE group_count INTEGER := 0; 
BEGIN
SELECT count (*) INTO group_count
FROM  GROUP_FACEBOOK,COMMUNITY
WHERE GROUP_FACEBOOK.CommunityId = COMMUNITY.CommunityId AND COMMUNITY.CreatorId = :new.CreatorId;
IF group_count <> 0 THEN 
   raise_application_error (-20005, 'ACTION owner can not be a GROUP');
END IF; 
END;
/
/* REVIEW owner can not be a PAGE */
CREATE OR REPLACE TRIGGER Action_Review_For_Page AFTER INSERT OR UPDATE ON ACTION 
FOR EACH ROW
DECLARE page_count INTEGER := 0; 
BEGIN
SELECT count (*) INTO page_count
FROM  PAGE,COMMUNITY
WHERE PAGE.CommunityId = COMMUNITY.CommunityId AND :new.CreatorId = COMMUNITY.CreatorId AND :new.ActionType = 'REVIEW';
IF page_count <> 0 THEN 
   raise_application_error (-20006, 'REVIEW owner can not be a PAGE');
END IF; 
END;
/
/* FOLLOW owner can not be a PAGE */
CREATE OR REPLACE TRIGGER Action_Follow_For_Page AFTER INSERT OR UPDATE ON ACTION 
FOR EACH ROW
DECLARE page_count INTEGER := 0; 
BEGIN
SELECT count (*) INTO page_count
FROM  PAGE,COMMUNITY
WHERE PAGE.CommunityId = COMMUNITY.CommunityId AND :new.CreatorId = COMMUNITY.CreatorId AND :new.ActionType = 'FOLLOW';
IF page_count <> 0 THEN 
   raise_application_error (-20007, 'FOLLOW owner can not be a PAGE');
END IF; 
END;
/
/* JOIN owner can not be a PAGE */
CREATE OR REPLACE TRIGGER Action_Join_Assertion_For_Page AFTER INSERT OR UPDATE ON ACTION 
FOR EACH ROW
DECLARE page_count INTEGER := 0; 
BEGIN
SELECT count (*) INTO page_count
FROM  PAGE,COMMUNITY
WHERE PAGE.CommunityId = COMMUNITY.CommunityId AND :new.CreatorId = COMMUNITY.CreatorId AND :new.ActionType = 'JOIN';
IF page_count <> 0 THEN 
   raise_application_error (-20008, 'JOIN owner can not be a PAGE');
END IF; 
END;
/
/* FRIENDSHIP owner can not be a PAGE */
CREATE OR REPLACE TRIGGER Action_Friendship_Assertion_For_Page AFTER INSERT OR UPDATE ON ACTION 
FOR EACH ROW
DECLARE page_count INTEGER := 0; 
BEGIN
SELECT count (*) INTO page_count
FROM  PAGE,COMMUNITY
WHERE PAGE.CommunityId = COMMUNITY.CommunityId AND :new.CreatorId = COMMUNITY.CreatorId AND :new.ActionType = 'FRIENDSHIP';
IF page_count <> 0 THEN 
   raise_application_error (-20009, 'FRIENDSHIP owner can not be a PAGE');
END IF; 
END;
/
/* USER can not be affected with JOIN action*/
CREATE OR REPLACE TRIGGER Effected_Action_Join_Assertion_For_User AFTER INSERT OR UPDATE ON ACTION 
FOR EACH ROW
DECLARE user_count INTEGER := 0; 
BEGIN
SELECT count (*) INTO user_count
FROM  FACEBOOK_USER
WHERE :new.ActionType = 'JOIN' AND FACEBOOK_USER.CreatorId = :new.CreatorId;
IF user_count <> 0 THEN 
   raise_application_error (-20010, 'USER can not be affected with JOIN action');
END IF; 
END;
/
/* USER can not be affected with REVIEW action*/
CREATE OR REPLACE TRIGGER Effected_Action_Review_Assertion_For_User AFTER INSERT OR UPDATE ON ACTION 
FOR EACH ROW
DECLARE user_count INTEGER := 0; 
BEGIN
SELECT count (*) INTO user_count
FROM  FACEBOOK_USER
WHERE :new.ActionType = 'REVIEW' AND FACEBOOK_USER.CreatorId = :new.CreatorId;
IF user_count <> 0 THEN 
   raise_application_error (-20011, 'USER can not be affected with REVIEW action');
END IF; 
END;
/
/* COMMUNITY can not be affected with FRIENDSHIP action*/
create or replace TRIGGER Effected_Action_Friendship_Assertion_For_Community AFTER INSERT OR UPDATE ON ACTION 
FOR EACH ROW
DECLARE community_count INTEGER := 0; 
BEGIN
SELECT count (*) INTO community_count
FROM  COMMUNITY,CREATOR
WHERE :new.ActionType = 'FRIENDSHIP' AND COMMUNITY.CreatorId = CREATOR.CreatorId 
AND CREATOR.EffectedId = :NEW.DestinationId;
IF community_count <> 0 THEN 
   raise_application_error (-20012, 'COMMUNITY can not be affected with FRIENDSHIP action');
END IF; 
END;

/
/* COMMUNITY can not be affected with COMMENT action*/
CREATE OR REPLACE TRIGGER Effected_Action_Comment_Assertion_For_Community AFTER INSERT OR UPDATE ON ACTION 
FOR EACH ROW
DECLARE community_count INTEGER := 0; 
BEGIN
SELECT count (*) INTO community_count
FROM  FACEBOOK_USER,COMMUNITY
WHERE :new.ActionType = 'COMMENT' AND COMMUNITY.CreatorId = :new.ActionId;
IF community_count <> 0 THEN 
   raise_application_error (-20013, 'COMMUNITY can not be affected with COMMENT action');
END IF; 
END;
/
/* GROUP can not be affected with MESSAGE action*/
CREATE OR REPLACE TRIGGER Effected_Action_Message_Assertion_For_Group AFTER INSERT OR UPDATE ON ACTION 
FOR EACH ROW
DECLARE group_count INTEGER := 0; 
BEGIN
SELECT count (*) INTO group_count
FROM  COMMUNITY,GROUP_FACEBOOK,CREATOR
WHERE :new.ActionType = 'MESSAGE' AND GROUP_FACEBOOK.CommunityId = COMMUNITY.CommunityId 
AND COMMUNITY.CreatorId = CREATOR.CreatorId AND CREATOR.EffectedId = :new.DestinationId;
IF group_count <> 0 THEN 
   raise_application_error (-20014, 'GROUP can not be affected with MESSAGE action');
END IF; 
END;
/
/* GROUP can not be affected with FOLLOW action*/
CREATE OR REPLACE TRIGGER Effected_Action_Follow_Assertion_For_Group AFTER INSERT OR UPDATE ON ACTION 
FOR EACH ROW
DECLARE group_count INTEGER := 0; 
BEGIN
SELECT count (*) INTO group_count
FROM GROUP_FACEBOOK,COMMUNITY
WHERE :new.ActionType = 'FOLLOW' AND GROUP_FACEBOOK.CommunityId = COMMUNITY.CommunityId 
AND COMMUNITY.CommunityId = :new.DestinationId;
IF group_count <> 0 THEN 
   raise_application_error (-20015, 'GROUP can not be affected with FOLLOW action');
END IF; 
END;
/
/* GROUP can not be affected with LIKE action*/
CREATE OR REPLACE TRIGGER Effected_Action_Like_Assertion_For_Group AFTER INSERT OR UPDATE ON ACTION 
FOR EACH ROW
DECLARE group_count INTEGER := 0; 
BEGIN
SELECT count (*) INTO group_count
FROM GROUP_FACEBOOK,COMMUNITY
WHERE :new.ActionType = 'LIKE' AND GROUP_FACEBOOK.CommunityId = COMMUNITY.CommunityId 
AND COMMUNITY.CommunityId = :new.DestinationId;
IF group_count <> 0 THEN 
   raise_application_error (-20016, 'GROUP can not be affected with LIKE action');
END IF; 
END;
/
/* PAGE can not be affected with JOIN action*/
CREATE OR REPLACE TRIGGER Effected_Action_Join_Assertion_For_Page AFTER INSERT OR UPDATE ON ACTION 
FOR EACH ROW
DECLARE page_count INTEGER := 0; 
BEGIN
SELECT count (*) INTO page_count
FROM  PAGE,COMMUNITY,CREATOR
WHERE :new.ActionType = 'JOIN' AND PAGE.CommunityId = COMMUNITY.CommunityId AND COMMUNITY.CommunityId = CREATOR.CreatorId
AND CREATOR.EffectedId = :new.DestinationId;
IF page_count <> 0 THEN 
   raise_application_error (-20017, 'PAGE can not be affected with JOIN action');
END IF; 
END;
/
/* CREATOR can not be affected with COMMENT action */
CREATE OR REPLACE TRIGGER Effected_Action_Comment_Assertion_For_Creator AFTER INSERT OR UPDATE ON ACTION 
FOR EACH ROW
DECLARE creator_count INTEGER := 0; 
BEGIN
SELECT count (*) INTO creator_count
FROM  CREATOR
WHERE :new.ActionType = 'COMMENT' AND CREATOR.EffectedId = :new.DestinationId;
IF creator_count <> 0 THEN 
   raise_application_error (-20018, 'CREATOR can not be affected with COMMENT action');
END IF; 
END;
/
/* SHARE can not be affected with MESSAGE action */
CREATE OR REPLACE TRIGGER Effected_Action_Comment_Assertion_For_Share AFTER INSERT OR UPDATE ON ACTION 
FOR EACH ROW
DECLARE share_count INTEGER := 0; 
BEGIN
SELECT count (*) INTO share_count
FROM  CREATOR_SHARE
WHERE :new.ActionType = 'MESSAGE' AND CREATOR_SHARE.EffectedId = :new.DestinationId;
IF share_count <> 0 THEN 
   raise_application_error (-20019, 'SHARE can not be affected with MESSAGE action');
END IF; 
END;
/
/* SHARE can not be affected with REVIEW action */
CREATE OR REPLACE TRIGGER Effected_Action_Review_Assertion_For_Share AFTER INSERT OR UPDATE ON ACTION 
FOR EACH ROW
DECLARE share_count INTEGER := 0; 
BEGIN
SELECT count (*) INTO share_count
FROM  CREATOR_SHARE
WHERE :new.ActionType = 'REVIEW' AND CREATOR_SHARE.EffectedId = :new.DestinationId;
IF share_count <> 0 THEN 
   raise_application_error (-20020, 'SHARE can not be affected with REVIEW action');
END IF; 
END;
/
/* SHARE can not be affected with FOLLOW action */
CREATE OR REPLACE TRIGGER Effected_Action_Follow_Assertion_For_Share AFTER INSERT OR UPDATE ON ACTION 
FOR EACH ROW
DECLARE share_count INTEGER := 0; 
BEGIN
SELECT count (*) INTO share_count
FROM  CREATOR_SHARE
WHERE :new.ActionType = 'FOLLOW' AND CREATOR_SHARE.EffectedId = :new.DestinationId;
IF share_count <> 0 THEN 
   raise_application_error (-20021, 'SHARE can not be affected with FOLLOW action');
END IF; 
END;
/
/* SHARE can not be affected with JOIN action */
CREATE OR REPLACE TRIGGER Effected_Action_Join_Assertion_For_Share AFTER INSERT OR UPDATE ON ACTION 
FOR EACH ROW
DECLARE share_count INTEGER := 0; 
BEGIN
SELECT count (*) INTO share_count
FROM  CREATOR_SHARE
WHERE :new.ActionType = 'JOIN' AND CREATOR_SHARE.EffectedId = :new.DestinationId;
IF share_count <> 0 THEN 
   raise_application_error (-20022, 'SHARE can not be affected with JOIN action');
END IF; 
END;
/
/* SHARE can not be affected with FRIENDSHIP action */
CREATE OR REPLACE TRIGGER Effected_Action_Friendship_Assertion_For_Share AFTER INSERT OR UPDATE ON ACTION 
FOR EACH ROW
DECLARE share_count INTEGER := 0; 
BEGIN
SELECT count (*) INTO share_count
FROM  CREATOR_SHARE
WHERE :new.ActionType = 'FRIENDSHIP' AND CREATOR_SHARE.EffectedId = :new.DestinationId;
IF share_count <> 0 THEN 
   raise_application_error (-20023, 'SHARE can not be affected with FRIENDSHIP action');
END IF; 
END;
/
/* SHARE can not be affected with SHARE action */
CREATE OR REPLACE TRIGGER Effected_Action_Friendship_Assertion_For_Share AFTER INSERT OR UPDATE ON ACTION 
FOR EACH ROW
DECLARE share_count INTEGER := 0; 
BEGIN
SELECT count (*) INTO share_count
FROM  CREATOR_SHARE
WHERE :new.ActionType = 'SHARE' AND CREATOR_SHARE.EffectedId = :new.DestinationId;
IF share_count <> 0 THEN 
   raise_application_error (-20024, 'SHARE can not be affected with SHARE action');
END IF; 
END;
/
/* COMMENT can not be affected with MESSAGE action */
CREATE OR REPLACE TRIGGER Effected_Action_Message_Assertion_For_Comment AFTER INSERT OR UPDATE ON ACTION 
FOR EACH ROW
DECLARE comment_count INTEGER := 0; 
BEGIN
SELECT count (*) INTO comment_count
FROM  CREATOR_COMMENT
WHERE :new.ActionType = 'MESSAGE' AND CREATOR_COMMENT.EffectedId = :new.DestinationId;
IF comment_count <> 0 THEN 
   raise_application_error (-20025, 'COMMENT can not be affected with MESSAGE action');
END IF; 
END;
/
/* COMMENT can not be affected with REVIEW action */
CREATE OR REPLACE TRIGGER Effected_Action_Review_Assertion_For_Comment AFTER INSERT OR UPDATE ON ACTION 
FOR EACH ROW
DECLARE comment_count INTEGER := 0; 
BEGIN
SELECT count (*) INTO comment_count
FROM  CREATOR_COMMENT
WHERE :new.ActionType = 'REVIEW' AND CREATOR_COMMENT.EffectedId = :new.DestinationId;
IF comment_count <> 0 THEN 
   raise_application_error (-20026, 'COMMENT can not be affected with REVIEW action');
END IF; 
END;
/
/* COMMENT can not be affected with SHARE action */
CREATE OR REPLACE TRIGGER Effected_Action_Share_Assertion_For_Comment AFTER INSERT OR UPDATE ON ACTION 
FOR EACH ROW
DECLARE comment_count INTEGER := 0; 
BEGIN
SELECT count (*) INTO comment_count
FROM  CREATOR_COMMENT
WHERE :new.ActionType = 'SHARE' AND CREATOR_COMMENT.EffectedId = :new.DestinationId;
IF comment_count <> 0 THEN 
   raise_application_error (-20027, 'COMMENT can not be affected with SHARE action');
END IF; 
END;
/
/* COMMENT can not be affected with FOLLOW action */
CREATE OR REPLACE TRIGGER Effected_Action_Follow_Assertion_For_Comment AFTER INSERT OR UPDATE ON ACTION 
FOR EACH ROW
DECLARE comment_count INTEGER := 0; 
BEGIN
SELECT count (*) INTO comment_count
FROM  CREATOR_COMMENT
WHERE :new.ActionType = 'FOLLOW' AND CREATOR_COMMENT.EffectedId = :new.DestinationId;
IF comment_count <> 0 THEN 
   raise_application_error (-20028, 'COMMENT can not be affected with FOLLOW action');
END IF; 
END;
/
/* COMMENT can not be affected with JOIN action */
CREATE OR REPLACE TRIGGER Effected_Action_Join_Assertion_For_Comment AFTER INSERT OR UPDATE ON ACTION 
FOR EACH ROW
DECLARE comment_count INTEGER := 0; 
BEGIN
SELECT count (*) INTO comment_count
FROM  CREATOR_COMMENT
WHERE :new.ActionType = 'JOIN' AND CREATOR_COMMENT.EffectedId = :new.DestinationId;
IF comment_count <> 0 THEN 
   raise_application_error (-20029, 'COMMENT can not be affected with JOIN action');
END IF; 
END;
/
/* COMMENT can not be affected with FRIENDSHIP action */
CREATE OR REPLACE TRIGGER Effected_Action_Friendship_Assertion_For_Comment AFTER INSERT OR UPDATE ON ACTION 
FOR EACH ROW
DECLARE comment_count INTEGER := 0; 
BEGIN
SELECT count (*) INTO comment_count
FROM  CREATOR_COMMENT
WHERE :new.ActionType = 'FRIENDSHIP' AND CREATOR_COMMENT.EffectedId = :new.DestinationId;
IF comment_count <> 0 THEN 
   raise_application_error (-20030, 'COMMENT can not be affected with FRIENDSHIP action');
END IF; 
END;