CREATE FUNCTION ownershipsDroppedFunc() RETURNS trigger AS $$
BEGIN

IF NEW.sid = 1 OR NEW.sid = 2 THEN
	UPDATE Ownerships
	SET ownershipDropped = 1
	WHERE ownerid = NEW.ownerid;
END IF;

return null;

END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ownershipsDroppedTrig
AFTER
INSERT ON DeviceTracking
FOR EACH ROW
EXECUTE PROCEDURE ownershipsDroppedFunc();
