DROP DATABASE IF EXISTS bokhandel;

GO

CREATE DATABASE bokhandel;

GO

USE bokhandel;

GO

CREATE TABLE Författare (
    FörfattareID INT PRIMARY KEY IDENTITY(1,1),
    Förnamn NVARCHAR(50) NOT NULL,
    Efternamn NVARCHAR(50) NOT NULL,
    Födelsedatum DATE NOT NULL,
    Dödsdatum DATE
);

GO

CREATE TABLE Böcker (
    ISBN13 CHAR(13) PRIMARY KEY,
    Titel VARCHAR(100) NOT NULL,
    Språk VARCHAR(50) NOT NULL,
    Pris DECIMAL(10, 2) NOT NULL CHECK (Pris > 0),
    Sidor SMALLINT,
    Utgivningsdatum DATE NOT NULL,
    FörfattareID INT NOT NULL,
    FOREIGN KEY (FörfattareID) REFERENCES Författare(FörfattareID)
);

GO

CREATE TABLE Butiker (
    ButikID INT PRIMARY KEY IDENTITY(1,1),
    Namn VARCHAR(50) NOT NULL,
    Adress VARCHAR(100) NOT NULL,
    Stad VARCHAR(50) NOT NULL,
    Telefonnummer CHAR(10)
);

GO

CREATE TABLE LagerSaldo (
    ButikID INT NOT NULL,
    ISBN13 CHAR(13) NOT NULL,
    Antal INT NOT NULL DEFAULT 0,
    PRIMARY KEY (ButikID, ISBN13),
    FOREIGN KEY (ButikID) REFERENCES Butiker(ButikID),
    FOREIGN KEY (ISBN13) REFERENCES Böcker(ISBN13)
);

GO

CREATE TABLE Anställda (
    AnställdID INT PRIMARY KEY IDENTITY(1,1),
    Förnamn NVARCHAR(50) NOT NULL,
    Efternamn NVARCHAR(50) NOT NULL,
    Anställningsdatum DATE NOT NULL,
    ButikID INT NOT NULL,
    FOREIGN KEY (ButikID) REFERENCES Butiker(ButikID)
);

GO

CREATE TABLE Kunder (
    KundID INT PRIMARY KEY IDENTITY(1,1),
    Förnamn NVARCHAR(50) NOT NULL,
    Efternamn NVARCHAR(50) NOT NULL,
    Epost VARCHAR(100) NOT NULL UNIQUE,
    Telefonnummer CHAR(10)
);

GO

CREATE TABLE Ordrar (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    KundID INT NOT NULL,
    ButikID INT NOT NULL,
    OrderDatum DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (KundID) REFERENCES Kunder(KundID),
    FOREIGN KEY (ButikID) REFERENCES Butiker(ButikID)
);

GO

CREATE TABLE OrderDetaljer (
    OrderID INT NOT NULL,
    ISBN13 CHAR(13) NOT NULL,
    Antal INT NOT NULL CHECK (Antal > 0),
    Pris DECIMAL(10, 2) NOT NULL CHECK (Pris > 0),
    TotalPris AS (Antal * Pris) PERSISTED,
    PRIMARY KEY (OrderID, ISBN13),
    FOREIGN KEY (OrderID) REFERENCES Ordrar(OrderID),
    FOREIGN KEY (ISBN13) REFERENCES Böcker(ISBN13)
);

GO

INSERT INTO Författare (Förnamn, Efternamn, Födelsedatum, Dödsdatum) VALUES
('Astrid', 'Lindgren', '1907-11-14', '2002-01-28'),
('J.K.', 'Rowling', '1965-07-31', NULL),
('George', 'Orwell', '1903-06-25', '1950-01-21'),
('Jane', 'Austen', '1775-12-16', '1817-07-18'),
('Mark', 'Twain', '1835-11-30', '1910-04-21'),
('Agatha', 'Christie', '1890-09-15', '1976-01-12'),
('Stephen', 'King', '1947-09-21', NULL),
('Ernest', 'Hemingway', '1899-07-21', '1961-07-02'),
('F. Scott', 'Fitzgerald', '1896-09-24', '1940-12-21'),
('Harper', 'Lee', '1926-04-28', '2016-02-19'),
('Leo', 'Tolstoy', '1828-09-09', '1910-11-20'),
('Charles', 'Dickens', '1812-02-07', '1870-06-09'),
('Virginia', 'Woolf', '1882-01-25', '1941-03-28'),
('H.G.', 'Wells', '1866-09-21', '1946-08-13'),
('J.R.R.', 'Tolkien', '1892-01-03', '1973-09-02'),
('Fyodor', 'Dostoevsky', '1821-11-11', '1881-02-09'),
('Edgar', 'Allan Poe', '1809-01-19', '1849-10-07'),
('Oscar', 'Wilde', '1854-10-16', '1900-11-30'),
('Emily', 'Bronte', '1818-07-30', '1848-12-19'),
('Herman', 'Melville', '1819-08-01', '1891-09-28');

GO

