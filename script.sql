IF EXISTS(SELECT * FROM sys.databases WHERE name='MuseumDatabase')
	DROP DATABASE MuseumDatabase

CREATE DATABASE MuseumDatabase

USE MuseumDatabase


CREATE TABLE Artist (
    ArtistID INT IDENTITY(1, 1) PRIMARY KEY,
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    Nationality NVARCHAR(100) NOT NULL
);

CREATE TABLE Epoch (
    EpochID INT IDENTITY(1, 1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL
	CONSTRAINT CHK_Epoch_StartBeforeEnd CHECK (StartDate < EndDate)
);

CREATE TABLE Exhibition (
    ExhibitionID INT IDENTITY(1, 1) PRIMARY KEY,
    Title NVARCHAR(255) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    Curator NVARCHAR(255) NOT NULL
);

CREATE TABLE Artwork (
    ArtworkID INT PRIMARY KEY,
    Title NVARCHAR(255) NOT NULL,
    ArtistID INT NOT NULL,
    EpochID INT NOT NULL,
    PriceEstimate DECIMAL(10, 2) NOT NULL,
    ExhibitionID INT NOT NULL,
    AcquisitionDate DATE NOT NULL,
    RemovalDate DATE NOT NULL,
    FOREIGN KEY (ArtistID) REFERENCES Artist(ArtistID),
    FOREIGN KEY (EpochID) REFERENCES Epoch(EpochID),
    FOREIGN KEY (ExhibitionID) REFERENCES Exhibition(ExhibitionID)
	CONSTRAINT CHK_Artwork_StartBeforeEnd CHECK (AcquisitionDate < RemovalDate)
);

CREATE TABLE Painting (
    ArtworkID INT PRIMARY KEY,
    Medium NVARCHAR(100) NOT NULL,
    FOREIGN KEY (ArtworkID) REFERENCES Artwork(ArtworkID)
);

CREATE TABLE Sculpture (
    ArtworkID INT PRIMARY KEY,
    Material NVARCHAR(100) NOT NULL,
    Height DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (ArtworkID) REFERENCES Artwork(ArtworkID)
);

CREATE TABLE Photograph(
    ArtworkID INT PRIMARY KEY NOT NULL,
    Size DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (ArtworkID) REFERENCES Artwork(ArtworkID)
);

CREATE TABLE Visitor (
    VisitorID INT IDENTITY(1, 1) PRIMARY KEY,
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(255) NOT NULL,
    Language NVARCHAR(50) NOT NULL
);

CREATE TABLE Ticket (
    TicketID INT IDENTITY(1, 1) PRIMARY KEY,
    Price DECIMAL(10, 2) NOT NULL,
    VisitDate DATE NOT NULL,
    PurchaseDate DATE NOT NULL,
    VisitorID INT NOT NULL,
    FOREIGN KEY (VisitorID) REFERENCES Visitor(VisitorID)
);

CREATE TABLE Guide (
    GuideID INT IDENTITY(1, 1) PRIMARY KEY,
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    Language NVARCHAR(50) NOT NULL
);

CREATE TABLE Tour (
    TourID INT IDENTITY(1, 1) PRIMARY KEY,
    GuideID INT NOT NULL,
    Date DATE NOT NULL,
    MaxParticipants INT NOT NULL,
    FOREIGN KEY (GuideID) REFERENCES Guide(GuideID)
);

CREATE TABLE ArtworkStatistics (
    StatisticID INT PRIMARY KEY,
    StatisticName NVARCHAR(100) NOT NULL,
    StatisticValue INT NOT NULL
);

INSERT INTO ArtworkStatistics (StatisticID, StatisticName, StatisticValue)
VALUES (1, 'PaintingsCount', 0), 
       (2, 'SculpturesCount', 0), 
       (3, 'PhotographCount', 0),
       (4, 'ActiveVisitors', 0),
       (5, 'CurrentExhibitions', 0);

GO

CREATE VIEW ArtworksByEstimatedPrice AS
SELECT a.ArtworkID, a.Title, a.PriceEstimate, 
	RANK() OVER (ORDER BY a.PriceEstimate DESC) AS PriceRank
FROM Artwork a;

GO

CREATE VIEW ArtworksByEpoch AS
SELECT a.ArtworkID, a.Title, e.Name AS EpochName, e.StartDate,
    DENSE_RANK() OVER (ORDER BY e.Name) AS EpochOrder
FROM Artwork a
JOIN Epoch e ON e.EpochID = a.EpochID;

GO

CREATE VIEW ToursByLanguage AS
SELECT t.TourID, t.Date, g.Language, g.GuideID, g.LastName AS "Guide LastName",
    DENSE_RANK() OVER (ORDER BY g.Language) LanguageRank
FROM Tour t
JOIN Guide g ON t.GuideID = g.GuideID;

GO

CREATE VIEW UpcomingExhibitions AS
SELECT ExhibitionID, Title, StartDate, EndDate,
       DATEDIFF(day, StartDate, EndDate) AS DurationDays
FROM Exhibition
WHERE EndDate > GETDATE();

GO

CREATE VIEW ArtworkDetails AS
SELECT a.ArtworkID, a.Title, ar.FirstName, ar.LastName, e.Name "Epoch name"
FROM Artwork a
JOIN Artist ar ON a.ArtistID = ar.ArtistID
JOIN Epoch e ON a.EpochID = e.EpochID;

GO

CREATE VIEW PastTours AS
SELECT TourID, GuideID, Date, MaxParticipants 
FROM Tour
WHERE Date < GETDATE();

GO

CREATE FUNCTION offer_tour (@VisitorID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT t.TourID, t.Date, g.Language
    FROM Ticket tk
    JOIN Visitor v ON tk.VisitorID = v.VisitorID
    JOIN Guide g ON v.Language = g.Language
    JOIN Tour t ON t.GuideID = g.GuideID AND tk.VisitDate = t.Date
    WHERE tk.VisitorID = @VisitorID AND t.Date > GETDATE()
);

GO

CREATE FUNCTION check_artwork_availability(@ArtworkID INT, @RequiredDate DATE)
RETURNS BIT
AS
BEGIN
    DECLARE @IsAvailable BIT;
    SELECT @IsAvailable = CASE 
        WHEN RemovalDate IS NULL OR RemovalDate > @RequiredDate THEN 1
        ELSE 0
    END
    FROM Artwork
    WHERE ArtworkID = @ArtworkID;
    RETURN @IsAvailable;
END;

GO

CREATE FUNCTION count_artworks_in_epoch(@EpochID INT)
RETURNS INT
AS
BEGIN
    DECLARE @ArtworkCount INT;
    SELECT @ArtworkCount = COUNT(*)
    FROM Artwork
    WHERE EpochID = @EpochID;
    RETURN @ArtworkCount;
END;

GO

CREATE FUNCTION estimate_exhibition_value(@ExhibitionID INT)
RETURNS DECIMAL(38, 2)
AS
BEGIN
    DECLARE @TotalValue DECIMAL(38, 2);
    SELECT @TotalValue = SUM(PriceEstimate)
    FROM Artwork
    WHERE EpochID = (SELECT EpochID FROM Exhibition WHERE ExhibitionID = @ExhibitionID);
    RETURN @TotalValue;
END;

GO

CREATE PROC add_new_artwork 
@Title NVARCHAR(255), 
@ArtistID INT,
@EpochID INT,
@PriceEstimate DECIMAL(10, 2),
@ExhibitionID INT,
@RemovalDate DATE
AS
BEGIN
    INSERT INTO Artwork (Title, ArtistID, EpochID, PriceEstimate, ExhibitionID, AcquisitionDate, RemovalDate)
    VALUES (@Title, @ArtistID, @EpochID, @PriceEstimate, @ExhibitionID, GETDATE(), @RemovalDate);
END;

GO

CREATE PROC purchase_ticket 
@Price DECIMAL(10, 2), 
@VisitDate DATE,
@VisitorID INT
AS
BEGIN
    INSERT INTO Ticket (Price, VisitDate, PurchaseDate, VisitorID)
    VALUES (@Price, @VisitDate, GETDATE(), @VisitorID);
END;

GO

CREATE PROC register_new_visitor 
@FirstName NVARCHAR(100), 
@LastName NVARCHAR(100), 
@Email NVARCHAR(255), 
@Language NVARCHAR(50)
AS
BEGIN
    INSERT INTO Visitor (FirstName, LastName, Email, Language)
    VALUES (@FirstName, @LastName, @Email, @Language);
END;

GO

CREATE PROC schedule_tour 
@GuideID INT, 
@Date DATE, 
@MaxParticipants INT
AS
BEGIN
    INSERT INTO Tour (GuideID, Date, MaxParticipants)
    VALUES (@GuideID, @Date, @MaxParticipants);
END;

GO

CREATE PROC cancel_tour 
@TourID INT
AS
BEGIN
    DELETE FROM Tour
    WHERE TourID = @TourID;
END;

GO

CREATE TRIGGER update_paintings_count
ON Painting
AFTER INSERT, DELETE
AS
BEGIN
    DECLARE @CurrentCount INT;
    SELECT @CurrentCount = COUNT(*) FROM Painting;

    UPDATE ArtworkStatistics
    SET StatisticValue = @CurrentCount
    WHERE StatisticName = 'PaintingsCount';
END;

GO

CREATE TRIGGER update_sculptures_count
ON Sculpture
AFTER INSERT, DELETE
AS
BEGIN
    DECLARE @CurrentCount INT;
    SELECT @CurrentCount = COUNT(*) FROM Sculpture;

    UPDATE ArtworkStatistics
    SET StatisticValue = @CurrentCount
    WHERE StatisticName = 'SculpturesCount';
END;

GO

CREATE TRIGGER update_photograph_count
ON Photograph
AFTER INSERT, DELETE
AS
BEGIN
    DECLARE @CurrentCount INT;
    SELECT @CurrentCount = COUNT(*) FROM Photograph;

    UPDATE ArtworkStatistics
    SET StatisticValue = @CurrentCount
    WHERE StatisticName = 'PhotographCount';
END;

GO

CREATE TRIGGER update_active_visitors
ON Ticket
AFTER INSERT, DELETE
AS
BEGIN
    DECLARE @ActiveVisitors INT;
    SELECT @ActiveVisitors = COUNT(DISTINCT VisitorID)
    FROM Ticket
    WHERE VisitDate >= GETDATE();

    UPDATE ArtworkStatistics
    SET StatisticValue = @ActiveVisitors
    WHERE StatisticName = 'ActiveVisitors';
END;

GO

CREATE TRIGGER update_exhibition_stats
ON Exhibition
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @CurrentExhibitions INT;
    SELECT @CurrentExhibitions = COUNT(*)
    FROM Exhibition
    WHERE EndDate >= GETDATE();

    UPDATE ArtworkStatistics
    SET StatisticValue = @CurrentExhibitions
    WHERE StatisticName = 'CurrentExhibitions';
END;
