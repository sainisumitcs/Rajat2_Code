create table al_pending_subscriber
( 
 al_id       varchar(20)
, serviceid   varchar(30)
, subscriber  varchar(20) not null
, campaign_id varchar(50)
, message     varchar(5000) not null
, primary key (subscriber, message)
);
