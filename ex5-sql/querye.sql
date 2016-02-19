--Find names of all chefs that earned at least 100 (dollars) for every
-- recipe they cooked
SELECT DISTINCT cname
FROM Chef C
WHERE NOT EXISTS ( SELECT C1.rid
				  FROM Cooked C1
				  WHERE price < 100 AND C1.cid = C.cid)
AND EXISTS( SELECT C2.rid
			FROM Cooked C2
			WHERE C2.cid = C.cid)
ORDER BY cname;