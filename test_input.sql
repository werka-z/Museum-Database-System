INSERT INTO Artist (FirstName, LastName, Nationality) VALUES
('Vincent', 'Van Gogh', 'Dutch'),
('Leonardo', 'Da Vinci', 'Italian'),
('Pablo', 'Picasso', 'Spanish'),
('Claude', 'Monet', 'French'),
('Gustav', 'Klimt', 'Austrian'),
('Jan', 'Matejko', 'Polish'),
('Rembrandt', 'van Rijn', 'Dutch'),
('Salvador', 'Dali', 'Spanish'),
('Johannes', 'Vermeer', 'Dutch'),
('Frida', 'Kahlo', 'Mexican'),
('Henri', 'Cartier-Bresson', 'French'),
('Lucas', 'Faydherbe', 'Dutch');

INSERT INTO Epoch (Name, StartDate, EndDate) VALUES
('Impressionism', '1860-01-01', '1890-12-31'),
('Renaissance', '1300-01-01', '1600-12-31'),
('Cubism', '1907-01-01', '1917-12-31'),
('Art Nouveau', '1880-01-01', '1910-12-31'),
('Romanticism', '1800-01-01', '1850-12-31'),
('Baroque', '1600-01-01', '1750-12-31'),
('Surrealism', '1924-01-01', '1966-12-31'),
('Dutch Golden Age', '1585-01-01', '1702-12-31'),
('Mexican Muralism', '1920-01-01', '1950-12-31'),
('Modern', '1900-01-01', '2023-12-31');

INSERT INTO Exhibition (Title, StartDate, EndDate, Curator) VALUES
('Impressionist Masters', '2023-06-01', '2023-12-31', 'Alice Dubois'),
('Renaissance Highlights', '2023-07-01', '2024-01-31', 'Marco Rossi'),
('Cubism and Beyond', '2023-09-01', '2023-11-30', 'Pedro Alvarez'),
('Symbolist Imagery', '2023-10-01', '2024-03-31', 'Hans Müller'),
('Romantic Era', '2023-08-01', '2023-10-31', 'Joanna Dubiel');

INSERT INTO Artwork (ArtworkID, Title, ArtistID, EpochID, PriceEstimate, ExhibitionID, AcquisitionDate, RemovalDate) VALUES
(1, 'Starry Night Over the Rhone', 1, 1, 9500000.00, 1, '2023-01-01', '2024-12-31'),
(2, 'Mona Lisa', 2, 2, 67000000.00, 2, '2023-02-01', '2024-12-31'),
(3, 'Guernica', 3, 3, 18000000.00, 3, '2023-03-01', '2024-12-31'),
(4, 'Water Lilies', 4, 1, 43000000.00, 1, '2023-04-01', '2024-12-31'),
(5, 'The Kiss', 5, 4, 7800000.00, 4, '2023-05-01', '2024-12-31'),
(6, 'The Persistence of Memory', 8, 7, 5000000.00, 5, '2023-05-01', '2024-12-31'),
(7, 'The Starry Night', 1, 1, 10000000.00, 1, '2023-06-01', '2024-12-31'),
(8, 'Girl with a Pearl Earring', 9, 8, 30000000.00, 4, '2023-07-01', '2024-12-31'),
(9, 'Hercules', 2, 6, 15000000.00, 2, '2023-08-01', '2024-12-31'),
(10, 'Man Jumping the Puddle', 11, 10, 15000.00, 4, '2023-08-01', '2025-10-04'),
(11, 'Irises', 1, 1, 54000000.00, 1, '2023-01-01', '2024-12-31');

INSERT INTO Painting (ArtworkID, Medium) VALUES
(1, 'Oil on canvas'),
(2, 'Oil on wood'),
(3, 'Oil on canvas'),
(4, 'Oil on canvas'),
(5, 'Oil on canvas'),
(6, 'Oil on canvas'),
(7, 'Oil on canvas'),
(8, 'Oil on canvas');

INSERT INTO Sculpture (ArtworkID, Material, Height) VALUES
(9, 'Marble', 2.44);

INSERT INTO Photograph (ArtworkID, Size) VALUES
(10, 15);

INSERT INTO Guide (FirstName, LastName, Language) VALUES
('Jean', 'Dupont', 'French'),
('Maria', 'Rossi', 'Italian'),
('John', 'Smith', 'English'),
('Anna', 'Kowalska', 'Polish'),
('Juan', 'Garcia', 'Spanish');

INSERT INTO Visitor (FirstName, LastName, Email, Language) VALUES
('Alice', 'Johnson', 'alice.johnson@example.com', 'English'),
('Bob', 'Brown', 'bob.brown@example.com', 'English'),
('Carlos', 'Garcia', 'carlos.garcia@example.com', 'Spanish'),
('Diana', 'Miller', 'diana.miller@example.com', 'English'),
('Elena', 'Petrova', 'elena.petrova@example.com', 'English'),
('Franco', 'Bianchi', 'franco.bianchi@example.com', 'Italian'),
('Greta', 'Schmidt', 'greta.schmidt@example.com', 'German'),
('Hiroshi', 'Takahashi', 'hiroshi.takahashi@example.com', 'English'),
('Igor', 'Novak', 'igor.novak@example.com', 'Polish'),
('Julia', 'Lopez', 'julia.lopez@example.com', 'Spanish'),
('Lena', 'Dubois', 'lena.dubois@example.com', 'French');

INSERT INTO Tour (GuideID, Date, MaxParticipants) VALUES
(3, '2024-07-20', 30),
(1, '2023-10-07', 12),
(4, '2023-12-22', 10),
(1, '2024-06-15', 15),
(2, '2024-07-20', 10),
(5, '2024-08-05', 20),
(4, '2024-09-10', 5),
(3, '2024-10-25', 15);

INSERT INTO Ticket (Price, VisitDate, PurchaseDate, VisitorID) VALUES
(15.00, '2024-01-15', '2023-06-01', 1),
(15.00, '2024-01-16', '2023-06-02', 2),
(20.00, '2024-07-20', '2023-07-01', 3),
(20.00, '2024-07-20', '2023-07-05', 4),
(10.00, '2024-08-05', '2023-07-15', 5),
(10.00, '2024-08-05', '2024-01-16', 6),
(25.00, '2024-09-10', '2024-01-20', 7),
(25.00, '2024-09-10', '2024-01-25', 8),
(15.00, '2024-10-25', '2024-01-01', 9),
(15.00, '2024-10-25', '2024-01-05', 10);