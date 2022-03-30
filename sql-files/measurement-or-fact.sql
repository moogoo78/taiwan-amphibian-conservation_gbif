/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

SELECT * FROM (

SELECT
  e.master_record_no AS eventID,
  d.detail_record_no AS occurrenceID,
  'habitat' AS measurementType, 
  IFNULL(h.habitat_name,'') AS measurementValue,
  '' AS measurementUnit
FROM frogdetaildata AS d
LEFT JOIN frogmasterdata AS e ON e.master_record_no = d.master_record_no
LEFT JOIN habitat AS h ON h.habitat_id = d.habitat_id

UNION

SELECT
  e.master_record_no AS eventID,
  d.detail_record_no AS occurrenceID,
  'micro habitat' AS measurementType,
  IFNULL(p.habitat_p1_name,'') AS measurementValue,  
  '' AS measurementUnit
FROM frogdetaildata AS d
LEFT JOIN frogmasterdata AS e ON e.master_record_no = d.master_record_no
LEFT JOIN habitatp1 AS p ON p.habitat_p1_id = d.habitat_p1_id

UNION

SELECT
  e.master_record_no AS eventID,
  d.detail_record_no AS occurrenceID,
  'behavior' AS measurementType,
  IFNULL(b.behavior_name,'') AS measurementValue,    
  '' AS measurementUnit
FROM frogdetaildata AS d
LEFT JOIN frogmasterdata AS e ON e.master_record_no = d.master_record_no
LEFT JOIN behavior AS b ON b.behavior_id = d.behavior_id

UNION

SELECT
  e.master_record_no AS eventID,
  d.detail_record_no AS occurrenceID,
  'living type' AS measurementType,
  IFNULL(l.living_type_id,'') AS measurementValue,   
  '' AS measurementUnit
FROM frogdetaildata AS d
LEFT JOIN frogmasterdata AS e ON e.master_record_no = d.master_record_no
LEFT JOIN livingtype AS l ON l.living_type_id = d.living_type_id

UNION

SELECT
  e.master_record_no AS eventID,
  d.detail_record_no AS occurrenceID,
  'temperature' AS measurementType,
  IFNULL(ROUND(e.temperature, 2), '') AS measurementValue,  
  'C' AS measurementUnit
FROM frogdetaildata AS d
LEFT JOIN frogmasterdata AS e ON e.master_record_no = d.master_record_no

UNION

SELECT
  e.master_record_no AS eventID,
  d.detail_record_no AS occurrenceID,
  'humidity' AS measurementType,
  IFNULL(e.humidity,'') AS measurementValue,  
  '%' AS measurementUnit
FROM frogdetaildata AS d
LEFT JOIN frogmasterdata AS e ON e.master_record_no = d.master_record_no

UNION

SELECT
  e.master_record_no AS eventID,
  d.detail_record_no AS occurrenceID,
  'weather' AS measurementType,
  IFNULL(w.weather_name,'') AS measurementValue,    
  '' AS measurementUnit
FROM frogdetaildata AS d
LEFT JOIN frogmasterdata AS e ON e.master_record_no = d.master_record_no
LEFT JOIN weather AS w ON w.weather_id = e.weather_id
) AS a
ORDER BY occurrenceID
