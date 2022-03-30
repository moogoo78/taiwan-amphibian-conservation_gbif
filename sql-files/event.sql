/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

SELECT
  e.master_record_no AS eventID,
  'Event' AS type,
  'https://tad.froghome.org/guide/index.html' AS samplingProtocol,
  CONCAT(DATE_FORMAT(e.init_time, '%Y-%m-%dT%H:%i:%S'), '+08/', DATE_FORMAT(e.stop_time, '%Y-%m-%dT%H:%i:%S'), '+08') AS eventDate,
  'Taiwan' AS country,
  'TW' AS countryCode,
  SUBSTRING_INDEX(z.name,' ', 1) AS county,
  SUBSTRING_INDEX(z.name,' ', -1) AS municipality,
  IF(f.frog_id IN (16, 17, 21, 28, 29, 31, 32),
           SUBSTRING(e.position, 1, 2),
           e.position
          ) AS locality,
  e.locationset_no AS locationID,  
  e.altitude AS minimumElevationInMeters,
  'WGS84' AS geodeticDatum,
  IF(f.frog_id IN (16, 17, 21, 28, 29, 31, 32),
           TRUNCATE(e.longitude, 2),
           e.longitude
          ) AS decimalLongitude,
  IF(f.frog_id IN (16, 17, 21, 28, 29, 31, 32),
           TRUNCATE(e.latitude, 2),
           e.latitude
          ) AS decimalLatitude,
  IF(f.frog_id IN (16, 17, 21, 28, 29, 31, 32),
           'round down to 2 decimal places 小數點下2位無條件捨去',
           ''
          ) AS dataGeneralizations,
  IF(f.frog_id IN (16, 17, 21, 28, 29, 31, 32),
           'location information not given for endangered species',
           ''
          ) AS informationWithheld,
  IF(f.frog_id IN (16, 17, 21, 28, 29, 31, 32),
           '0.001',
           '0.00001'
          ) AS coordinatePrecision,
  '1000' AS coordinateUncertaintyInMeters
FROM frogmasterdata AS e
LEFT JOIN frogdetaildata AS d ON d.master_record_no = e.master_record_no
LEFT JOIN frog2 AS f ON f.frog_id = d.frog_id
LEFT JOIN zipcode_citytown AS z ON z.zipcode = e.zipcode
GROUP BY d.master_record_no
ORDER BY e.master_record_no
