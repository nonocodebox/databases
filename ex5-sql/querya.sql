--Find the names of all chefs who cook "Pizza" for less than 15 (dollars).
SELECT DISTINCT cname
FROM Chef NATURAL JOIN Recipe NATURAL JOIN Cooked
WHERE rname = 'Pizza' AND price < 15
ORDER BY cname;
