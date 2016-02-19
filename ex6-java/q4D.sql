-- This view contains (devicetype, did, popularity) where popularity >= 1.
CREATE VIEW DevicePopularity AS 
SELECT dtype, did, getPopularity(did) AS popularity
FROM Devices
WHERE getPopularity(did) >= 1;


CREATE OR REPLACE FUNCTION popularDevTrackFunc() RETURNS trigger AS $$

DECLARE
new_did integer;
last_popularity integer;
new_device Devices%ROWTYPE;
most_track_res MostPopular%ROWTYPE;
already_in_track integer;

BEGIN

-- check if already in track, no reason to change popularity
SELECT COUNT(ownerid) into already_in_track FROM DeviceTracking
WHERE ownerid = NEW.ownerid;

IF already_in_track > 1 THEN
	return null;
END IF;

SELECT did into new_did FROM Ownerships
WHERE ownerid = NEW.ownerid;
-- Has to be found foreign key.

SELECT * into new_device FROM Devices
WHERE did = new_did;
-- Has to be found foreign key.

SELECT * into most_track_res FROM MostPopular
WHERE did = new_did;

IF FOUND THEN
	last_popularity = most_track_res.popularity - 1;

	-- remove all devices with the same rank.
	DELETE FROM MostPopular
	WHERE did = new_did;

	SELECT * into most_track_res FROM MostPopular
	WHERE dtype = new_device.dtype;

	IF NOT FOUND THEN
		-- collect all with same rank after change.
		INSERT INTO MostPopular 
		SELECT * 
		FROM DevicePopularity 
		WHERE popularity = last_popularity AND dtype = new_device.dtype;
	END IF;
END IF;

return null;

END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION popularOwnerFunc() RETURNS trigger AS $$
DECLARE
new_popularity integer;
new_type integer;
most_res MostPopular%ROWTYPE;

BEGIN

SELECT getPopularity(NEW.did) into new_popularity;

SELECT dtype into new_type FROM Devices
WHERE did = NEW.did; 
-- have to be in ownerships-> device foreign key.

SELECT * into most_res FROM MostPopular
WHERE dtype = new_type;

IF NOT FOUND AND new_popularity >=1 THEN
-- new type
	INSERT INTO MostPopular
	VALUES (new_type, NEW.did, new_popularity);

ELSIF NOT FOUND AND new_popularity < 1 THEN
	return null;

ELSIF new_popularity > most_res.popularity THEN 
-- found
-- delete all "not so popular any more".
	DELETE FROM MostPopular
	WHERE dtype = new_type;

	INSERT INTO MostPopular
	VALUES (new_type, NEW.did, new_popularity);

ELSIF new_popularity = most_res.popularity THEN
	-- add wannabes
	INSERT INTO MostPopular
	VALUES (new_type, NEW.did, new_popularity);

END IF;

return null;

END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER popularDeviceTrackTrig
AFTER
INSERT ON DeviceTracking
FOR EACH ROW
EXECUTE PROCEDURE popularDevTrackFunc();

CREATE TRIGGER popularOwnerTrig
AFTER
INSERT ON Ownerships
FOR EACH ROW
EXECUTE PROCEDURE popularOwnerFunc();
