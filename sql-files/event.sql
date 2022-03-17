/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

SELECT
  e.master_record_no AS eventID,
  'Event' AS type,
  'https://tad.froghome.org/guide/index.html' AS samplingProtocol,
  CONCAT(DATE_FORMAT(e.init_time, '%Y-%m-%dT%H:%i:%S'), '+08/', DATE_FORMAT(e.stop_time, '%Y-%m-%dT%H:%i:%S'), '+08') AS eventDate
FROM frogmasterdata AS e
ORDER BY e.master_record_no
