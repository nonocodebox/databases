--Find names of all chefs who cooked all of the recipes chef Shani cooked
SELECT DISTINCT chef_resp.cname
FROM (Chef NATURAL JOIN Cooked) chef_resp
WHERE NOT EXISTS
	(	SELECT Shani.rid 
		FROM (Chef NATURAL JOIN Cooked) Shani
		WHERE  Shani.cname = 'Shani' AND Shani.rid NOT IN
		(SELECT c.rid 
		 FROM Cooked c
		 WHERE c.cid = chef_resp.cid))
ORDER BY cname;