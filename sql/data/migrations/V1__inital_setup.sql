CREATE DATABASE IF NOT EXISTS `buildhook`;
GRANT ALL ON `buildhooks`.* TO 'user'@'%';

/* Single line comment */
CREATE TABLE IF NOT EXISTS buildhooks (
    id int unsigned auto_increment primary key,
    buildhook_uid varchar(36) default (UUID()),
    status_id tinyint unsigned DEFAULT 1 NOT NULL,
    user_uid varchar(36) not null,
    site_uid varchar(36) not null,
    org_uid varchar(36) not null,
    label varchar(128) default '',
    env varchar(36) default '',
    created_on datetime not null default current_timestamp,
    updated_on datetime not null default current_timestamp,
    deleted_on datetime
) engine = innodb;

create index buildhooks_deleted_idx on buildhooks (deleted_on);
create index buildhooks_buildhook_uid_idx on buildhooks (buildhook_uid);
create index buildhooks_user_org_deleted_idx on buildhooks (user_uid, org_uid, deleted_on);

CREATE TABLE IF NOT EXISTS status (
    id tinyint unsigned auto_increment primary key,
    alias varchar(128) not null,
    label varchar(128) not null,
    description varchar(512) default '',
    created_on datetime not null default current_timestamp,
    updated_on datetime not null default current_timestamp,
    deleted_on datetime
) engine = innodb;
create unique index status_alias_uidx on status (alias);
INSERT INTO status (alias, label, description) VALUES
    ('processing-buildhook','Processing Buildhook Tests','Audits are being processed'),
    ('success','Success','buildhook Tests completed successfully'),
    ('error','Error','One or more errors occurred during the VR')
;

CREATE TABLE IF NOT EXISTS attempt_success (
    id int unsigned auto_increment primary key,
    ipv4 varchar(36) default '',
    ipv6 varchar(36) default '',
    buildhook_uid varchar(36) not null,
    created_on datetime not null default current_timestamp
) engine = innodb;

CREATE TABLE IF NOT EXISTS buildhook_regeneration_audit (
    id int unsigned auto_increment primary key,
    old_buildhook_id int unsigned not null,
    new_buildhook_id int unsigned not null,
    old_buildhook_uid varchar(36) default (UUID()),
    new_buildhook_uid varchar(36) default (UUID()),
    created_on datetime not null default current_timestamp
) engine = innodb;

CREATE TABLE IF NOT EXISTS attempt_failure (
    id int unsigned auto_increment primary key,
    ipv4 varchar(36) default '',
    ipv6 varchar(36) default '',
    buildhook_uid varchar(256) not null,
    created_on datetime not null default current_timestamp,
    error text not null
) engine = innodb;
