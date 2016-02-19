--Find all rname of recipes which both chefs Nikib and Goren cooked.
SELECT rname
FROM Chef NATURAL JOIN Recipe NATURAL JOIN Cooked
WHERE cname = 'Nikib'
INTERSECT
SELECT rname
FROM Chef NATURAL JOIN Recipe NATURAL JOIN Cooked
WHERE cname = 'Goren'
ORDER BY rname;
