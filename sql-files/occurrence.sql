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
  f.frog_cname AS vernacularName
FROM frogdetaildata AS d
LEFT JOIN frog2 AS f ON f.frog_id = d.frog_id
LEFT JOIN frogmasterdata AS e ON e.master_record_no = d.master_record_no
LEFT JOIN observer_member_rel AS o ON o.master_record_no = d.master_record_no
LEFT JOIN frogteam AS t ON t.team_id = e.team_id
