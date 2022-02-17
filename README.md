# Taiwan Amphibian Conservation data to GBIF

## Sampling Event

Event Core:

```sql
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
```

Occurrence:

```
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
```

## Problems

- frogmasterrecord.observers 是用 id跟逗號 的字串儲存，不好變成名字
  - 有用 MySQL 的 FIND_IN_SET 跟 GROUP_CONCAT 搭配 GROUP BY 處理，但是速度很慢
  - 要另外稍微用 python 程式處理 `scripts/insert-member-name.py`
- zipcode 另外建一個表 zipcode_citytown

```sql
-- Adminer 4.8.1 MySQL 5.6.51 dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

DROP TABLE IF EXISTS `observer_member_rel`;
CREATE TABLE `observer_member_rel` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `master_record_no` int(11) NOT NULL,
  `member_id` int(11) NOT NULL,
  `names` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `zipcode_citytown`;
CREATE TABLE `zipcode_citytown` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `zipcode` varchar(50) NOT NULL,
  `name` varchar(256) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


-- 2022-02-17 18:38:03
```

## Reference
- [Darwin Core quick reference guide - Darwin Core](https://dwc.tdwg.org/terms/)

### Related Datasets

- [臺灣兩棲類資源調查與教育宣導推廣計畫 Resources survey and education advocacy to promote for Taiwan amphibian resources](https://ipt.taibif.tw/resource?r=a10200602)