INSERT INTO Böcker (ISBN13, Titel, Språk, Pris, Sidor, Utgivningsdatum, FörfattareID) VALUES
('9789123456789', 'Pippi Långstrump', 'Svenska', 99.90, 128, '1945-10-01', 1),
('9780747532743', 'Harry Potter och de vises sten', 'Engelska', 149.90, 223, '1997-06-26', 2),
('9780451524935', '1984', 'Engelska', 89.90, 328, '1949-06-08', 3),
('9780141439518', 'Stolthet och fördom', 'Engelska', 79.90, 279, '1813-01-28', 4),
('9780486280615', 'Tom Sawyer', 'Engelska', 49.90, 274, '1876-06-01', 5),
('9780062073488', 'Mordet på Orientexpressen', 'Engelska', 129.90, 256, '1934-01-01', 6),
('9781501142970', 'The Shining', 'Engelska', 119.90, 447, '1977-01-28', 7),
('9780684801223', 'The Old Man and the Sea', 'Engelska', 59.90, 127, '1952-09-01', 8),
('9780743273565', 'The Great Gatsby', 'Engelska', 89.90, 180, '1925-04-10', 9),
('9780061120084', 'To Kill a Mockingbird', 'Engelska', 99.90, 281, '1960-07-11', 10),
('9780140447934', 'War and Peace', 'Ryska', 149.90, 1225, '1869-01-01', 11),
('9780141439600', 'Oliver Twist', 'Engelska', 79.90, 554, '1838-02-01', 12),
('9780156907392', 'Mrs Dalloway', 'Engelska', 69.90, 194, '1925-05-14', 13),
('9780451532084', 'The War of the Worlds', 'Engelska', 89.90, 192, '1898-01-01', 14),
('9780544003415', 'The Hobbit', 'Engelska', 129.90, 310, '1937-09-21', 15),
('9780140449136', 'Crime and Punishment', 'Ryska', 119.90, 671, '1866-01-01', 16),
('9780142438034', 'The Tell-Tale Heart and Other Stories', 'Engelska', 49.90, 128, '1843-01-01', 17),
('9780141439570', 'The Picture of Dorian Gray', 'Engelska', 79.90, 254, '1890-06-20', 18),
('9780141439556', 'Wuthering Heights', 'Engelska', 69.90, 416, '1847-12-01', 19),
('9780142437242', 'Moby-Dick', 'Engelska', 99.90, 635, '1851-10-18', 20),
('9780747538494', 'Harry Potter och hemligheternas kammare', 'Engelska', 149.90, 251, '1998-07-02', 2),
('9780747542155', 'Harry Potter och fången från Azkaban', 'Engelska', 149.90, 317, '1999-07-08', 2);

GO

INSERT INTO Butiker (Namn, Adress, Stad, Telefonnummer) VALUES
('Bokhandeln A', 'Storgatan 1', 'Stockholm', '0701234567'),
('Bokhandeln B', 'Drottninggatan 5', 'Göteborg', '0717654321'),
('Bokhandeln C', 'Kungsgatan 10', 'Malmö', '0709876543'),
('Bokhandeln D', 'Vasagatan 15', 'Uppsala', '0781234567');

GO

INSERT INTO LagerSaldo (ButikID, ISBN13, Antal) VALUES
(1, '9789123456789', 10),
(2, '9780747532743', 15),
(3, '9780451524935', 8),
(4, '9780141439518', 12),
(1, '9780141439570', 5),
(2, '9780141439556', 7),
(3, '9780142438034', 6),
(4, '9780142437242', 4),
(1, '9780544003415', 3),
(2, '9781501142970', 2),
(3, '9780684801223', 4),
(4, '9780062073488', 6),
(1, '9780743273565', 3),
(1, '9780747538494', 10),
(2, '9780747542155', 12);

GO

INSERT INTO Anställda (Förnamn, Efternamn, Anställningsdatum, ButikID) VALUES
('Anna', 'Andersson', '2020-01-15', 1),
('Björn', 'Berg', '2019-03-22', 2),
('Carina', 'Carlsson', '2021-07-10', 3),
('David', 'Dahl', '2018-11-05', 4),
('Eva', 'Eriksson', '2020-05-20', 1),
('Fredrik', 'Fransson', '2019-09-30', 2),
('Gustav', 'Gustafsson', '2021-02-14', 3),
('Hanna', 'Hansson', '2018-12-01', 4),
('Isabella', 'Isaksson', '2020-08-25', 1),
('Johan', 'Johansson', '2019-04-18', 2),
('Karin', 'Karlsson', '2021-01-05', 3),
('Lars', 'Larsson', '2018-10-10', 4);

GO

