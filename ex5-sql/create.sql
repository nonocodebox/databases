CREATE TABLE Actor(
	Aid 	INTEGER,
	Name    VARCHAR(20) NOT NULL,
	Salary	INTEGER NOT NULL default(3000),
	PRIMARY KEY(Aid)
);

CREATE TABLE Movie(
	Mid 	INTEGER,
	Title   VARCHAR(20) NOT NULL,
	Length	INTEGER NOT NULL default(60) CHECK(0 < Length and Length <= 200),
	Rating 	INTEGER NOT NULL CHECK(0 < Rating and Rating <= 10),
	PRIMARY KEY(Mid),
	CHECK (Length <= 100 or Rating >= 3)
);

CREATE TABLE Played(
	Aid 	INTEGER,
	Mid 	INTEGER,
	--Means both Aid and Mid are not null.
	PRIMARY KEY(Aid, Mid),
	FOREIGN KEY (Aid) 
			REFERENCES Actor ON DELETE CASCADE,
	FOREIGN KEY (Mid) 
			REFERENCES Movie ON DELETE CASCADE
);
