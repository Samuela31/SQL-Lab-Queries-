CREATE TABLE TableName (
  aid VARCHAR(3) PRIMARY KEY,
  xll INT,
  yll INT,
  xur INT,
  yur INT,
  Locality_name VARCHAR(50)
);

INSERT INTO TableName (aid, xll, yll, xur, yur, Locality_name)
VALUES ('001', 0, 0, 20, 20, 'AnnaNagar');
INSERT INTO TableName (aid, xll, yll, xur, yur, Locality_name)
VALUES ('002', 0, 20, 20, 50, 'RSPuram');
INSERT INTO TableName (aid, xll, yll, xur, yur, Locality_name)
VALUES ('003', 30, 0, 40, 10, 'KamarajNagar');
INSERT INTO TableName (aid, xll, yll, xur, yur, Locality_name)
VALUES ('004', 30, 20, 50, 40, 'KPalayam');
INSERT INTO TableName (aid, xll, yll, xur, yur, Locality_name)
VALUES ('005', 10, 10, 20, 20, 'NehruNagar');
INSERT INTO TableName (aid, xll, yll, xur, yur, Locality_name)
VALUES ('006', 20, 20, 40, 40, 'SBColony');

--query selects all localities where the defined area (from (10, 10) to (40, 40)) overlaps with the locality boundaries
SELECT Locality_name FROM TableName
WHERE xll <= 40 AND yll <= 40 AND xur >= 10 AND yur >= 10;

--selects pairs of localities that overlap with each other
SELECT a.Locality_name, b.Locality_name FROM TableName a, TableName b
WHERE a.xll <= b.xur AND a.xur >= b.xll AND a.yll <= b.yur AND a.yur >= b.yll
AND a.Locality_name!=b.Locality_name AND a.aid < b.aid;

--selects localities that are completely contained within the area from (10, 10) to (40, 40)
SELECT Locality_name FROM TableName
WHERE xll >= 10 AND yll >= 10 AND xur <= 40 AND yur <= 40;

--selects the locality with the 3rd largest plinth area (area of the rectangular region defined by the coordinates)
SELECT Locality_name, (xur - xll)*(yur - yll) AS plinth_area
FROM TableName
ORDER BY plinth_area DESC
OFFSET 2 ROWS FETCH NEXT 1 ROWS ONLY;

--selects localities that do not overlap with any other locality
SELECT Locality_name
FROM TableName
WHERE Locality_name NOT IN(
    SELECT DISTINCT a.Locality_name
    FROM TableName a
    JOIN TableName b ON a.aid!= b.aid
    WHERE a.xll <= b.xur AND a.xur >= b.xll AND a.yll <= b.yur AND a.yur >= b.yll
);
