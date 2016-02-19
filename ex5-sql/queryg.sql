-- Find all rname of recipes which 3 or less chefs cooked.
SELECT rname
FROM Recipe
WHERE rid IN (SELECT  rid
			  FROM Cooked
			  GROUP BY rid 
			  HAVING COUNT(*) <= 3)
UNION 
-- A recipe that is not in Cooked should be included.
SELECT rname
FROM Recipe R
WHERE NOT EXISTS( SELECT C2.rid
			FROM Cooked C2
			WHERE C2.rid = R.rid)
ORDER BY rname;