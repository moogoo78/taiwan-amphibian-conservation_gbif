/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

SELECT
  e.master_record_no AS eventID,
  'Event' AS type,
  'https://tad.froghome.org/guide/index.html' AS samplingProtocol,
  CONCAT(DATE_FORMAT(e.init_time, '%Y-%m-%dT%H:%i:%S'), '+08/', DATE_FORMAT(e.stop_time, '%Y-%m-%dT%H:%i:%S'), '+08') AS eventDate,
  CONCAT_WS(' ', z.name, e.position) AS locality,
  e.locationset_no AS locationID,
  'TW' AS countryCode,
  CONCAT(e.altitude, ' m') AS verbatimElevation,
  e.longitude AS decimalLongitude,
  e.latitude AS decimalLatitude,
  'WGS84' AS geodeticDatum,
  e.accuracy AS coordinateUncertaintyInMetersProperty
FROM frogmasterdata AS e 
LEFT JOIN zipcode_citytown AS z ON z.zipcode = e.zipcode
ORDER BY e.master_record_no
