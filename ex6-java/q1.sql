CREATE OR REPLACE FUNCTION getMonthPassed(trackingid integer)
returns integer as $$

DECLARE
track_res DeviceTracking%ROWTYPE;
owner_res Ownerships%ROWTYPE;
year_diff integer; 
month_diff integer; 


BEGIN
SELECT * into track_res 
FROM DeviceTracking
WHERE tid = trackingid;

IF not found THEN
	RAISE NOTICE 'ERROR: record is not in tracking table.';
 	return -1;
END IF;

SELECT * into owner_res 
FROM Ownerships
WHERE ownerid = track_res.ownerid;
-- Assuming consistency.

-- years' difference in months.
year_diff :=  (track_res.dateyear - owner_res.dateyear -1) * 12;
-- sum the number of months in the end of the year and the number of months in the next year.
month_diff := (12 - owner_res.datemonth) + track_res.datemonth;

return year_diff + month_diff;

END;
$$ LANGUAGE plpgsql;
