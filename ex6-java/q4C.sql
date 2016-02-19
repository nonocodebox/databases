CREATE FUNCTION dateChkFunc() RETURNS trigger AS $$

DECLARE
owner_res Ownerships%ROWTYPE; --Only one row (key)

BEGIN

SELECT * into owner_res FROM Ownerships
WHERE ownerid = NEW.ownerid;

-- Consistency check.
IF not found THEN
	RAISE NOTICE 'ERROR: ownerid is not in the ownerships table.';
 	return null;
END IF;

IF owner_res.dateyear < NEW.dateyear THEN
	return NEW;
ELSIF owner_res.dateyear = NEW.dateyear AND owner_res.datemonth <= NEW.datemonth THEN
	return NEW;
END IF;

return null;

END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER DateChkTrig
BEFORE
INSERT ON DeviceTracking
FOR EACH ROW
EXECUTE PROCEDURE DateChkFunc();
