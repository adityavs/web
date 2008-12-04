
SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";



-- --------------------------------------------------------
-- create and convert countries
-- --------------------------------------------------------
CREATE TABLE roscms_countries (
  id bigint(20) unsigned NOT NULL auto_increment,
  name varchar(64) collate utf8_unicode_ci NOT NULL,
  name_short varchar(2) collate utf8_unicode_ci NOT NULL,
  PRIMARY KEY  (id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO roscms_countries
SELECT
  NULL,
  coun_name,
  coun_id
FROM user_countries
ORDER BY coun_name ASC;

DROP TABLE user_countries;



-- --------------------------------------------------------
-- create and convert languages
-- --------------------------------------------------------
CREATE TABLE roscms_languages (
  id bigint(20) unsigned NOT NULL auto_increment,
  name varchar(64) collate utf8_unicode_ci NOT NULL,
  name_short varchar(8) collate utf8_unicode_ci NOT NULL,
  name_original varchar(64) collate utf8_unicode_ci NOT NULL,
  level int(10) unsigned NOT NULL,
  PRIMARY KEY  (id),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY name_short (name_short)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO roscms_languages
SELECT
  NULL,
  lang_name,
  lang_id,
  lang_name_org,
  lang_level
FROM languages
ORDER BY lang_name ASC;

DROP TABLE languages;
DROP TABLE user_language;



-- --------------------------------------------------------
-- create and convert filters
-- --------------------------------------------------------
CREATE TABLE roscms_filter (
  id bigint(20) unsigned NOT NULL auto_increment,
  user_id bigint(20) NOT NULL COMMENT '->accounts(id); -1=system',
  name varchar(32) collate utf8_unicode_ci NOT NULL,
  setting tinytext collate utf8_unicode_ci NOT NULL,
  PRIMARY KEY  (id),
  UNIQUE KEY user_id_2 (user_id, name),
  KEY user_id (user_id),
  KEY name (name)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- only include smart filters (labels aren't used by now and will be implemented by tags)
INSERT INTO roscms_filter
SELECT
  NULL,
  filt_usrid,
  filt_title,
  filt_string
FROM data_user_filter WHERE filt_type = 1
ORDER BY filt_usrid ASC, filt_title ASC;

DROP TABLE data_user_filter;



-- --------------------------------------------------------
-- create and convert groups
-- --------------------------------------------------------
CREATE TABLE roscms_groups (
  id bigint(20) unsigned NOT NULL auto_increment,
  name varchar(32) collate utf8_unicode_ci NOT NULL,
  name_short varchar(10) collate utf8_unicode_ci NOT NULL,
  security_level tinyint(3) unsigned NOT NULL,
  description varchar(255) collate utf8_unicode_ci NOT NULL,
  visible tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (id),
  UNIQUE KEY name (name),
  UNIQUE KEY name_short (name_short),
  KEY security_level (security_level)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO roscms_groups
SELECT
  NULL,
  usrgroup_name,
  usrgroup_name_id,
  usrgroup_seclev,
  usrgroup_description,
  usrgroup_visible
FROM usergroups
ORDER BY usrgroup_name;

DROP TABLE usergroups;



-- --------------------------------------------------------
-- create depency table (nothing to convert, as it's new and will be filled later)
-- --------------------------------------------------------
CREATE TABLE roscms_rel_revisions_depencies (
  rev_id bigint(20) unsigned NOT NULL COMMENT '->entries_revisions(id)',
  dependent_from bigint(20) unsigned NOT NULL COMMENT '->entries_revisions(id)',
  PRIMARY KEY  (rev_id,dependent_from),
  KEY rev_id (rev_id),
  KEY dependent_from (dependent_from)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



-- --------------------------------------------------------
-- create and convert access lists (allowed groups are stored in rel_groups_access)
-- --------------------------------------------------------
CREATE TABLE roscms_access (
  id bigint(20) unsigned NOT NULL auto_increment,
  name varchar(100) collate utf8_unicode_ci NOT NULL,
  description varchar(255) collate utf8_unicode_ci NOT NULL,
  old_id varchar(50) collate utf8_unicode_ci NOT NULL,
  PRIMARY KEY  (id),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO roscms_access
SELECT
  NULL,
  sec_fullname,
  sec_description,
  sec_name
FROM data_security
ORDER BY sec_name;



-- --------------------------------------------------------
-- create access lists (need to run seperate script)
-- --------------------------------------------------------
CREATE TABLE roscms_rel_groups_access (
  acl_id bigint(20) unsigned NOT NULL COMMENT '->access(id)',
  group_id bigint(20) unsigned NOT NULL COMMENT '->groups(id)',
  can_read tinyint(1) NOT NULL default '0',
  can_write tinyint(1) NOT NULL default '0',
  can_add tinyint(1) NOT NULL default '0',
  can_delete tinyint(1) NOT NULL default '0',
  can_publish tinyint(1) NOT NULL default '0',
  can_translate tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (acl_id,group_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO roscms_rel_groups_access
SELECT
  a.id,
  g.id,
  s.sec_lev1_read,
  s.sec_lev1_write,
  s.sec_lev1_add,
  s.sec_lev1_add,
  s.sec_lev1_pub,
  s.sec_lev1_trans
FROM roscms_access a JOIN data_security s ON a.old_id=s.sec_name JOIN roscms_groups g WHERE g.security_level = 1
UNION
SELECT
  a.id,
  g.id,
  s.sec_lev2_read,
  s.sec_lev2_write,
  s.sec_lev2_add,
  s.sec_lev2_add,
  s.sec_lev2_pub,
  s.sec_lev2_trans
FROM roscms_access a JOIN data_security s ON a.old_id=s.sec_name JOIN roscms_groups g WHERE g.security_level = 2
UNION
SELECT
  a.id,
  g.id,
  s.sec_lev3_read,
  s.sec_lev3_write,
  s.sec_lev3_add,
  s.sec_lev3_add,
  s.sec_lev3_pub,
  s.sec_lev3_trans
FROM roscms_access a JOIN data_security s ON a.old_id=s.sec_name JOIN roscms_groups g WHERE g.security_level = 3;

UPDATE roscms_rel_groups_access ga JOIN roscms_groups g ON ga.group_id=g.id JOIN roscms_access a ON ga.acl_id=a.id JOIN data_security s ON a.old_id=s.sec_name
SET ga.can_read=TRUE, ga.can_write=TRUE, ga.can_add=TRUE, ga.can_delete=TRUE, ga.can_publish=TRUE, ga.can_translate=TRUE WHERE s.sec_allow LIKE CONCAT('%',g.name_short,'%');

UPDATE roscms_rel_groups_access ga JOIN roscms_groups g ON ga.group_id=g.id JOIN roscms_access a ON ga.acl_id=a.id JOIN data_security s ON a.old_id=s.sec_name
SET ga.can_read=FALSE, ga.can_write=FALSE, ga.can_add=FALSE, ga.can_delete=FALSE, ga.can_publish=FALSE, ga.can_translate=FALSE WHERE s.sec_deny LIKE CONCAT('%',g.name_short,'%');

DROP TABLE data_security;

-- --------------------------------------------------------
-- create and convert group memberships
-- --------------------------------------------------------
CREATE TABLE roscms_rel_groups_accounts (
  group_id bigint(20) unsigned NOT NULL COMMENT '->groups(id)',
  user_id bigint(20) unsigned NOT NULL COMMENT '->accounts(id)',
  PRIMARY KEY  (group_id,user_id),
  KEY group_id (group_id),
  KEY user_id (user_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO roscms_rel_groups_accounts
SELECT
  g.id,
  m.usergroupmember_userid
FROM usergroup_members m JOIN roscms_groups g ON m.usergroupmember_usergroupid=g.name_short;

DROP TABLE usergroup_members;



-- --------------------------------------------------------
-- create and convert entries
-- --------------------------------------------------------
CREATE TABLE roscms_entries (
  id bigint(20) unsigned NOT NULL auto_increment,
  type enum('page','content','script','template','system') collate utf8_unicode_ci NOT NULL,
  name varchar(64) collate utf8_unicode_ci NOT NULL,
  acl_id bigint(20) unsigned COMMENT '->access(id)',
  old_id int(11) NOT NULL,
  old_archive tinyint(1) NOT NULL,
  PRIMARY KEY  (id),
  KEY acl_id (acl_id),
  KEY type (type),
  KEY name (name)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO roscms_entries
SELECT
  NULL,
  d.data_type,
  d.data_name,
  s.id,
  d.data_id,
  0
FROM data_a d JOIN roscms_access s ON d.data_acl=s.old_id
UNION
SELECT
  NULL,
  d.data_type,
  d.data_name,
  s.id,
  d.data_id,
  1
FROM data_ d JOIN roscms_access s ON d.data_acl=s.old_id;

-- double entries are removed after converting revisions
DROP TABLE data_;
DROP TABLE data_a;



-- --------------------------------------------------------
-- create and convert entry revisions
-- --------------------------------------------------------
CREATE TABLE roscms_entries_revisions (
  id bigint(20) unsigned NOT NULL auto_increment,
  data_id bigint(20) unsigned NOT NULL COMMENT '->entries(id)',
  lang_id bigint(20) unsigned NOT NULL COMMENT '->languages(id)',
  user_id bigint(20) unsigned NOT NULL COMMENT '->accounts(id)',
  version int(10) unsigned NOT NULL,
  `datetime` datetime NOT NULL,
  archive tinyint(1) NOT NULL,
  old_id int(11) NOT NULL,
  PRIMARY KEY  (id),
  KEY data_id (data_id),
  KEY `language` (lang_id),
  KEY user_id (user_id),
  KEY version (version)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- old_id will be dropped after tag convert
INSERT INTO roscms_entries_revisions
SELECT
  NULL,
  d.id,
  l.id,
  r.rev_usrid,
  r.rev_version,
  r.rev_datetime,
  1,
  r.rev_id
FROM data_revision_a r JOIN roscms_languages l ON r.rev_language=l.name_short JOIN roscms_entries d ON (d.old_id=r.data_id AND d.old_archive IS TRUE)
UNION
SELECT
  NULL,
  d.id,
  l.id,
  r.rev_usrid,
  r.rev_version,
  r.rev_datetime,
  0,
  r.rev_id
FROM data_revision r JOIN roscms_languages l ON r.rev_language=l.name_short JOIN roscms_entries d ON (d.old_id=r.data_id AND d.old_archive IS FALSE);

DROP TABLE data_revision;
DROP TABLE data_revision_a;



-- --------------------------------------------------------
-- remove double entries from database
-- --------------------------------------------------------
CREATE TABLE roscms_converter_temp (
  old_data_id bigint(20) unsigned NOT NULL,
  new_data_id bigint(20) unsigned NOT NULL,
  KEY old_data_id (old_data_id),
  KEY new_data_id (new_data_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO roscms_converter_temp
SELECT DISTINCT
  b.id,
  a.id
FROM roscms_entries a JOIN roscms_entries b ON (a.name=b.name AND a.type=b.type AND b.old_archive IS TRUE AND a.old_archive IS FALSE);

UPDATE roscms_entries_revisions r JOIN roscms_converter_temp c ON r.data_id=c.old_data_id SET r.data_id=c.new_data_id;
DELETE FROM roscms_entries WHERE id IN (SELECT old_data_id FROM roscms_converter_temp);

ALTER TABLE roscms_entries
  DROP old_id,
  DROP old_archive,
  ADD UNIQUE KEY type_name ( type , name );

DROP TABLE roscms_converter_temp;



-- --------------------------------------------------------
-- create and convert stexts
-- --------------------------------------------------------
CREATE TABLE roscms_entries_stext (
  id bigint(20) unsigned NOT NULL auto_increment,
  rev_id bigint(20) unsigned NOT NULL COMMENT '->entries_revisions(id)',
  name varchar(32) collate utf8_unicode_ci NOT NULL,
  content varchar(255) collate utf8_unicode_ci NOT NULL,
  PRIMARY KEY  (id),
  UNIQUE KEY rev_id_2 (rev_id, name),
  KEY rev_id (rev_id),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO roscms_entries_stext
SELECT
  NULL,
  r.id,
  t.stext_name,
  t.stext_content
FROM data_stext_a t JOIN roscms_entries_revisions r ON (t.data_rev_id=r.old_id AND r.archive IS TRUE)
UNION
SELECT
  NULL,
  r.id,
  t.stext_name,
  t.stext_content
FROM data_stext t JOIN roscms_entries_revisions r ON (t.data_rev_id=r.old_id AND r.archive IS FALSE);

DROP TABLE data_stext;
DROP TABLE data_stext_a;



-- --------------------------------------------------------
-- create and convert texts
-- --------------------------------------------------------
CREATE TABLE roscms_entries_text (
  id bigint(20) unsigned NOT NULL auto_increment,
  rev_id bigint(20) unsigned NOT NULL COMMENT '->entries_revisions(id)',
  name varchar(32) collate utf8_unicode_ci NOT NULL,
  content text collate utf8_unicode_ci NOT NULL,
  PRIMARY KEY  (id),
  KEY rev_id (rev_id),
  KEY `name` (`name`),
  FULLTEXT KEY content (content)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO roscms_entries_text
SELECT
  NULL,
  r.id,
  t.text_name,
  t.text_content
FROM data_text_a t JOIN roscms_entries_revisions r ON (t.data_rev_id=r.old_id AND r.archive IS TRUE)
UNION
SELECT
  NULL,
  r.id,
  t.text_name,
  t.text_content
FROM data_text t JOIN roscms_entries_revisions r ON (t.data_rev_id=r.old_id AND r.archive IS FALSE);

DROP TABLE data_text;
DROP TABLE data_text_a;



-- --------------------------------------------------------
-- create and convert tags
-- --------------------------------------------------------
CREATE TABLE roscms_entries_tags (
  id bigint(20) unsigned NOT NULL auto_increment,
  rev_id bigint(20) unsigned NOT NULL COMMENT '->entries_revisions(id)',
  user_id bigint(21) NOT NULL COMMENT '->accounts(id); -1=>system',
  name varchar(32) collate utf8_unicode_ci NOT NULL,
  value varchar(128) collate utf8_unicode_ci NOT NULL,
  PRIMARY KEY  (id),
  KEY rev_id (rev_id),
  KEY user_id (user_id),
  KEY name (name)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO roscms_entries_tags
SELECT
  NULL,
  r.id,
  t.tag_usrid,
  n.tn_name,
  v.tv_value
FROM data_tag_a t JOIN data_tag_name_a n ON t.tag_name_id=n.tn_id JOIN data_tag_value_a v ON t.tag_value_id=v.tv_id JOIN roscms_entries_revisions r ON (t.data_rev_id=r.old_id AND r.archive IS TRUE)
UNION
SELECT
  NULL,
  r.id,
  t.tag_usrid,
  n.tn_name,
  v.tv_value
FROM data_tag t JOIN data_tag_name n ON t.tag_name_id=n.tn_id JOIN data_tag_value v ON t.tag_value_id=v.tv_id JOIN roscms_entries_revisions r ON (t.data_rev_id=r.old_id AND r.archive IS FALSE);

DROP TABLE data_tag;
DROP TABLE data_tag_a;

DROP TABLE data_tag_name;
DROP TABLE data_tag_name_a;
DROP TABLE data_tag_value;
DROP TABLE data_tag_value_a;

ALTER TABLE roscms_entries_revisions DROP old_id;



-- --------------------------------------------------------
-- create and convert subsys mappings
-- --------------------------------------------------------
CREATE TABLE roscms_rel_accounts_subsys (
  user_id bigint(20) unsigned NOT NULL COMMENT '->accounts(id)',
  subsys varchar(10) collate utf8_unicode_ci NOT NULL,
  subsys_user_id bigint(20) unsigned NOT NULL COMMENT '->$subsys.$user(id)',
  PRIMARY KEY  (user_id,subsys),
  UNIQUE KEY subsys (subsys,subsys_user_id),
  KEY subsys_user_id (subsys_user_id),
  KEY user_id (user_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO roscms_rel_accounts_subsys
SELECT
  map_roscms_userid,
  map_subsys_name,
  map_subsys_userid
FROM subsys_mappings;

DROP TABLE subsys_mappings;



-- --------------------------------------------------------
-- create and convert timezones
-- --------------------------------------------------------
CREATE TABLE roscms_timezones (
  id bigint(20) unsigned NOT NULL auto_increment,
  name varchar(50) collate utf8_unicode_ci NOT NULL,
  name_short varchar(5) collate utf8_unicode_ci NOT NULL,
  difference char(5) collate utf8_unicode_ci NOT NULL default '+0000',
  decimal_difference decimal(10,2) NOT NULL default '0',
  PRIMARY KEY  (id),
  KEY difference (decimal_difference)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO roscms_timezones
SELECT
  NULL,
  tz_name,
  tz_code,
  tz_value2,
  tz_value
FROM user_timezone
ORDER BY tz_value;

DROP TABLE user_timezone;



-- --------------------------------------------------------
-- create and convert user accounts
-- --------------------------------------------------------
CREATE TABLE roscms_accounts (
  id bigint(20) unsigned NOT NULL auto_increment,
  name varchar(20) collate utf8_unicode_ci NOT NULL,
  password varchar(32) collate utf8_unicode_ci NOT NULL COMMENT 'md5 encoded',
  email varchar(150) collate utf8_unicode_ci NOT NULL,
  lang_id bigint(20) unsigned COMMENT '->languages(id)',
  country_id bigint(20) unsigned COMMENT '->countries(id)',
  timezone_id bigint(20) unsigned COMMENT '->timezones(id)',
  logins int(10) unsigned NOT NULL default '0',
  fullname varchar(100) collate utf8_unicode_ci NOT NULL,
  homepage varchar(150) collate utf8_unicode_ci NOT NULL,
  occupation varchar(50) collate utf8_unicode_ci NOT NULL,
  description varchar(255) collate utf8_unicode_ci NOT NULL,
  match_session tinyint(1) NOT NULL default '1',
  match_browseragent tinyint(1) NOT NULL default '0',
  match_ip tinyint(1) NOT NULL default '0',
  match_session_expire tinyint(1) NOT NULL default '1',
  activation varchar(200) collate utf8_unicode_ci NOT NULL COMMENT 'account / email',
  activation_password varchar(50) collate utf8_unicode_ci NOT NULL COMMENT 'code to activate the new password',
  created datetime NOT NULL,
  modified datetime NOT NULL,
  visible tinyint(1) NOT NULL default '0',
  disabled tinyint(1) NOT NULL default '1',
  PRIMARY KEY  (id),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY email (email),
  KEY `language` (lang_id),
  KEY country (country_id),
  KEY timezone (timezone_id),
  KEY activation_password (activation_password)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO roscms_accounts
SELECT
  u.user_id,
  u.user_name,
  u.user_roscms_password,
  u.user_email,
  l.id,
  c.id,
  t.id,
  u.user_login_counter,
  u.user_fullname,
  u.user_website,
  u.user_occupation,
  u.user_description,
  u.user_setting_multisession,
  u.user_setting_browseragent,
  u.user_setting_ipaddress,
  u.user_setting_timeout,
  CONCAT(u.user_register_activation,u.user_email_activation) AS activation,
  u.user_roscms_getpwd_id,
  u.user_register,
  u.user_timestamp_touch2,
  (u.user_account_hidden = 'no') AS visible,
  (u.user_account_enabled = 'no') AS disabled
FROM users u
LEFT JOIN roscms_languages l ON u.user_language=l.name_short
LEFT JOIN roscms_timezones t ON u.user_timezone=t.name_short
LEFT JOIN roscms_countries c ON u.user_country=c.name_short;

DROP TABLE users;



-- --------------------------------------------------------
-- create and convert forbidden account names (or parts)
-- --------------------------------------------------------
CREATE TABLE roscms_accounts_forbidden (
  `name` varchar(20) collate utf8_unicode_ci NOT NULL,
  PRIMARY KEY  (`name`),
  FULLTEXT KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='consists of a collection of forbidden names or parts';

INSERT INTO roscms_accounts_forbidden
SELECT
  unsafe_name
FROM user_unsafenames;

DROP TABLE user_unsafenames;
DROP TABLE user_unsafepwds;



-- --------------------------------------------------------
-- create and convert account sessions
-- --------------------------------------------------------
CREATE TABLE roscms_accounts_sessions (
  id varchar(32) collate utf8_unicode_ci NOT NULL,
  user_id bigint(20) unsigned NOT NULL COMMENT '->accounts(id)',
  expires datetime default NULL,
  browseragent varchar(255) collate utf8_unicode_ci NOT NULL,
  ip varchar(15) collate utf8_unicode_ci NOT NULL,
  PRIMARY KEY  (id),
  KEY user_id (user_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO roscms_accounts_sessions SELECT * FROM user_sessions;

DROP TABLE user_sessions;



-- --------------------------------------------------------
-- create jobs (e.g. stuff that has to be performed while generating pages)
-- --------------------------------------------------------
CREATE TABLE roscms_jobs (
  id bigint(20) unsigned NOT NULL,
  `action` varchar(32) collate utf8_unicode_ci NOT NULL,
  `data` text collate utf8_unicode_ci NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `action` (`action`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------
ALTER TABLE roscms_access DROP old_id;