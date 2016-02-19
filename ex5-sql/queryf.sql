-- Find the cid of chefs who have earned the most money (the total amount earned by a chef is the
-- sum of all prices for recipes she or he cooked).
SELECT DISTINCT cid
FROM Cooked
GROUP BY cid 
HAVING SUM(price) >= ALL ( SELECT SUM(price)
						   FROM Cooked
					       GROUP BY cid)
ORDER BY cid;