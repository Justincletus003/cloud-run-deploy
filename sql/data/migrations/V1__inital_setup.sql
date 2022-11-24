CREATE DATABASE IF NOT EXISTS `lighthouse`;
GRANT ALL ON `lighthouse`.* TO 'user'@'%';

/* Single line comment */
CREATE TABLE IF NOT EXISTS lighthouses (
    id int unsigned auto_increment primary key,
    session_uid varchar(36) default (UUID()),
    requesting_source_id tinyint unsigned not null,
    requesting_tech_id tinyint unsigned not null,
    status_id tinyint unsigned DEFAULT 1 NOT NULL,
    started_at int not null,
    finished_at int default 0,
    user_uid varchar(36) not null,
    site_uid varchar(36) not null,
    org_uid varchar(36) not null,
    label varchar(128) default '',
    base_url varchar(512) not null,
    result_url varchar(512) default '',
    created_on datetime not null default current_timestamp,
    updated_on datetime not null default current_timestamp,
    deleted_on datetime
) engine = innodb;

create index lighthouses_deleted_idx on lighthouses (deleted_on);
create index lighthouses_session_uid_idx on lighthouses (session_uid);
create index lighthouses_user_org_deleted_idx on lighthouses (user_uid, org_uid, deleted_on);

CREATE TABLE IF NOT EXISTS requesting_source (
    id tinyint unsigned auto_increment primary key,
    alias varchar(128) not null,
    label varchar(128) not null,
    description varchar(512) default '',
    created_on datetime not null default current_timestamp,
    updated_on datetime not null default current_timestamp,
    deleted_on datetime
) engine = innodb;
create unique index requesting_source_alias_uidx on requesting_source (alias);
insert into requesting_source (alias, label, description) values
    ('terminus','Terminus CLI','Terminus CLI'),
    ('autopilot','Pantheon Autopilot Website','Pantheon Autopilot Website'),
    ('curl','CURL','Command Line CURL Command'),
    ('pmu', 'Professional Managed Services', 'Professional Managed Services')
;


CREATE TABLE IF NOT EXISTS requesting_tech (
    id tinyint unsigned auto_increment primary key,
    alias varchar(128) not null,
    label varchar(128) not null,
    description varchar(512) default '',
    created_on datetime not null default current_timestamp,
    updated_on datetime not null default current_timestamp,
    deleted_on datetime
) engine = innodb;
create unique index requesting_tech_alias_uidx on requesting_tech (alias);
INSERT INTO requesting_tech (alias, label, description) VALUES
    ('api-rest','Restful API','Restful API'),
    ('graphql','GraphQL','GraphQL'),
    ('gcp-pubsub','GCP Message Queue','Google PubSub Message Queue'),
    ('aws-sqs','AWS SQS','AWS SQS - Message Queue'),
    ('redis-mq','Redis Message Queue','Redis - Message Queue'),
    ('rabbitmq','RabbitMQ Message Queue','RabbitMQ - Message Queue'),
    ('manual-import', 'Manual Import', 'Manual Import')
;


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
    ('processing-lighthouse','Processing Lighthouse Tests','Audits are being processed'),
    ('success','Success','Lighthouse Tests completed successfully'),
    ('error','Error','One or more errors occurred during the VR')
;

CREATE TABLE IF NOT EXISTS lighthouse_results (
    id int unsigned auto_increment primary key,
    lighthouse_id int unsigned not null,
    message text not null,
    results json not null,
    created_on datetime not null default current_timestamp
) engine = innodb;
create unique index lighthouse_results_lighthouse_id_uidx on lighthouse_results (lighthouse_id);
