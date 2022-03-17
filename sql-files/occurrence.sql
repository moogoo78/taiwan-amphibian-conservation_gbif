/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

SELECT
  d.detail_record_no AS occurrenceID,
  d.master_record_no AS eventID,
  'HumanObservation' AS basisOfRecord,
  CONCAT_WS('_', t.team_name, o.names) AS recordedBy,
  CONCAT_WS(' ', f.frog_ename, f.infraspecies, f.author) AS scientificName,
  d.amount AS individualCount,
  'col_taiwan' AS nameAccordingTo,
  f.kingdom AS kingdom,
  f.phylum AS phylum,
  f.order as 'order',
  f.class AS class,
  f.family AS family,
  'species' AS taxonRank,
  f.frog_cname AS vernacularName,  
  CONCAT_WS(' ', z.name, e.position) AS locality,
  e.locationset_no AS locationID,
  'TW' AS countryCode,
  CONCAT(e.altitude, ' m') AS verbatimElevation,
  'WGS84' AS geodeticDatum,
  IF(f.frog_id IN (16, 17, 21, 28, 29, 31, 32),
           TRUNCATE(e.longitude, 2),
           e.longitude
          ) AS verLong,
  IF(f.frog_id IN (16, 17, 21, 28, 29, 31, 32),
           'round down to 2 decimal places 小數點下2位無條件捨去',
           ''
          ) AS dataGeneralizations,
  e.accuracy AS coordinateUncertaintyInMetersProperty
FROM frogdetaildata AS d
LEFT JOIN frog2 AS f ON f.frog_id = d.frog_id
LEFT JOIN frogmasterdata AS e ON e.master_record_no = d.master_record_no
LEFT JOIN observer_member_rel AS o ON o.master_record_no = e.master_record_no
LEFT JOIN frogteam AS t ON t.team_id = e.team_id
LEFT JOIN zipcode_citytown AS z ON z.zipcode = e.zipcode
ORDER BY d.detail_record_no