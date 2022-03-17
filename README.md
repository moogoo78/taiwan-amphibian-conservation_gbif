# Taiwan Amphibian Conservation data to GBIF

[台灣兩棲類動物保育協會](https://www.froghome.org/)

## Sampling Event

Create csv (txt extension) from SQL files:

- [event.sql](./sql-files/event.sql)
- [occurrence.sql](./sql-files/occurrence.sql)
- [measurement-or-facts.sql](./sql-files/mearusement-or-facts.sql)

1. copy sql to docker volume

```sh
$ cp sql-files/*.sql ../frog-gbif-volumes/bucket
```

2. run in docker
```sh
$ dokcer-compose exec db bash
```

3. export data to csv
```sh
$ mysql -u root -p frog < /bucket/{foo.sql} > /bucket/{foo.csv}
```

## Development

Run MySQL & Adminer.php by docker-compose

```
$ docker-compose up
```

## Problems

- 學名
  - 舊學名原始資料狀況不明 (`originalNameUsage`, `acceptedNameUsage`, `acceptedNameUsageID`)
- recordedBy
  - frogmasterrecord.observers 是用 id跟逗號 的字串儲存: 不好變成名字
  - 用 MySQL 的 FIND_IN_SET 跟 GROUP_CONCAT 搭配 GROUP BY 處理，但是速度很慢
  - 另外稍微用 python 程式處理 [insert-member-name.py](./scripts/insert-member-name.py)
- zipcode 另外建一個表 zipcode_citytown
  - 產生 zipcode 對照 **"{縣市} {鄉鎮/區}"** [insert-zipcode.py](./scripts/insert-zipcode.py)

source data:

- table: habitat 的 `暫時性靜止水域` 跟 `永久性靜止水域` 最後多一個 `\t`


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
  PRIMARY KEY (`id`),
  KEY `master_record_no` (`master_record_no`)
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
- [gbif/doc-sensitive-species-best-practices: This document aims to describe current best practices for dealing with primary occurrence data for sensitive species and provide guidance on how to make as freely data available as possible and as protected as necessary.](https://github.com/gbif/doc-sensitive-species-best-practices)

### Related Datasets

- [臺灣兩棲類資源調查與教育宣導推廣計畫 Resources survey and education advocacy to promote for Taiwan amphibian resources](https://ipt.taibif.tw/resource?r=a10200602)