INSERT INTO Kunder (Förnamn, Efternamn, Epost, Telefonnummer) VALUES
('Maria', 'Månsson', 'maria.mansson@example.com', '0701234567'),
('Oskar', 'Olsson', 'oskar.olsson@example.com', '0702345678'),
('Sara', 'Svensson', 'sara.svensson@example.com', '0703456789'),
('Erik', 'Eriksson', 'erik.eriksson@example.com', '0704567890'),
('Anna', 'Andersson', 'anna.andersson@example.com', '0705678901'),
('Björn', 'Berg', 'bjorn.berg@example.com', '0706789012'),
('Carina', 'Carlsson', 'carina.carlsson@example.com', '0707890123'),
('David', 'Dahl', 'david.dahl@example.com', '0708901234'),
('Eva', 'Eriksson', 'eva.eriksson@example.com', '0709012345'),
('Fredrik', 'Fransson', 'fredrik.fransson@example.com', '0709123456'),
('Gustav', 'Gustafsson', 'gustav.gustafsson@example.com', '0709234567'),
('Hanna', 'Hansson', 'hanna.hansson@example.com', '0709345678'),
('Isabella', 'Isaksson', 'isabella.isaksson@example.com', '0709456789');

GO

INSERT INTO Ordrar (KundID, ButikID) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 1),
(6, 2),
(7, 3),
(8, 4),
(9, 1),
(10, 2),
(11, 3),
(12, 4),
(13, 1);

GO

INSERT INTO OrderDetaljer (OrderID, ISBN13, Antal, Pris) VALUES
(1, '9789123456789', 1, 99.90),
(2, '9780747532743', 2, 149.90),
(3, '9780451524935', 1, 89.90),
(4, '9780141439518', 3, 79.90),
(5, '9780141439570', 1, 79.90),
(6, '9780141439556', 2, 69.90),
(7, '9780142438034', 1, 49.90),
(8, '9780142437242', 2, 99.90),
(9, '9780544003415', 1, 129.90),
(10, '9781501142970', 2, 119.90),
(11, '9780684801223', 1, 59.90),
(12, '9780062073488', 2, 129.90),
(13, '9780743273565', 1, 89.90);

GO

CREATE VIEW TitlarPerFörfattare AS
SELECT 
    CONCAT(f.Förnamn, ' ', f.Efternamn) AS Namn,
    CONCAT(DATEDIFF(YEAR, f.Födelsedatum, ISNULL(f.Dödsdatum, GETDATE())), CASE WHEN f.Dödsdatum IS NOT NULL THEN ' (död)' ELSE ' år' END) AS Ålder,
    COUNT(DISTINCT b.ISBN13) AS Titlar,
    ISNULL(SUM(b.Pris * ls.Antal), 0) AS Lagervärde
FROM Författare f
LEFT JOIN Böcker b ON f.FörfattareID = b.FörfattareID
LEFT JOIN LagerSaldo ls ON b.ISBN13 = ls.ISBN13
GROUP BY f.FörfattareID, f.Förnamn, f.Efternamn, f.Födelsedatum, f.Dödsdatum;

GO

SELECT * FROM TitlarPerFörfattare;

GO

CREATE PROCEDURE FlyttaBöcker
    @FrånButikID INT,
    @TillButikID INT,
    @ISBN13 CHAR(13),
    @Antal INT = 1
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Butiker WHERE ButikID = @FrånButikID)
        BEGIN
            RAISERROR('Källbutiken existerar inte.', 16, 1);
        END
        
        IF NOT EXISTS (SELECT 1 FROM Butiker WHERE ButikID = @TillButikID)
        BEGIN
            RAISERROR('Målbutiken existerar inte.', 16, 1);
        END
        
        IF NOT EXISTS (SELECT 1 FROM Böcker WHERE ISBN13 = @ISBN13)
        BEGIN
            RAISERROR('Boken existerar inte.', 16, 1);
        END
        
        IF @Antal <= 0
        BEGIN
            RAISERROR('Antal måste vara större än 0.', 16, 1);
        END
        
        IF NOT EXISTS (
            SELECT 1 FROM LagerSaldo WITH (UPDLOCK) 
            WHERE ButikID = @FrånButikID 
            AND ISBN13 = @ISBN13 
            AND Antal >= @Antal
        )
        BEGIN
            RAISERROR('Källbutiken har inte tillräckligt med exemplar.', 16, 1);
        END
        
        UPDATE LagerSaldo 
        SET Antal = Antal - @Antal 
        WHERE ButikID = @FrånButikID 
        AND ISBN13 = @ISBN13;
        
        IF NOT EXISTS (SELECT 1 FROM LagerSaldo WHERE ButikID = @TillButikID AND ISBN13 = @ISBN13)
        BEGIN
            INSERT INTO LagerSaldo (ButikID, ISBN13, Antal) 
            VALUES (@TillButikID, @ISBN13, @Antal);
        END
        ELSE
        BEGIN
            UPDATE LagerSaldo 
            SET Antal = Antal + @Antal 
            WHERE ButikID = @TillButikID 
            AND ISBN13 = @ISBN13;
        END
        
        COMMIT TRANSACTION;
        PRINT CONCAT('Framgångsrik förflyttning: ', @Antal, ' exemplar av ISBN ', @ISBN13, ' från butik ', @FrånButikID, ' till butik ', @TillButikID, '.');
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;