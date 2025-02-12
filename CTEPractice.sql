CREATE DATABASE ConservationStatusDatabase;
USE ConservationStatusDatabase;
 

 
CREATE TABLE Species (
    SpeciesID INT PRIMARY KEY,
    CommonName VARCHAR(100),
    ScientificName VARCHAR(100),
    Habitat VARCHAR(100),
    Venomous TINYINT
);
 
CREATE TABLE Snakes (
    SnakeID INT PRIMARY KEY,
    SpeciesID INT,
    Length DECIMAL(5,2),
    Age INT,
    Color VARCHAR(50),
    FOREIGN KEY (SpeciesID) REFERENCES Species(SpeciesID)
);
 
CREATE TABLE Sightings (
    SightingID INT PRIMARY KEY,
    SnakeID INT,
    Location VARCHAR(100),
    SightingDate DATE,
    Observer VARCHAR(50),
    FOREIGN KEY (SnakeID) REFERENCES Snakes(SnakeID)
);
 
CREATE TABLE ConservationStatus (
    StatusID INT PRIMARY KEY,
    SpeciesID INT,
    Status VARCHAR(100),
    LastUpdated DATE,
    FOREIGN KEY (SpeciesID) REFERENCES Species(SpeciesID)
);
 
INSERT INTO Species (SpeciesID, CommonName, ScientificName, Habitat, Venomous) VALUES
(1, 'King Cobra', 'Ophiophagus hannah', 'Tropical forests', 1),
(2, 'Python', 'Python reticulatus', 'Rainforests', 0),
(3, 'Rattlesnake', 'Crotalus atrox', 'Deserts', 1),
(4, 'Boa Constrictor', 'Boa constrictor', 'Tropical forests', 0),
(5, 'Coral Snake', 'Micrurus fulvius', 'Forests', 1),
(6, 'Garter Snake', 'Thamnophis sirtalis', 'Grasslands', 0),
(7, 'Anaconda', 'Eunectes murinus', 'Swamps', 0),
(8, 'Copperhead', 'Agkistrodon contortrix', 'Woodlands', 1),
(9, 'Black Mamba', 'Dendroaspis polylepis', 'Savannas', 1),
(10, 'Reticulated Python', 'Python reticulatus', 'Rainforests', 0),
(11, 'King Cobra', 'Ophiophagus hannah', 'Tropical forests', 1), -- Duplicate species for more realism
(12, 'Python', 'Python reticulatus', 'Rainforests', 0); -- Duplicate species for more realism
 
 
INSERT INTO Snakes (SnakeID, SpeciesID, Length, Age, Color) VALUES
(1, 1, 3.50, 5, 'Green'),
(2, 1, 4.00, 6, 'Brown'),
(3, 2, 6.20, 8, 'Brown'),
(4, 2, 7.00, 10, 'Golden'),
(5, 3, 1.50, 4, 'Grey'),
(6, 3, 1.80, 5, 'Brown'),
(7, 4, 4.20, 10, 'Brown'),
(8, 4, 5.00, 12, 'Yellow'),
(9, 5, 0.60, 2, 'Red'),
(10, 6, 0.90, 3, 'Green'),
(11, 6, 1.00, 4, 'Striped Green'),
(12, 7, 5.00, 7, 'Green'),
(13, 8, 1.20, 6, 'Brown'),
(14, 9, 2.30, 4, 'Grey'),
(15, 10, 7.50, 12, 'Yellow'),
(16, 1, 3.20, 6, 'Dark Green'), -- Another King Cobra for diversity
(17, 12, 6.00, 9, 'Brown'),  -- Another Python
(18, 12, 6.50, 8, 'Golden');  -- Another Python
 
 
INSERT INTO Sightings (SightingID, SnakeID, Location, SightingDate, Observer) VALUES
(1, 1, 'Amazon', '2025-01-01', 'John'),
(2, 2, 'Rainforest', '2025-01-02', 'Sarah'),
(3, 3, 'Arizona', '2025-01-03', 'Tom'),
(4, 4, 'Brazil', '2025-01-05', 'John'),
(5, 5, 'Mexico', '2025-01-06', 'John'),
(6, 6, 'Canada', '2025-01-10', 'Lucy'),
(7, 7, 'Amazon', '2025-01-12', 'Tom'),
(8, 8, 'Texas', '2025-01-15', 'Lucy'),
(9, 9, 'Africa', '2025-01-16', 'Sarah'),
(10, 10, 'Southeast Asia', '2025-01-20', 'David'),
(11, 1, 'Amazon', '2025-01-22', 'Tom'),  -- Same snake, different date
(12, 2, 'Rainforest', '2025-01-23', 'Sarah'), -- Same snake, different date
(13, 11, 'Southeast Asia', '2025-01-25', 'Tom'),
(14, 13, 'Texas', '2025-01-28', 'David'),
(15, 16, 'Thailand', '2025-02-02', 'Lucy'),
(16, 17, 'Malaysia', '2025-02-03', 'Tom'),
(17, 18, 'Indonesia', '2025-02-05', 'Sarah'),
(18, 8, 'California', '2025-02-06', 'David'),
(19, 5, 'Costa Rica', '2025-02-07', 'Tom'),
(20, 14, 'Africa', '2025-02-10', 'Lucy');
 
 
INSERT INTO ConservationStatus (StatusID, SpeciesID, Status, LastUpdated) VALUES
(1, 1, 'Vulnerable', '2025-01-01'),
(2, 2, 'Least Concern', '2025-01-05'),
(3, 3, 'Near Threatened', '2025-01-10'),
(4, 4, 'Least Concern', '2025-01-15'),
(5, 5, 'Endangered', '2025-01-20'),
(6, 6, 'Least Concern', '2025-01-25'),
(7, 7, 'Least Concern', '2025-01-30'),
(8, 8, 'Endangered', '2025-02-01'),
(9, 9, 'Critically Endangered', '2025-02-05'),
(10, 10, 'Least Concern', '2025-02-10'),
(11, 12, 'Least Concern', '2025-02-15'), -- Another status for Python
(12, 12, 'Vulnerable', '2025-02-20'); -- Changing Python's status to Vulnerable
 
 Select * from Sightings;
 Select * from Species;
 Select * from Snakes;
 Select * from ConservationStatus;

