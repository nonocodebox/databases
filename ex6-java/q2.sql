CREATE OR REPLACE FUNCTION getPopularity(deviceid integer)
returns integer as $$

DECLARE
cnt integer; 

BEGIN
SELECT COUNT(ownerid) into cnt
FROM ( SELECT ownerid
	   FROM Ownerships
	   WHERE did = deviceid AND ownerid NOT IN ( SELECT track.ownerid
								   			 FROM DeviceTracking track)) Q;
return cnt;
END;
$$ LANGUAGE plpgsql;
