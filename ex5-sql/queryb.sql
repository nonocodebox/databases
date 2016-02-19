--Print the maximal price of a "Sushi" dish
SELECT MAX(Cooked.price)
FROM Cooked
WHERE Cooked.rid = (SELECT rid
			   FROM Recipe
			   WHERE rname = 'Sushi');