--Q1. Retrieve all sightings of a specific species by common name.
Select si.*,sp.CommonName from Sightings si 
inner join Snakes sn on
si.SnakeID=sn.SnakeID 
inner join  Species sp on
sn.SpeciesID=sp.SpeciesID
Where sp.CommonName='python';

--Solution With CTE
With SpecificSpeciesByCommonName
As
( Select si.*,  Sp.CommonName
from Sightings si
inner join Snakes sn on si.SnakeId=sn.SnakeId
Inner join Species sp on sn.SpeciesId=sp.Speciesid
where sp.CommonName='python')
 Select * from SpecificSpeciesByCommonName;

 
--Q2. Find the average length of snakes by species.
Select avg(Length) as AverageLength, sp.ScientificName,sp.CommonName
from Species sp inner join Snakes sn
on sp.SpeciesId=sn.SpeciesId
inner join Sightings si on
sn.SnakeID=si.SnakeID
Group by sp.ScientificName,sp.CommonName;

--USING CTE
With AvgLenBySpecies
As(
Select avg(Length) as AverageLength, sp.ScientificName,sp.CommonName
from Species sp inner join Snakes sn
on sp.SpeciesId=sn.SpeciesId
inner join Sightings si on
sn.SnakeID=si.SnakeID
Group by sp.ScientificName,sp.CommonName
) Select * from AvgLenBySpecies;

--Q3. Find the top 5 longest snakes for each species.
With FiveLongestSnake
As(
Select sn.Length , sp.ScientificName,sp.CommonName,
Row_Number() Over(Partition by sp.SpeciesId 
order by sn.Length DESC) AS RowNum
from Species sp inner join Snakes sn
on sp.SpeciesId=sn.SpeciesId
inner join Sightings si on
sn.SnakeID=si.SnakeID
) Select  Length,
ScientificName,CommonName 
from FiveLongestSnake
Where RowNum<=5
Order by CommonName,RowNum; 

--Q4. Identify the observer who has seen the highest number of different
--species.
Select top 1 si.Observer, Count(distinct sp.SpeciesId) as NumberofSpecies
from Sightings si inner join
Snakes sn on si.SnakeId=sn.SnakeID
inner join Species sp
on sn.SpeciesID=sp.SpeciesID
Group by si.Observer
order by NumberofSpecies DESC;


--Q5. Determine the change in conservation status for species over time.
Select * from ConservationStatus;

--Q6. List species that are classified as "Endangered" and have been 
--sighted more than 10 times.
Select 
sp.SpeciesId,sp.ScientificName,
count(si.SightingId) as TotalSighted,
cs.Status 
from Sightings si
inner join Snakes sn on
si.SnakeId=sn.SnakeId
inner join ConservationStatus cs
on sn.SpeciesId=cs.SpeciesId
inner join Species sp
on sp.SpeciesId=cs.SpeciesId
where cs.status='Endangered' 
GROUP BY 
    sp.SpeciesId, 
    sp.ScientificName, 
    cs.Status
HAVING COUNT(si.SightingId) > 10;

