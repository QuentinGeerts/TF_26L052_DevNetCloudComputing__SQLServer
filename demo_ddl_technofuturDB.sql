USE DevDotnetCloudDB;

DROP TABLE IF EXISTS Coordinatrice;
DROP TABLE IF EXISTS Formateur;
DROP TABLE IF EXISTS Personne;

CREATE TABLE Formateur (
	Forfait SMALLMONEY NOT NULL,

	PersonneId INT
);

CREATE TABLE Personne (
	Id INT IDENTITY,
	Nom NVARCHAR(50) NOT NULL,
	Prenom NVARCHAR(50) CONSTRAINT DF_Prenom_Anonyme DEFAULT 'Anonyme',

	CONSTRAINT PK_Personne PRIMARY KEY (Id), -- ❤️
);

CREATE TABLE Coordinatrice (
	EmailContact VARCHAR(150) NOT NULL,

	PersonneId INT,

	CONSTRAINT PK_Coordinatrice PRIMARY KEY (PersonneId),
	CONSTRAINT UK_EmailContact UNIQUE (EmailContact),
	CONSTRAINT CK_EmailContact_Format CHECK (EmailContact LIKE '_%@_%._%'),
	CONSTRAINT FK_Coordiatrice_Personne FOREIGN KEY (PersonneId) 
		REFERENCES Personne (Id)
			ON DELETE CASCADE ON UPDATE CASCADE
);


TRUNCATE TABLE Coordinatrice;

ALTER TABLE Personne 
ADD DateNaissance DATE NOT NULL;

ALTER TABLE Personne 
ADD CONSTRAINT CK_DateNaissance_ApresAujourdhui CHECK (YEAR(DateNaissance) <= YEAR(GETDATE()));

ALTER TABLE Formateur
ADD CONSTRAINT FK_Formateur_Personne FOREIGN KEY (PersonneId) REFERENCES Personne (Id) ON DELETE CASCADE ON UPDATE CASCADE;

-- ALTER TABLE Formateur
-- DROP CONSTRAINT FK_Formateur_Personne;



-- INSERT INTO Personne (Nom, Prenom, DateNaissance)
-- VALUES ('Geerts', 'Quentin', '1996-04-03');
   
-- INSERT INTO Coordinatrice
-- VALUES ('quentin.geerts@bstorm.be', 1);
   
-- ALTER TABLE Coordinatrice
-- NOCHECK CONSTRAINT CK_EmailContact_Format;
   
-- UPDATE Coordinatrice
-- SET EmailContact = 'admin'
-- WHERE PersonneId = 1;

ALTER TABLE Coordinatrice
CHECK CONSTRAINT CK_EmailContact_Format;

UPDATE Coordinatrice
SET EmailContact = 'admin'
WHERE PersonneId = 1;