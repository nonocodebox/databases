CREATE OR REPLACE FUNCTION getFirmPopularity(firmid integer)
returns integer as $$

DECLARE
cnt integer; 
i record;

BEGIN
cnt = 0;
For i in SELECT * from Devices WHERE fid = firmid ORDER BY did LOOP
	cnt  := getPopularity(i.did) + cnt;
END LOOP;

return cnt;
END;
$$ LANGUAGE plpgsql;