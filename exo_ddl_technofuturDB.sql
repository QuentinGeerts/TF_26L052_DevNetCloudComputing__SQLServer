USE DevDotnetCloudDB;

-- Suppression des tables si elles existent
DROP TABLE IF EXISTS StagiaireFormation;
DROP TABLE IF EXISTS FormateurCours;

DROP TABLE IF EXISTS Cours;
DROP TABLE IF EXISTS Formation;

DROP TABLE IF EXISTS VoitureEntreprise;

DROP TABLE IF EXISTS Formateur;
DROP TABLE IF EXISTS Stagiaire;
DROP TABLE IF EXISTS Coordinatrice;
DROP TABLE IF EXISTS Personne;

-- Création des tables

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

CREATE TABLE Formateur (
	Forfait SMALLMONEY NOT NULL,

	PersonneId INT,

	CONSTRAINT PK_Formateur PRIMARY KEY (PersonneId),
	CONSTRAINT FK_Formateur_Personne FOREIGN KEY (PersonneId) REFERENCES Personne (Id)
		ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT CK_Forfait_Positive CHECK (Forfait >= 0)
);

CREATE TABLE VoitureEntreprise (
	Plaque CHAR(7),
	Marque VARCHAR(50) NOT NULL,
	Modele VARCHAR(50) NOT NULL,
	Couleur VARCHAR(50) NOT NULL,

	ProprietaireId INT,

	CONSTRAINT PK_VoitureEntreprise PRIMARY KEY (Plaque),
	CONSTRAINT FK_VoitureEntreprise_Formateur FOREIGN KEY (ProprietaireId) REFERENCES Formateur (PersonneId)
);

CREATE TABLE Stagiaire (
	Matricule VARCHAR(50) NOT NULL,

	PersonneId INT,

	CONSTRAINT PK_Stagiaire PRIMARY KEY (PersonneId),
	CONSTRAINT FK_Stagiaire_Personne FOREIGN KEY (PersonneId) REFERENCES Personne (Id),
	CONSTRAINT UK_Matricule UNIQUE (Matricule)
);

CREATE TABLE Formation (
	Id INT IDENTITY,
	Intitule VARCHAR(100) NOT NULL,
	DateDebut DATE NOT NULL,
	DateFin DATE NOT NULL,

	ResponsableId INT,

	CONSTRAINT PK_Formation PRIMARY KEY (Id),
	CONSTRAINT FK_Formation_Coordinatrice FOREIGN KEY (ResponsableId) REFERENCES Coordinatrice (PersonneId)
);

CREATE TABLE Cours (
	Id INT IDENTITY,
	Intitule VARCHAR(100) NOT NULL,

	FormationId INT,

	CONSTRAINT PK_Cours PRIMARY KEY (Id),
	CONSTRAINT FK_Cours_Formation FOREIGN KEY (FormationId) REFERENCES Formation (Id)
);

CREATE TABLE StagiaireFormation (
	DateDebut DATE NOT NULL,
	DateFin DATE,

	StagiaireId INT,
	FormationId INT,

	CONSTRAINT FK_StaigaireFormation_Stagiaire FOREIGN KEY (StagiaireId) REFERENCES Stagiaire (PersonneId),
	CONSTRAINT FK_StaigaireFormation_Formation FOREIGN KEY (FormationId) REFERENCES Formation (Id),

	CONSTRAINT CK_DateDebut_DateFin CHECK(DateDebut <= DateFin)
);

CREATE TABLE FormateurCours (
	[Date] Date NOT NULL,

	FormateurId INT,
	CoursId INT,

	CONSTRAINT FK_FormateurCours_Formateur FOREIGN KEY (FormateurId) REFERENCES Formateur (PersonneId),
	CONSTRAINT FK_FormateurCours_Cours FOREIGN KEY (CoursId) REFERENCES Cours (Id),
);


-- TRUNCATE TABLE Coordinatrice;

-- ALTER TABLE Personne 
-- ADD DateNaissance DATE NOT NULL;

-- ALTER TABLE Personne 
-- ADD CONSTRAINT CK_DateNaissance_ApresAujourdhui CHECK (YEAR(DateNaissance) <= YEAR(GETDATE()));

-- ALTER TABLE Formateur
-- ADD CONSTRAINT FK_Formateur_Personne FOREIGN KEY (PersonneId) REFERENCES Personne (Id) ON DELETE CASCADE ON UPDATE CASCADE;

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

-- ALTER TABLE Coordinatrice
-- CHECK CONSTRAINT CK_EmailContact_Format;

-- UPDATE Coordinatrice
-- SET EmailContact = 'admin'
-- WHERE PersonneId = 1;