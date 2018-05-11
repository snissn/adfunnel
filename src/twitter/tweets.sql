
  drop table if exists adfunnel.tweets;
  
  
  CREATE TABLE adfunnel.tweets (
      id bigint,
      token_id bigint,
      type character varying(255),
      username character varying(255),
      display_name character varying(255),
      youtube_id character varying(255),
      facebook_account_id bigint,
      text text,
      status text,
      is_retweet boolean,
      link text,
      profile_image text,
      hashtags character varying(255)[],
      url text,
      urls text[],
      media text[],
      attachment_title text,
      attachment_description text,
      attachment_url text,
      image_url text,
      image_height integer,
      image_width integer,
      like_count integer,
      comment_count integer,
      shares_count integer,
      followers_count integer,
      friends_count integer,
      plays_count integer,
      favorite_count integer,
      retweet_count integer,
      created timestamp without time zone DEFAULT now(),
      modified timestamp without time zone DEFAULT now(),
      web_url text,
      signup_form_id integer,
      chunks tsvector,
      reach integer,
      zipcodes integer[],
      facebook_username_id integer,
      url_id bigint,
      organization_name text
  );


  ALTER TABLE adfunnel.tweets ADD CONSTRAINT tweets_type CHECK (type ='tweet');

  CREATE INDEX tweets_chunks_idx ON adfunnel.tweets USING gin (chunks);
  CREATE INDEX tweets_created_idx ON adfunnel.tweets USING btree (created);
  CREATE INDEX tweets_date_idx ON adfunnel.tweets USING btree (date(created));
  CREATE INDEX tweets_facebook_username_id_idx ON adfunnel.tweets USING btree (facebook_username_id);
  CREATE INDEX tweets_hashtags_idx ON adfunnel.tweets USING gin (hashtags);
  CREATE INDEX tweets_hashtags_idx1 ON adfunnel.tweets USING btree (hashtags);
  CREATE INDEX tweets_token_id_created_idx ON adfunnel.tweets USING btree (token_id, created);
  CREATE INDEX tweets_token_ids_idx ON adfunnel.tweets USING gin (token_ids);
  CREATE INDEX tweets_to_tsvector_idx ON adfunnel.tweets USING gin (to_tsvector('english'::regconfig, organization_name));
  CREATE INDEX tweets_zipcodes_idx ON adfunnel.tweets USING gin (zipcodes);
  
CREATE UNIQUE INDEX tweets_id_token_id_idx ON adfunnel.tweets USING btree (id, token_id);
CREATE UNIQUE INDEX tweets_token_id_id_idx ON adfunnel.tweets USING btree (token_id, id);
CREATE OR REPLACE FUNCTION tweets_insert() RETURNS trigger AS $$
      DECLARE full_text text;
      BEGIN
          full_text := COALESCE(NEW.text, ' '::text) || ' '::text || COALESCE(NEW.status, ' '::text) || ' '::text || COALESCE(NEW.attachment_title, ' '::text) || ' '::text || COALESCE(NEW.attachment_description, ' '::text) || ' '::text || COALESCE((select string_agg(x, ' ') from (select '/' || lower(unnest(NEW.hashtags)) as x) y), (' '::text));
          NEW.chunks := to_tsvector('english'::regconfig, full_text);
          RETURN NEW;
      END;
  $$ LANGUAGE plpgsql;

  CREATE TRIGGER tweets_insert BEFORE INSERT ON adfunnel.tweets FOR EACH ROW EXECUTE PROCEDURE public.tweets_insert();

  drop table if exists adfunnel.tweets_first ;
  CREATE TABLE adfunnel.tweets_first (LIKE adfunnel.tweets INCLUDING ALL);
  ALTER TABLE adfunnel.tweets_first ADD CONSTRAINT tweets_first_constraint CHECK (date(created)< '2016-06-01');
  ALTER TABLE adfunnel.tweets_first INHERIT adfunnel.tweets;
  

    drop table if exists adfunnel.tweets_20160601 ;
    CREATE TABLE adfunnel.tweets_20160601 (LIKE adfunnel.tweets INCLUDING ALL);
    ALTER TABLE adfunnel.tweets_20160601 ADD CONSTRAINT tweets_20160601_constraint CHECK (date(created)>= '2016-06-01' AND date(created)<= '2016-06-30') ;
    ALTER TABLE adfunnel.tweets_20160601 INHERIT adfunnel.tweets;
    

    drop table if exists adfunnel.tweets_20160701 ;
    CREATE TABLE adfunnel.tweets_20160701 (LIKE adfunnel.tweets INCLUDING ALL);
    ALTER TABLE adfunnel.tweets_20160701 ADD CONSTRAINT tweets_20160701_constraint CHECK (date(created)>= '2016-07-01' AND date(created)<= '2016-07-31') ;
    ALTER TABLE adfunnel.tweets_20160701 INHERIT adfunnel.tweets;
    

    drop table if exists adfunnel.tweets_20160801 ;
    CREATE TABLE adfunnel.tweets_20160801 (LIKE adfunnel.tweets INCLUDING ALL);
    ALTER TABLE adfunnel.tweets_20160801 ADD CONSTRAINT tweets_20160801_constraint CHECK (date(created)>= '2016-08-01' AND date(created)<= '2016-08-31') ;
    ALTER TABLE adfunnel.tweets_20160801 INHERIT adfunnel.tweets;
    

    drop table if exists adfunnel.tweets_20160901 ;
    CREATE TABLE adfunnel.tweets_20160901 (LIKE adfunnel.tweets INCLUDING ALL);
    ALTER TABLE adfunnel.tweets_20160901 ADD CONSTRAINT tweets_20160901_constraint CHECK (date(created)>= '2016-09-01' AND date(created)<= '2016-09-30') ;
    ALTER TABLE adfunnel.tweets_20160901 INHERIT adfunnel.tweets;
    

    drop table if exists adfunnel.tweets_20161001 ;
    CREATE TABLE adfunnel.tweets_20161001 (LIKE adfunnel.tweets INCLUDING ALL);
    ALTER TABLE adfunnel.tweets_20161001 ADD CONSTRAINT tweets_20161001_constraint CHECK (date(created)>= '2016-10-01' AND date(created)<= '2016-10-31') ;
    ALTER TABLE adfunnel.tweets_20161001 INHERIT adfunnel.tweets;
    

    drop table if exists adfunnel.tweets_20161101 ;
    CREATE TABLE adfunnel.tweets_20161101 (LIKE adfunnel.tweets INCLUDING ALL);
    ALTER TABLE adfunnel.tweets_20161101 ADD CONSTRAINT tweets_20161101_constraint CHECK (date(created)>= '2016-11-01' AND date(created)<= '2016-11-30') ;
    ALTER TABLE adfunnel.tweets_20161101 INHERIT adfunnel.tweets;
    

    drop table if exists adfunnel.tweets_20161201 ;
    CREATE TABLE adfunnel.tweets_20161201 (LIKE adfunnel.tweets INCLUDING ALL);
    ALTER TABLE adfunnel.tweets_20161201 ADD CONSTRAINT tweets_20161201_constraint CHECK (date(created)>= '2016-12-01' AND date(created)<= '2016-12-31') ;
    ALTER TABLE adfunnel.tweets_20161201 INHERIT adfunnel.tweets;
    

    drop table if exists adfunnel.tweets_20170101 ;
    CREATE TABLE adfunnel.tweets_20170101 (LIKE adfunnel.tweets INCLUDING ALL);
    ALTER TABLE adfunnel.tweets_20170101 ADD CONSTRAINT tweets_20170101_constraint CHECK (date(created)>= '2017-01-01' AND date(created)<= '2017-01-31') ;
    ALTER TABLE adfunnel.tweets_20170101 INHERIT adfunnel.tweets;
    

    drop table if exists adfunnel.tweets_20170201 ;
    CREATE TABLE adfunnel.tweets_20170201 (LIKE adfunnel.tweets INCLUDING ALL);
    ALTER TABLE adfunnel.tweets_20170201 ADD CONSTRAINT tweets_20170201_constraint CHECK (date(created)>= '2017-02-01' AND date(created)<= '2017-02-28') ;
    ALTER TABLE adfunnel.tweets_20170201 INHERIT adfunnel.tweets;
    

    drop table if exists adfunnel.tweets_20170301 ;
    CREATE TABLE adfunnel.tweets_20170301 (LIKE adfunnel.tweets INCLUDING ALL);
    ALTER TABLE adfunnel.tweets_20170301 ADD CONSTRAINT tweets_20170301_constraint CHECK (date(created)>= '2017-03-01' AND date(created)<= '2017-03-31') ;
    ALTER TABLE adfunnel.tweets_20170301 INHERIT adfunnel.tweets;
    

    drop table if exists adfunnel.tweets_20170401 ;
    CREATE TABLE adfunnel.tweets_20170401 (LIKE adfunnel.tweets INCLUDING ALL);
    ALTER TABLE adfunnel.tweets_20170401 ADD CONSTRAINT tweets_20170401_constraint CHECK (date(created)>= '2017-04-01' AND date(created)<= '2017-04-30') ;
    ALTER TABLE adfunnel.tweets_20170401 INHERIT adfunnel.tweets;
    

    drop table if exists adfunnel.tweets_20170501 ;
    CREATE TABLE adfunnel.tweets_20170501 (LIKE adfunnel.tweets INCLUDING ALL);
    ALTER TABLE adfunnel.tweets_20170501 ADD CONSTRAINT tweets_20170501_constraint CHECK (date(created)>= '2017-05-01' AND date(created)<= '2017-05-31') ;
    ALTER TABLE adfunnel.tweets_20170501 INHERIT adfunnel.tweets;
    

    drop table if exists adfunnel.tweets_20170601 ;
    CREATE TABLE adfunnel.tweets_20170601 (LIKE adfunnel.tweets INCLUDING ALL);
    ALTER TABLE adfunnel.tweets_20170601 ADD CONSTRAINT tweets_20170601_constraint CHECK (date(created)>= '2017-06-01' AND date(created)<= '2017-06-30') ;
    ALTER TABLE adfunnel.tweets_20170601 INHERIT adfunnel.tweets;
    

    drop table if exists adfunnel.tweets_20170701 ;
    CREATE TABLE adfunnel.tweets_20170701 (LIKE adfunnel.tweets INCLUDING ALL);
    ALTER TABLE adfunnel.tweets_20170701 ADD CONSTRAINT tweets_20170701_constraint CHECK (date(created)>= '2017-07-01' AND date(created)<= '2017-07-31') ;
    ALTER TABLE adfunnel.tweets_20170701 INHERIT adfunnel.tweets;
    

    drop table if exists adfunnel.tweets_20170801 ;
    CREATE TABLE adfunnel.tweets_20170801 (LIKE adfunnel.tweets INCLUDING ALL);
    ALTER TABLE adfunnel.tweets_20170801 ADD CONSTRAINT tweets_20170801_constraint CHECK (date(created)>= '2017-08-01' AND date(created)<= '2017-08-31') ;
    ALTER TABLE adfunnel.tweets_20170801 INHERIT adfunnel.tweets;
    

    drop table if exists adfunnel.tweets_20170901 ;
    CREATE TABLE adfunnel.tweets_20170901 (LIKE adfunnel.tweets INCLUDING ALL);
    ALTER TABLE adfunnel.tweets_20170901 ADD CONSTRAINT tweets_20170901_constraint CHECK (date(created)>= '2017-09-01' AND date(created)<= '2017-09-30') ;
    ALTER TABLE adfunnel.tweets_20170901 INHERIT adfunnel.tweets;
    

    drop table if exists adfunnel.tweets_20171001 ;
    CREATE TABLE adfunnel.tweets_20171001 (LIKE adfunnel.tweets INCLUDING ALL);
    ALTER TABLE adfunnel.tweets_20171001 ADD CONSTRAINT tweets_20171001_constraint CHECK (date(created)>= '2017-10-01' AND date(created)<= '2017-10-31') ;
    ALTER TABLE adfunnel.tweets_20171001 INHERIT adfunnel.tweets;
    

    drop table if exists adfunnel.tweets_20171101 ;
    CREATE TABLE adfunnel.tweets_20171101 (LIKE adfunnel.tweets INCLUDING ALL);
    ALTER TABLE adfunnel.tweets_20171101 ADD CONSTRAINT tweets_20171101_constraint CHECK (date(created)>= '2017-11-01' AND date(created)<= '2017-11-30') ;
    ALTER TABLE adfunnel.tweets_20171101 INHERIT adfunnel.tweets;
    

    drop table if exists adfunnel.tweets_20171201 ;
    CREATE TABLE adfunnel.tweets_20171201 (LIKE adfunnel.tweets INCLUDING ALL);
    ALTER TABLE adfunnel.tweets_20171201 ADD CONSTRAINT tweets_20171201_constraint CHECK (date(created)>= '2017-12-01' AND date(created)<= '2017-12-31') ;
    ALTER TABLE adfunnel.tweets_20171201 INHERIT adfunnel.tweets;
    

    drop table if exists adfunnel.tweets_20180101 ;
    CREATE TABLE adfunnel.tweets_20180101 (LIKE adfunnel.tweets INCLUDING ALL);
    ALTER TABLE adfunnel.tweets_20180101 ADD CONSTRAINT tweets_20180101_constraint CHECK (date(created)>= '2018-01-01' AND date(created)<= '2018-01-31') ;
    ALTER TABLE adfunnel.tweets_20180101 INHERIT adfunnel.tweets;
    

    drop table if exists adfunnel.tweets_20180201 ;
    CREATE TABLE adfunnel.tweets_20180201 (LIKE adfunnel.tweets INCLUDING ALL);
    ALTER TABLE adfunnel.tweets_20180201 ADD CONSTRAINT tweets_20180201_constraint CHECK (date(created)>= '2018-02-01' AND date(created)<= '2018-02-28') ;
    ALTER TABLE adfunnel.tweets_20180201 INHERIT adfunnel.tweets;
    

    drop table if exists adfunnel.tweets_20180301 ;
    CREATE TABLE adfunnel.tweets_20180301 (LIKE adfunnel.tweets INCLUDING ALL);
    ALTER TABLE adfunnel.tweets_20180301 ADD CONSTRAINT tweets_20180301_constraint CHECK (date(created)>= '2018-03-01' AND date(created)<= '2018-03-31') ;
    ALTER TABLE adfunnel.tweets_20180301 INHERIT adfunnel.tweets;
    

    drop table if exists adfunnel.tweets_20180401 ;
    CREATE TABLE adfunnel.tweets_20180401 (LIKE adfunnel.tweets INCLUDING ALL);
    ALTER TABLE adfunnel.tweets_20180401 ADD CONSTRAINT tweets_20180401_constraint CHECK (date(created)>= '2018-04-01' AND date(created)<= '2018-04-30') ;
    ALTER TABLE adfunnel.tweets_20180401 INHERIT adfunnel.tweets;
    

    drop table if exists adfunnel.tweets_20180501 ;
    CREATE TABLE adfunnel.tweets_20180501 (LIKE adfunnel.tweets INCLUDING ALL);
    ALTER TABLE adfunnel.tweets_20180501 ADD CONSTRAINT tweets_20180501_constraint CHECK (date(created)>= '2018-05-01' AND date(created)<= '2018-05-31') ;
    ALTER TABLE adfunnel.tweets_20180501 INHERIT adfunnel.tweets;
    

    drop table if exists adfunnel.tweets_20180601 ;
    CREATE TABLE adfunnel.tweets_20180601 (LIKE adfunnel.tweets INCLUDING ALL);
    ALTER TABLE adfunnel.tweets_20180601 ADD CONSTRAINT tweets_20180601_constraint CHECK (date(created)>= '2018-06-01' AND date(created)<= '2018-06-30') ;
    ALTER TABLE adfunnel.tweets_20180601 INHERIT adfunnel.tweets;
    

    drop table if exists adfunnel.tweets_20180701 ;
    CREATE TABLE adfunnel.tweets_20180701 (LIKE adfunnel.tweets INCLUDING ALL);
    ALTER TABLE adfunnel.tweets_20180701 ADD CONSTRAINT tweets_20180701_constraint CHECK (date(created)>= '2018-07-01' AND date(created)<= '2018-07-31') ;
    ALTER TABLE adfunnel.tweets_20180701 INHERIT adfunnel.tweets;
    

    drop table if exists adfunnel.tweets_20180801 ;
    CREATE TABLE adfunnel.tweets_20180801 (LIKE adfunnel.tweets INCLUDING ALL);
    ALTER TABLE adfunnel.tweets_20180801 ADD CONSTRAINT tweets_20180801_constraint CHECK (date(created)>= '2018-08-01' AND date(created)<= '2018-08-31') ;
    ALTER TABLE adfunnel.tweets_20180801 INHERIT adfunnel.tweets;
    

    drop table if exists adfunnel.tweets_20180901 ;
    CREATE TABLE adfunnel.tweets_20180901 (LIKE adfunnel.tweets INCLUDING ALL);
    ALTER TABLE adfunnel.tweets_20180901 ADD CONSTRAINT tweets_20180901_constraint CHECK (date(created)>= '2018-09-01' AND date(created)<= '2018-09-30') ;
    ALTER TABLE adfunnel.tweets_20180901 INHERIT adfunnel.tweets;
    

    drop table if exists adfunnel.tweets_20181001 ;
    CREATE TABLE adfunnel.tweets_20181001 (LIKE adfunnel.tweets INCLUDING ALL);
    ALTER TABLE adfunnel.tweets_20181001 ADD CONSTRAINT tweets_20181001_constraint CHECK (date(created)>= '2018-10-01' AND date(created)<= '2018-10-31') ;
    ALTER TABLE adfunnel.tweets_20181001 INHERIT adfunnel.tweets;
    

    drop table if exists adfunnel.tweets_20181101 ;
    CREATE TABLE adfunnel.tweets_20181101 (LIKE adfunnel.tweets INCLUDING ALL);
    ALTER TABLE adfunnel.tweets_20181101 ADD CONSTRAINT tweets_20181101_constraint CHECK (date(created)>= '2018-11-01' AND date(created)<= '2018-11-30') ;
    ALTER TABLE adfunnel.tweets_20181101 INHERIT adfunnel.tweets;
    

    drop table if exists adfunnel.tweets_20181201 ;
    CREATE TABLE adfunnel.tweets_20181201 (LIKE adfunnel.tweets INCLUDING ALL);
    ALTER TABLE adfunnel.tweets_20181201 ADD CONSTRAINT tweets_20181201_constraint CHECK (date(created)>= '2018-12-01' AND date(created)<= '2018-12-31') ;
    ALTER TABLE adfunnel.tweets_20181201 INHERIT adfunnel.tweets;
    

    drop table if exists adfunnel.tweets_20190101 ;
    CREATE TABLE adfunnel.tweets_20190101 (LIKE adfunnel.tweets INCLUDING ALL);
    ALTER TABLE adfunnel.tweets_20190101 ADD CONSTRAINT tweets_20190101_constraint CHECK (date(created)>= '2019-01-01' AND date(created)<= '2019-01-31') ;
    ALTER TABLE adfunnel.tweets_20190101 INHERIT adfunnel.tweets;
    

    drop table if exists adfunnel.tweets_20190201 ;
    CREATE TABLE adfunnel.tweets_20190201 (LIKE adfunnel.tweets INCLUDING ALL);
    ALTER TABLE adfunnel.tweets_20190201 ADD CONSTRAINT tweets_20190201_constraint CHECK (date(created)>= '2019-02-01' AND date(created)<= '2019-02-28') ;
    ALTER TABLE adfunnel.tweets_20190201 INHERIT adfunnel.tweets;
    

    drop table if exists adfunnel.tweets_20190301 ;
    CREATE TABLE adfunnel.tweets_20190301 (LIKE adfunnel.tweets INCLUDING ALL);
    ALTER TABLE adfunnel.tweets_20190301 ADD CONSTRAINT tweets_20190301_constraint CHECK (date(created)>= '2019-03-01' AND date(created)<= '2019-03-31') ;
    ALTER TABLE adfunnel.tweets_20190301 INHERIT adfunnel.tweets;
    

    drop table if exists adfunnel.tweets_20190401 ;
    CREATE TABLE adfunnel.tweets_20190401 (LIKE adfunnel.tweets INCLUDING ALL);
    ALTER TABLE adfunnel.tweets_20190401 ADD CONSTRAINT tweets_20190401_constraint CHECK (date(created)>= '2019-04-01' AND date(created)<= '2019-04-30') ;
    ALTER TABLE adfunnel.tweets_20190401 INHERIT adfunnel.tweets;
    

    drop table if exists adfunnel.tweets_20190501 ;
    CREATE TABLE adfunnel.tweets_20190501 (LIKE adfunnel.tweets INCLUDING ALL);
    ALTER TABLE adfunnel.tweets_20190501 ADD CONSTRAINT tweets_20190501_constraint CHECK (date(created)>= '2019-05-01' AND date(created)<= '2019-05-31') ;
    ALTER TABLE adfunnel.tweets_20190501 INHERIT adfunnel.tweets;
    

    drop table if exists adfunnel.tweets_20190601 ;
    CREATE TABLE adfunnel.tweets_20190601 (LIKE adfunnel.tweets INCLUDING ALL);
    ALTER TABLE adfunnel.tweets_20190601 ADD CONSTRAINT tweets_20190601_constraint CHECK (date(created)>= '2019-06-01' AND date(created)<= '2019-06-30') ;
    ALTER TABLE adfunnel.tweets_20190601 INHERIT adfunnel.tweets;
    

    drop table if exists adfunnel.tweets_20190701 ;
    CREATE TABLE adfunnel.tweets_20190701 (LIKE adfunnel.tweets INCLUDING ALL);
    ALTER TABLE adfunnel.tweets_20190701 ADD CONSTRAINT tweets_20190701_constraint CHECK (date(created)>= '2019-07-01' AND date(created)<= '2019-07-31') ;
    ALTER TABLE adfunnel.tweets_20190701 INHERIT adfunnel.tweets;
    

    drop table if exists adfunnel.tweets_20190801 ;
    CREATE TABLE adfunnel.tweets_20190801 (LIKE adfunnel.tweets INCLUDING ALL);
    ALTER TABLE adfunnel.tweets_20190801 ADD CONSTRAINT tweets_20190801_constraint CHECK (date(created)>= '2019-08-01' AND date(created)<= '2019-08-31') ;
    ALTER TABLE adfunnel.tweets_20190801 INHERIT adfunnel.tweets;
    

    drop table if exists adfunnel.tweets_20190901 ;
    CREATE TABLE adfunnel.tweets_20190901 (LIKE adfunnel.tweets INCLUDING ALL);
    ALTER TABLE adfunnel.tweets_20190901 ADD CONSTRAINT tweets_20190901_constraint CHECK (date(created)>= '2019-09-01' AND date(created)<= '2019-09-30') ;
    ALTER TABLE adfunnel.tweets_20190901 INHERIT adfunnel.tweets;
    

    drop table if exists adfunnel.tweets_20191001 ;
    CREATE TABLE adfunnel.tweets_20191001 (LIKE adfunnel.tweets INCLUDING ALL);
    ALTER TABLE adfunnel.tweets_20191001 ADD CONSTRAINT tweets_20191001_constraint CHECK (date(created)>= '2019-10-01' AND date(created)<= '2019-10-31') ;
    ALTER TABLE adfunnel.tweets_20191001 INHERIT adfunnel.tweets;
    

    drop table if exists adfunnel.tweets_20191101 ;
    CREATE TABLE adfunnel.tweets_20191101 (LIKE adfunnel.tweets INCLUDING ALL);
    ALTER TABLE adfunnel.tweets_20191101 ADD CONSTRAINT tweets_20191101_constraint CHECK (date(created)>= '2019-11-01' AND date(created)<= '2019-11-30') ;
    ALTER TABLE adfunnel.tweets_20191101 INHERIT adfunnel.tweets;
    

    drop table if exists adfunnel.tweets_20191201 ;
    CREATE TABLE adfunnel.tweets_20191201 (LIKE adfunnel.tweets INCLUDING ALL);
    ALTER TABLE adfunnel.tweets_20191201 ADD CONSTRAINT tweets_20191201_constraint CHECK (date(created)>= '2019-12-01' AND date(created)<= '2019-12-31') ;
    ALTER TABLE adfunnel.tweets_20191201 INHERIT adfunnel.tweets;
    

    drop table if exists adfunnel.tweets_20200101 ;
    CREATE TABLE adfunnel.tweets_20200101 (LIKE adfunnel.tweets INCLUDING ALL);
    ALTER TABLE adfunnel.tweets_20200101 ADD CONSTRAINT tweets_20200101_constraint CHECK (date(created)>= '2020-01-01' AND date(created)<= '2020-01-31') ;
    ALTER TABLE adfunnel.tweets_20200101 INHERIT adfunnel.tweets;
    

    drop table if exists adfunnel.tweets_20200201 ;
    CREATE TABLE adfunnel.tweets_20200201 (LIKE adfunnel.tweets INCLUDING ALL);
    ALTER TABLE adfunnel.tweets_20200201 ADD CONSTRAINT tweets_20200201_constraint CHECK (date(created)>= '2020-02-01' AND date(created)<= '2020-02-29') ;
    ALTER TABLE adfunnel.tweets_20200201 INHERIT adfunnel.tweets;
    

    drop table if exists adfunnel.tweets_20200301 ;
    CREATE TABLE adfunnel.tweets_20200301 (LIKE adfunnel.tweets INCLUDING ALL);
    ALTER TABLE adfunnel.tweets_20200301 ADD CONSTRAINT tweets_20200301_constraint CHECK (date(created)>= '2020-03-01' AND date(created)<= '2020-03-31') ;
    ALTER TABLE adfunnel.tweets_20200301 INHERIT adfunnel.tweets;
    

    drop table if exists adfunnel.tweets_20200401 ;
    CREATE TABLE adfunnel.tweets_20200401 (LIKE adfunnel.tweets INCLUDING ALL);
    ALTER TABLE adfunnel.tweets_20200401 ADD CONSTRAINT tweets_20200401_constraint CHECK (date(created)>= '2020-04-01' AND date(created)<= '2020-04-30') ;
    ALTER TABLE adfunnel.tweets_20200401 INHERIT adfunnel.tweets;
    

    drop table if exists adfunnel.tweets_20200501 ;
    CREATE TABLE adfunnel.tweets_20200501 (LIKE adfunnel.tweets INCLUDING ALL);
    ALTER TABLE adfunnel.tweets_20200501 ADD CONSTRAINT tweets_20200501_constraint CHECK (date(created)>= '2020-05-01' AND date(created)<= '2020-05-31') ;
    ALTER TABLE adfunnel.tweets_20200501 INHERIT adfunnel.tweets;
    

  CREATE OR REPLACE FUNCTION tweets_insert_function()
  RETURNS TRIGGER AS $$
  BEGIN

      IF ( date(NEW.created) < DATE '2016-06-01' ) THEN
          INSERT INTO adfunnel.tweets_first VALUES (NEW.*) on conflict (id, token_id) do update set (username, attachment_url, signup_form_id, text, hashtags, profile_image, web_url, chunks,  facebook_username_id, favorite_count, zipcodes, display_name, media, image_width, attachment_title, followers_count, image_height, is_retweet, retweet_count, type, token_ids, status, facebook_account_id, friends_count, comment_count, reach, token_id, plays_count, link, attachment_description, shares_count, url, like_count, image_url, urls, youtube_id, url_id, modified)   = ( EXCLUDED.username, EXCLUDED.attachment_url, EXCLUDED.signup_form_id, EXCLUDED.text, EXCLUDED.hashtags, EXCLUDED.profile_image, EXCLUDED.web_url, EXCLUDED.chunks,  EXCLUDED.facebook_username_id, EXCLUDED.favorite_count, EXCLUDED.zipcodes, EXCLUDED.display_name, EXCLUDED.media, EXCLUDED.image_width, EXCLUDED.attachment_title, EXCLUDED.followers_count, EXCLUDED.image_height, EXCLUDED.is_retweet, EXCLUDED.retweet_count, EXCLUDED.type, EXCLUDED.token_ids, EXCLUDED.status, EXCLUDED.facebook_account_id, EXCLUDED.friends_count, EXCLUDED.comment_count, EXCLUDED.reach, EXCLUDED.token_id, EXCLUDED.plays_count, EXCLUDED.link, EXCLUDED.attachment_description, EXCLUDED.shares_count, EXCLUDED.url, EXCLUDED.like_count, EXCLUDED.image_url, EXCLUDED.urls, EXCLUDED.youtube_id, EXCLUDED.url_id, NOW());
  
ELSEIF (date(NEW.created) >= DATE '2016-06-01' AND date(NEW.created) <= DATE '2016-06-30' ) THEN
          INSERT INTO adfunnel.tweets_20160601 VALUES (NEW.*) on conflict (id, token_id) do update set (username, attachment_url, signup_form_id, text, hashtags, profile_image, web_url, chunks,  facebook_username_id, favorite_count, zipcodes, display_name, media, image_width, attachment_title, followers_count, image_height, is_retweet, retweet_count, type, token_ids, status, facebook_account_id, friends_count, comment_count, reach, token_id, plays_count, link, attachment_description, shares_count, url, like_count, image_url, urls, youtube_id, url_id, modified)   = ( EXCLUDED.username, EXCLUDED.attachment_url, EXCLUDED.signup_form_id, EXCLUDED.text, EXCLUDED.hashtags, EXCLUDED.profile_image, EXCLUDED.web_url, EXCLUDED.chunks,  EXCLUDED.facebook_username_id, EXCLUDED.favorite_count, EXCLUDED.zipcodes, EXCLUDED.display_name, EXCLUDED.media, EXCLUDED.image_width, EXCLUDED.attachment_title, EXCLUDED.followers_count, EXCLUDED.image_height, EXCLUDED.is_retweet, EXCLUDED.retweet_count, EXCLUDED.type, EXCLUDED.token_ids, EXCLUDED.status, EXCLUDED.facebook_account_id, EXCLUDED.friends_count, EXCLUDED.comment_count, EXCLUDED.reach, EXCLUDED.token_id, EXCLUDED.plays_count, EXCLUDED.link, EXCLUDED.attachment_description, EXCLUDED.shares_count, EXCLUDED.url, EXCLUDED.like_count, EXCLUDED.image_url, EXCLUDED.urls, EXCLUDED.youtube_id, EXCLUDED.url_id, NOW());
ELSEIF (date(NEW.created) >= DATE '2016-07-01' AND date(NEW.created) <= DATE '2016-07-31' ) THEN
          INSERT INTO adfunnel.tweets_20160701 VALUES (NEW.*) on conflict (id, token_id) do update set (username, attachment_url, signup_form_id, text, hashtags, profile_image, web_url, chunks,  facebook_username_id, favorite_count, zipcodes, display_name, media, image_width, attachment_title, followers_count, image_height, is_retweet, retweet_count, type, token_ids, status, facebook_account_id, friends_count, comment_count, reach, token_id, plays_count, link, attachment_description, shares_count, url, like_count, image_url, urls, youtube_id, url_id, modified)   = ( EXCLUDED.username, EXCLUDED.attachment_url, EXCLUDED.signup_form_id, EXCLUDED.text, EXCLUDED.hashtags, EXCLUDED.profile_image, EXCLUDED.web_url, EXCLUDED.chunks,  EXCLUDED.facebook_username_id, EXCLUDED.favorite_count, EXCLUDED.zipcodes, EXCLUDED.display_name, EXCLUDED.media, EXCLUDED.image_width, EXCLUDED.attachment_title, EXCLUDED.followers_count, EXCLUDED.image_height, EXCLUDED.is_retweet, EXCLUDED.retweet_count, EXCLUDED.type, EXCLUDED.token_ids, EXCLUDED.status, EXCLUDED.facebook_account_id, EXCLUDED.friends_count, EXCLUDED.comment_count, EXCLUDED.reach, EXCLUDED.token_id, EXCLUDED.plays_count, EXCLUDED.link, EXCLUDED.attachment_description, EXCLUDED.shares_count, EXCLUDED.url, EXCLUDED.like_count, EXCLUDED.image_url, EXCLUDED.urls, EXCLUDED.youtube_id, EXCLUDED.url_id, NOW());
ELSEIF (date(NEW.created) >= DATE '2016-08-01' AND date(NEW.created) <= DATE '2016-08-31' ) THEN
          INSERT INTO adfunnel.tweets_20160801 VALUES (NEW.*) on conflict (id, token_id) do update set (username, attachment_url, signup_form_id, text, hashtags, profile_image, web_url, chunks,  facebook_username_id, favorite_count, zipcodes, display_name, media, image_width, attachment_title, followers_count, image_height, is_retweet, retweet_count, type, token_ids, status, facebook_account_id, friends_count, comment_count, reach, token_id, plays_count, link, attachment_description, shares_count, url, like_count, image_url, urls, youtube_id, url_id, modified)   = ( EXCLUDED.username, EXCLUDED.attachment_url, EXCLUDED.signup_form_id, EXCLUDED.text, EXCLUDED.hashtags, EXCLUDED.profile_image, EXCLUDED.web_url, EXCLUDED.chunks,  EXCLUDED.facebook_username_id, EXCLUDED.favorite_count, EXCLUDED.zipcodes, EXCLUDED.display_name, EXCLUDED.media, EXCLUDED.image_width, EXCLUDED.attachment_title, EXCLUDED.followers_count, EXCLUDED.image_height, EXCLUDED.is_retweet, EXCLUDED.retweet_count, EXCLUDED.type, EXCLUDED.token_ids, EXCLUDED.status, EXCLUDED.facebook_account_id, EXCLUDED.friends_count, EXCLUDED.comment_count, EXCLUDED.reach, EXCLUDED.token_id, EXCLUDED.plays_count, EXCLUDED.link, EXCLUDED.attachment_description, EXCLUDED.shares_count, EXCLUDED.url, EXCLUDED.like_count, EXCLUDED.image_url, EXCLUDED.urls, EXCLUDED.youtube_id, EXCLUDED.url_id, NOW());
ELSEIF (date(NEW.created) >= DATE '2016-09-01' AND date(NEW.created) <= DATE '2016-09-30' ) THEN
          INSERT INTO adfunnel.tweets_20160901 VALUES (NEW.*) on conflict (id, token_id) do update set (username, attachment_url, signup_form_id, text, hashtags, profile_image, web_url, chunks,  facebook_username_id, favorite_count, zipcodes, display_name, media, image_width, attachment_title, followers_count, image_height, is_retweet, retweet_count, type, token_ids, status, facebook_account_id, friends_count, comment_count, reach, token_id, plays_count, link, attachment_description, shares_count, url, like_count, image_url, urls, youtube_id, url_id, modified)   = ( EXCLUDED.username, EXCLUDED.attachment_url, EXCLUDED.signup_form_id, EXCLUDED.text, EXCLUDED.hashtags, EXCLUDED.profile_image, EXCLUDED.web_url, EXCLUDED.chunks,  EXCLUDED.facebook_username_id, EXCLUDED.favorite_count, EXCLUDED.zipcodes, EXCLUDED.display_name, EXCLUDED.media, EXCLUDED.image_width, EXCLUDED.attachment_title, EXCLUDED.followers_count, EXCLUDED.image_height, EXCLUDED.is_retweet, EXCLUDED.retweet_count, EXCLUDED.type, EXCLUDED.token_ids, EXCLUDED.status, EXCLUDED.facebook_account_id, EXCLUDED.friends_count, EXCLUDED.comment_count, EXCLUDED.reach, EXCLUDED.token_id, EXCLUDED.plays_count, EXCLUDED.link, EXCLUDED.attachment_description, EXCLUDED.shares_count, EXCLUDED.url, EXCLUDED.like_count, EXCLUDED.image_url, EXCLUDED.urls, EXCLUDED.youtube_id, EXCLUDED.url_id, NOW());
ELSEIF (date(NEW.created) >= DATE '2016-10-01' AND date(NEW.created) <= DATE '2016-10-31' ) THEN
          INSERT INTO adfunnel.tweets_20161001 VALUES (NEW.*) on conflict (id, token_id) do update set (username, attachment_url, signup_form_id, text, hashtags, profile_image, web_url, chunks,  facebook_username_id, favorite_count, zipcodes, display_name, media, image_width, attachment_title, followers_count, image_height, is_retweet, retweet_count, type, token_ids, status, facebook_account_id, friends_count, comment_count, reach, token_id, plays_count, link, attachment_description, shares_count, url, like_count, image_url, urls, youtube_id, url_id, modified)   = ( EXCLUDED.username, EXCLUDED.attachment_url, EXCLUDED.signup_form_id, EXCLUDED.text, EXCLUDED.hashtags, EXCLUDED.profile_image, EXCLUDED.web_url, EXCLUDED.chunks,  EXCLUDED.facebook_username_id, EXCLUDED.favorite_count, EXCLUDED.zipcodes, EXCLUDED.display_name, EXCLUDED.media, EXCLUDED.image_width, EXCLUDED.attachment_title, EXCLUDED.followers_count, EXCLUDED.image_height, EXCLUDED.is_retweet, EXCLUDED.retweet_count, EXCLUDED.type, EXCLUDED.token_ids, EXCLUDED.status, EXCLUDED.facebook_account_id, EXCLUDED.friends_count, EXCLUDED.comment_count, EXCLUDED.reach, EXCLUDED.token_id, EXCLUDED.plays_count, EXCLUDED.link, EXCLUDED.attachment_description, EXCLUDED.shares_count, EXCLUDED.url, EXCLUDED.like_count, EXCLUDED.image_url, EXCLUDED.urls, EXCLUDED.youtube_id, EXCLUDED.url_id, NOW());
ELSEIF (date(NEW.created) >= DATE '2016-11-01' AND date(NEW.created) <= DATE '2016-11-30' ) THEN
          INSERT INTO adfunnel.tweets_20161101 VALUES (NEW.*) on conflict (id, token_id) do update set (username, attachment_url, signup_form_id, text, hashtags, profile_image, web_url, chunks,  facebook_username_id, favorite_count, zipcodes, display_name, media, image_width, attachment_title, followers_count, image_height, is_retweet, retweet_count, type, token_ids, status, facebook_account_id, friends_count, comment_count, reach, token_id, plays_count, link, attachment_description, shares_count, url, like_count, image_url, urls, youtube_id, url_id, modified)   = ( EXCLUDED.username, EXCLUDED.attachment_url, EXCLUDED.signup_form_id, EXCLUDED.text, EXCLUDED.hashtags, EXCLUDED.profile_image, EXCLUDED.web_url, EXCLUDED.chunks,  EXCLUDED.facebook_username_id, EXCLUDED.favorite_count, EXCLUDED.zipcodes, EXCLUDED.display_name, EXCLUDED.media, EXCLUDED.image_width, EXCLUDED.attachment_title, EXCLUDED.followers_count, EXCLUDED.image_height, EXCLUDED.is_retweet, EXCLUDED.retweet_count, EXCLUDED.type, EXCLUDED.token_ids, EXCLUDED.status, EXCLUDED.facebook_account_id, EXCLUDED.friends_count, EXCLUDED.comment_count, EXCLUDED.reach, EXCLUDED.token_id, EXCLUDED.plays_count, EXCLUDED.link, EXCLUDED.attachment_description, EXCLUDED.shares_count, EXCLUDED.url, EXCLUDED.like_count, EXCLUDED.image_url, EXCLUDED.urls, EXCLUDED.youtube_id, EXCLUDED.url_id, NOW());
ELSEIF (date(NEW.created) >= DATE '2016-12-01' AND date(NEW.created) <= DATE '2016-12-31' ) THEN
          INSERT INTO adfunnel.tweets_20161201 VALUES (NEW.*) on conflict (id, token_id) do update set (username, attachment_url, signup_form_id, text, hashtags, profile_image, web_url, chunks,  facebook_username_id, favorite_count, zipcodes, display_name, media, image_width, attachment_title, followers_count, image_height, is_retweet, retweet_count, type, token_ids, status, facebook_account_id, friends_count, comment_count, reach, token_id, plays_count, link, attachment_description, shares_count, url, like_count, image_url, urls, youtube_id, url_id, modified)   = ( EXCLUDED.username, EXCLUDED.attachment_url, EXCLUDED.signup_form_id, EXCLUDED.text, EXCLUDED.hashtags, EXCLUDED.profile_image, EXCLUDED.web_url, EXCLUDED.chunks,  EXCLUDED.facebook_username_id, EXCLUDED.favorite_count, EXCLUDED.zipcodes, EXCLUDED.display_name, EXCLUDED.media, EXCLUDED.image_width, EXCLUDED.attachment_title, EXCLUDED.followers_count, EXCLUDED.image_height, EXCLUDED.is_retweet, EXCLUDED.retweet_count, EXCLUDED.type, EXCLUDED.token_ids, EXCLUDED.status, EXCLUDED.facebook_account_id, EXCLUDED.friends_count, EXCLUDED.comment_count, EXCLUDED.reach, EXCLUDED.token_id, EXCLUDED.plays_count, EXCLUDED.link, EXCLUDED.attachment_description, EXCLUDED.shares_count, EXCLUDED.url, EXCLUDED.like_count, EXCLUDED.image_url, EXCLUDED.urls, EXCLUDED.youtube_id, EXCLUDED.url_id, NOW());
ELSEIF (date(NEW.created) >= DATE '2017-01-01' AND date(NEW.created) <= DATE '2017-01-31' ) THEN
          INSERT INTO adfunnel.tweets_20170101 VALUES (NEW.*) on conflict (id, token_id) do update set (username, attachment_url, signup_form_id, text, hashtags, profile_image, web_url, chunks,  facebook_username_id, favorite_count, zipcodes, display_name, media, image_width, attachment_title, followers_count, image_height, is_retweet, retweet_count, type, token_ids, status, facebook_account_id, friends_count, comment_count, reach, token_id, plays_count, link, attachment_description, shares_count, url, like_count, image_url, urls, youtube_id, url_id, modified)   = ( EXCLUDED.username, EXCLUDED.attachment_url, EXCLUDED.signup_form_id, EXCLUDED.text, EXCLUDED.hashtags, EXCLUDED.profile_image, EXCLUDED.web_url, EXCLUDED.chunks,  EXCLUDED.facebook_username_id, EXCLUDED.favorite_count, EXCLUDED.zipcodes, EXCLUDED.display_name, EXCLUDED.media, EXCLUDED.image_width, EXCLUDED.attachment_title, EXCLUDED.followers_count, EXCLUDED.image_height, EXCLUDED.is_retweet, EXCLUDED.retweet_count, EXCLUDED.type, EXCLUDED.token_ids, EXCLUDED.status, EXCLUDED.facebook_account_id, EXCLUDED.friends_count, EXCLUDED.comment_count, EXCLUDED.reach, EXCLUDED.token_id, EXCLUDED.plays_count, EXCLUDED.link, EXCLUDED.attachment_description, EXCLUDED.shares_count, EXCLUDED.url, EXCLUDED.like_count, EXCLUDED.image_url, EXCLUDED.urls, EXCLUDED.youtube_id, EXCLUDED.url_id, NOW());
ELSEIF (date(NEW.created) >= DATE '2017-02-01' AND date(NEW.created) <= DATE '2017-02-28' ) THEN
          INSERT INTO adfunnel.tweets_20170201 VALUES (NEW.*) on conflict (id, token_id) do update set (username, attachment_url, signup_form_id, text, hashtags, profile_image, web_url, chunks,  facebook_username_id, favorite_count, zipcodes, display_name, media, image_width, attachment_title, followers_count, image_height, is_retweet, retweet_count, type, token_ids, status, facebook_account_id, friends_count, comment_count, reach, token_id, plays_count, link, attachment_description, shares_count, url, like_count, image_url, urls, youtube_id, url_id, modified)   = ( EXCLUDED.username, EXCLUDED.attachment_url, EXCLUDED.signup_form_id, EXCLUDED.text, EXCLUDED.hashtags, EXCLUDED.profile_image, EXCLUDED.web_url, EXCLUDED.chunks,  EXCLUDED.facebook_username_id, EXCLUDED.favorite_count, EXCLUDED.zipcodes, EXCLUDED.display_name, EXCLUDED.media, EXCLUDED.image_width, EXCLUDED.attachment_title, EXCLUDED.followers_count, EXCLUDED.image_height, EXCLUDED.is_retweet, EXCLUDED.retweet_count, EXCLUDED.type, EXCLUDED.token_ids, EXCLUDED.status, EXCLUDED.facebook_account_id, EXCLUDED.friends_count, EXCLUDED.comment_count, EXCLUDED.reach, EXCLUDED.token_id, EXCLUDED.plays_count, EXCLUDED.link, EXCLUDED.attachment_description, EXCLUDED.shares_count, EXCLUDED.url, EXCLUDED.like_count, EXCLUDED.image_url, EXCLUDED.urls, EXCLUDED.youtube_id, EXCLUDED.url_id, NOW());
ELSEIF (date(NEW.created) >= DATE '2017-03-01' AND date(NEW.created) <= DATE '2017-03-31' ) THEN
          INSERT INTO adfunnel.tweets_20170301 VALUES (NEW.*) on conflict (id, token_id) do update set (username, attachment_url, signup_form_id, text, hashtags, profile_image, web_url, chunks,  facebook_username_id, favorite_count, zipcodes, display_name, media, image_width, attachment_title, followers_count, image_height, is_retweet, retweet_count, type, token_ids, status, facebook_account_id, friends_count, comment_count, reach, token_id, plays_count, link, attachment_description, shares_count, url, like_count, image_url, urls, youtube_id, url_id, modified)   = ( EXCLUDED.username, EXCLUDED.attachment_url, EXCLUDED.signup_form_id, EXCLUDED.text, EXCLUDED.hashtags, EXCLUDED.profile_image, EXCLUDED.web_url, EXCLUDED.chunks,  EXCLUDED.facebook_username_id, EXCLUDED.favorite_count, EXCLUDED.zipcodes, EXCLUDED.display_name, EXCLUDED.media, EXCLUDED.image_width, EXCLUDED.attachment_title, EXCLUDED.followers_count, EXCLUDED.image_height, EXCLUDED.is_retweet, EXCLUDED.retweet_count, EXCLUDED.type, EXCLUDED.token_ids, EXCLUDED.status, EXCLUDED.facebook_account_id, EXCLUDED.friends_count, EXCLUDED.comment_count, EXCLUDED.reach, EXCLUDED.token_id, EXCLUDED.plays_count, EXCLUDED.link, EXCLUDED.attachment_description, EXCLUDED.shares_count, EXCLUDED.url, EXCLUDED.like_count, EXCLUDED.image_url, EXCLUDED.urls, EXCLUDED.youtube_id, EXCLUDED.url_id, NOW());
ELSEIF (date(NEW.created) >= DATE '2017-04-01' AND date(NEW.created) <= DATE '2017-04-30' ) THEN
          INSERT INTO adfunnel.tweets_20170401 VALUES (NEW.*) on conflict (id, token_id) do update set (username, attachment_url, signup_form_id, text, hashtags, profile_image, web_url, chunks,  facebook_username_id, favorite_count, zipcodes, display_name, media, image_width, attachment_title, followers_count, image_height, is_retweet, retweet_count, type, token_ids, status, facebook_account_id, friends_count, comment_count, reach, token_id, plays_count, link, attachment_description, shares_count, url, like_count, image_url, urls, youtube_id, url_id, modified)   = ( EXCLUDED.username, EXCLUDED.attachment_url, EXCLUDED.signup_form_id, EXCLUDED.text, EXCLUDED.hashtags, EXCLUDED.profile_image, EXCLUDED.web_url, EXCLUDED.chunks,  EXCLUDED.facebook_username_id, EXCLUDED.favorite_count, EXCLUDED.zipcodes, EXCLUDED.display_name, EXCLUDED.media, EXCLUDED.image_width, EXCLUDED.attachment_title, EXCLUDED.followers_count, EXCLUDED.image_height, EXCLUDED.is_retweet, EXCLUDED.retweet_count, EXCLUDED.type, EXCLUDED.token_ids, EXCLUDED.status, EXCLUDED.facebook_account_id, EXCLUDED.friends_count, EXCLUDED.comment_count, EXCLUDED.reach, EXCLUDED.token_id, EXCLUDED.plays_count, EXCLUDED.link, EXCLUDED.attachment_description, EXCLUDED.shares_count, EXCLUDED.url, EXCLUDED.like_count, EXCLUDED.image_url, EXCLUDED.urls, EXCLUDED.youtube_id, EXCLUDED.url_id, NOW());
ELSEIF (date(NEW.created) >= DATE '2017-05-01' AND date(NEW.created) <= DATE '2017-05-31' ) THEN
          INSERT INTO adfunnel.tweets_20170501 VALUES (NEW.*) on conflict (id, token_id) do update set (username, attachment_url, signup_form_id, text, hashtags, profile_image, web_url, chunks,  facebook_username_id, favorite_count, zipcodes, display_name, media, image_width, attachment_title, followers_count, image_height, is_retweet, retweet_count, type, token_ids, status, facebook_account_id, friends_count, comment_count, reach, token_id, plays_count, link, attachment_description, shares_count, url, like_count, image_url, urls, youtube_id, url_id, modified)   = ( EXCLUDED.username, EXCLUDED.attachment_url, EXCLUDED.signup_form_id, EXCLUDED.text, EXCLUDED.hashtags, EXCLUDED.profile_image, EXCLUDED.web_url, EXCLUDED.chunks,  EXCLUDED.facebook_username_id, EXCLUDED.favorite_count, EXCLUDED.zipcodes, EXCLUDED.display_name, EXCLUDED.media, EXCLUDED.image_width, EXCLUDED.attachment_title, EXCLUDED.followers_count, EXCLUDED.image_height, EXCLUDED.is_retweet, EXCLUDED.retweet_count, EXCLUDED.type, EXCLUDED.token_ids, EXCLUDED.status, EXCLUDED.facebook_account_id, EXCLUDED.friends_count, EXCLUDED.comment_count, EXCLUDED.reach, EXCLUDED.token_id, EXCLUDED.plays_count, EXCLUDED.link, EXCLUDED.attachment_description, EXCLUDED.shares_count, EXCLUDED.url, EXCLUDED.like_count, EXCLUDED.image_url, EXCLUDED.urls, EXCLUDED.youtube_id, EXCLUDED.url_id, NOW());
ELSEIF (date(NEW.created) >= DATE '2017-06-01' AND date(NEW.created) <= DATE '2017-06-30' ) THEN
          INSERT INTO adfunnel.tweets_20170601 VALUES (NEW.*) on conflict (id, token_id) do update set (username, attachment_url, signup_form_id, text, hashtags, profile_image, web_url, chunks,  facebook_username_id, favorite_count, zipcodes, display_name, media, image_width, attachment_title, followers_count, image_height, is_retweet, retweet_count, type, token_ids, status, facebook_account_id, friends_count, comment_count, reach, token_id, plays_count, link, attachment_description, shares_count, url, like_count, image_url, urls, youtube_id, url_id, modified)   = ( EXCLUDED.username, EXCLUDED.attachment_url, EXCLUDED.signup_form_id, EXCLUDED.text, EXCLUDED.hashtags, EXCLUDED.profile_image, EXCLUDED.web_url, EXCLUDED.chunks,  EXCLUDED.facebook_username_id, EXCLUDED.favorite_count, EXCLUDED.zipcodes, EXCLUDED.display_name, EXCLUDED.media, EXCLUDED.image_width, EXCLUDED.attachment_title, EXCLUDED.followers_count, EXCLUDED.image_height, EXCLUDED.is_retweet, EXCLUDED.retweet_count, EXCLUDED.type, EXCLUDED.token_ids, EXCLUDED.status, EXCLUDED.facebook_account_id, EXCLUDED.friends_count, EXCLUDED.comment_count, EXCLUDED.reach, EXCLUDED.token_id, EXCLUDED.plays_count, EXCLUDED.link, EXCLUDED.attachment_description, EXCLUDED.shares_count, EXCLUDED.url, EXCLUDED.like_count, EXCLUDED.image_url, EXCLUDED.urls, EXCLUDED.youtube_id, EXCLUDED.url_id, NOW());
ELSEIF (date(NEW.created) >= DATE '2017-07-01' AND date(NEW.created) <= DATE '2017-07-31' ) THEN
          INSERT INTO adfunnel.tweets_20170701 VALUES (NEW.*) on conflict (id, token_id) do update set (username, attachment_url, signup_form_id, text, hashtags, profile_image, web_url, chunks,  facebook_username_id, favorite_count, zipcodes, display_name, media, image_width, attachment_title, followers_count, image_height, is_retweet, retweet_count, type, token_ids, status, facebook_account_id, friends_count, comment_count, reach, token_id, plays_count, link, attachment_description, shares_count, url, like_count, image_url, urls, youtube_id, url_id, modified)   = ( EXCLUDED.username, EXCLUDED.attachment_url, EXCLUDED.signup_form_id, EXCLUDED.text, EXCLUDED.hashtags, EXCLUDED.profile_image, EXCLUDED.web_url, EXCLUDED.chunks,  EXCLUDED.facebook_username_id, EXCLUDED.favorite_count, EXCLUDED.zipcodes, EXCLUDED.display_name, EXCLUDED.media, EXCLUDED.image_width, EXCLUDED.attachment_title, EXCLUDED.followers_count, EXCLUDED.image_height, EXCLUDED.is_retweet, EXCLUDED.retweet_count, EXCLUDED.type, EXCLUDED.token_ids, EXCLUDED.status, EXCLUDED.facebook_account_id, EXCLUDED.friends_count, EXCLUDED.comment_count, EXCLUDED.reach, EXCLUDED.token_id, EXCLUDED.plays_count, EXCLUDED.link, EXCLUDED.attachment_description, EXCLUDED.shares_count, EXCLUDED.url, EXCLUDED.like_count, EXCLUDED.image_url, EXCLUDED.urls, EXCLUDED.youtube_id, EXCLUDED.url_id, NOW());
ELSEIF (date(NEW.created) >= DATE '2017-08-01' AND date(NEW.created) <= DATE '2017-08-31' ) THEN
          INSERT INTO adfunnel.tweets_20170801 VALUES (NEW.*) on conflict (id, token_id) do update set (username, attachment_url, signup_form_id, text, hashtags, profile_image, web_url, chunks,  facebook_username_id, favorite_count, zipcodes, display_name, media, image_width, attachment_title, followers_count, image_height, is_retweet, retweet_count, type, token_ids, status, facebook_account_id, friends_count, comment_count, reach, token_id, plays_count, link, attachment_description, shares_count, url, like_count, image_url, urls, youtube_id, url_id, modified)   = ( EXCLUDED.username, EXCLUDED.attachment_url, EXCLUDED.signup_form_id, EXCLUDED.text, EXCLUDED.hashtags, EXCLUDED.profile_image, EXCLUDED.web_url, EXCLUDED.chunks,  EXCLUDED.facebook_username_id, EXCLUDED.favorite_count, EXCLUDED.zipcodes, EXCLUDED.display_name, EXCLUDED.media, EXCLUDED.image_width, EXCLUDED.attachment_title, EXCLUDED.followers_count, EXCLUDED.image_height, EXCLUDED.is_retweet, EXCLUDED.retweet_count, EXCLUDED.type, EXCLUDED.token_ids, EXCLUDED.status, EXCLUDED.facebook_account_id, EXCLUDED.friends_count, EXCLUDED.comment_count, EXCLUDED.reach, EXCLUDED.token_id, EXCLUDED.plays_count, EXCLUDED.link, EXCLUDED.attachment_description, EXCLUDED.shares_count, EXCLUDED.url, EXCLUDED.like_count, EXCLUDED.image_url, EXCLUDED.urls, EXCLUDED.youtube_id, EXCLUDED.url_id, NOW());
ELSEIF (date(NEW.created) >= DATE '2017-09-01' AND date(NEW.created) <= DATE '2017-09-30' ) THEN
          INSERT INTO adfunnel.tweets_20170901 VALUES (NEW.*) on conflict (id, token_id) do update set (username, attachment_url, signup_form_id, text, hashtags, profile_image, web_url, chunks,  facebook_username_id, favorite_count, zipcodes, display_name, media, image_width, attachment_title, followers_count, image_height, is_retweet, retweet_count, type, token_ids, status, facebook_account_id, friends_count, comment_count, reach, token_id, plays_count, link, attachment_description, shares_count, url, like_count, image_url, urls, youtube_id, url_id, modified)   = ( EXCLUDED.username, EXCLUDED.attachment_url, EXCLUDED.signup_form_id, EXCLUDED.text, EXCLUDED.hashtags, EXCLUDED.profile_image, EXCLUDED.web_url, EXCLUDED.chunks,  EXCLUDED.facebook_username_id, EXCLUDED.favorite_count, EXCLUDED.zipcodes, EXCLUDED.display_name, EXCLUDED.media, EXCLUDED.image_width, EXCLUDED.attachment_title, EXCLUDED.followers_count, EXCLUDED.image_height, EXCLUDED.is_retweet, EXCLUDED.retweet_count, EXCLUDED.type, EXCLUDED.token_ids, EXCLUDED.status, EXCLUDED.facebook_account_id, EXCLUDED.friends_count, EXCLUDED.comment_count, EXCLUDED.reach, EXCLUDED.token_id, EXCLUDED.plays_count, EXCLUDED.link, EXCLUDED.attachment_description, EXCLUDED.shares_count, EXCLUDED.url, EXCLUDED.like_count, EXCLUDED.image_url, EXCLUDED.urls, EXCLUDED.youtube_id, EXCLUDED.url_id, NOW());
ELSEIF (date(NEW.created) >= DATE '2017-10-01' AND date(NEW.created) <= DATE '2017-10-31' ) THEN
          INSERT INTO adfunnel.tweets_20171001 VALUES (NEW.*) on conflict (id, token_id) do update set (username, attachment_url, signup_form_id, text, hashtags, profile_image, web_url, chunks,  facebook_username_id, favorite_count, zipcodes, display_name, media, image_width, attachment_title, followers_count, image_height, is_retweet, retweet_count, type, token_ids, status, facebook_account_id, friends_count, comment_count, reach, token_id, plays_count, link, attachment_description, shares_count, url, like_count, image_url, urls, youtube_id, url_id, modified)   = ( EXCLUDED.username, EXCLUDED.attachment_url, EXCLUDED.signup_form_id, EXCLUDED.text, EXCLUDED.hashtags, EXCLUDED.profile_image, EXCLUDED.web_url, EXCLUDED.chunks,  EXCLUDED.facebook_username_id, EXCLUDED.favorite_count, EXCLUDED.zipcodes, EXCLUDED.display_name, EXCLUDED.media, EXCLUDED.image_width, EXCLUDED.attachment_title, EXCLUDED.followers_count, EXCLUDED.image_height, EXCLUDED.is_retweet, EXCLUDED.retweet_count, EXCLUDED.type, EXCLUDED.token_ids, EXCLUDED.status, EXCLUDED.facebook_account_id, EXCLUDED.friends_count, EXCLUDED.comment_count, EXCLUDED.reach, EXCLUDED.token_id, EXCLUDED.plays_count, EXCLUDED.link, EXCLUDED.attachment_description, EXCLUDED.shares_count, EXCLUDED.url, EXCLUDED.like_count, EXCLUDED.image_url, EXCLUDED.urls, EXCLUDED.youtube_id, EXCLUDED.url_id, NOW());
ELSEIF (date(NEW.created) >= DATE '2017-11-01' AND date(NEW.created) <= DATE '2017-11-30' ) THEN
          INSERT INTO adfunnel.tweets_20171101 VALUES (NEW.*) on conflict (id, token_id) do update set (username, attachment_url, signup_form_id, text, hashtags, profile_image, web_url, chunks,  facebook_username_id, favorite_count, zipcodes, display_name, media, image_width, attachment_title, followers_count, image_height, is_retweet, retweet_count, type, token_ids, status, facebook_account_id, friends_count, comment_count, reach, token_id, plays_count, link, attachment_description, shares_count, url, like_count, image_url, urls, youtube_id, url_id, modified)   = ( EXCLUDED.username, EXCLUDED.attachment_url, EXCLUDED.signup_form_id, EXCLUDED.text, EXCLUDED.hashtags, EXCLUDED.profile_image, EXCLUDED.web_url, EXCLUDED.chunks,  EXCLUDED.facebook_username_id, EXCLUDED.favorite_count, EXCLUDED.zipcodes, EXCLUDED.display_name, EXCLUDED.media, EXCLUDED.image_width, EXCLUDED.attachment_title, EXCLUDED.followers_count, EXCLUDED.image_height, EXCLUDED.is_retweet, EXCLUDED.retweet_count, EXCLUDED.type, EXCLUDED.token_ids, EXCLUDED.status, EXCLUDED.facebook_account_id, EXCLUDED.friends_count, EXCLUDED.comment_count, EXCLUDED.reach, EXCLUDED.token_id, EXCLUDED.plays_count, EXCLUDED.link, EXCLUDED.attachment_description, EXCLUDED.shares_count, EXCLUDED.url, EXCLUDED.like_count, EXCLUDED.image_url, EXCLUDED.urls, EXCLUDED.youtube_id, EXCLUDED.url_id, NOW());
ELSEIF (date(NEW.created) >= DATE '2017-12-01' AND date(NEW.created) <= DATE '2017-12-31' ) THEN
          INSERT INTO adfunnel.tweets_20171201 VALUES (NEW.*) on conflict (id, token_id) do update set (username, attachment_url, signup_form_id, text, hashtags, profile_image, web_url, chunks,  facebook_username_id, favorite_count, zipcodes, display_name, media, image_width, attachment_title, followers_count, image_height, is_retweet, retweet_count, type, token_ids, status, facebook_account_id, friends_count, comment_count, reach, token_id, plays_count, link, attachment_description, shares_count, url, like_count, image_url, urls, youtube_id, url_id, modified)   = ( EXCLUDED.username, EXCLUDED.attachment_url, EXCLUDED.signup_form_id, EXCLUDED.text, EXCLUDED.hashtags, EXCLUDED.profile_image, EXCLUDED.web_url, EXCLUDED.chunks,  EXCLUDED.facebook_username_id, EXCLUDED.favorite_count, EXCLUDED.zipcodes, EXCLUDED.display_name, EXCLUDED.media, EXCLUDED.image_width, EXCLUDED.attachment_title, EXCLUDED.followers_count, EXCLUDED.image_height, EXCLUDED.is_retweet, EXCLUDED.retweet_count, EXCLUDED.type, EXCLUDED.token_ids, EXCLUDED.status, EXCLUDED.facebook_account_id, EXCLUDED.friends_count, EXCLUDED.comment_count, EXCLUDED.reach, EXCLUDED.token_id, EXCLUDED.plays_count, EXCLUDED.link, EXCLUDED.attachment_description, EXCLUDED.shares_count, EXCLUDED.url, EXCLUDED.like_count, EXCLUDED.image_url, EXCLUDED.urls, EXCLUDED.youtube_id, EXCLUDED.url_id, NOW());
ELSEIF (date(NEW.created) >= DATE '2018-01-01' AND date(NEW.created) <= DATE '2018-01-31' ) THEN
          INSERT INTO adfunnel.tweets_20180101 VALUES (NEW.*) on conflict (id, token_id) do update set (username, attachment_url, signup_form_id, text, hashtags, profile_image, web_url, chunks,  facebook_username_id, favorite_count, zipcodes, display_name, media, image_width, attachment_title, followers_count, image_height, is_retweet, retweet_count, type, token_ids, status, facebook_account_id, friends_count, comment_count, reach, token_id, plays_count, link, attachment_description, shares_count, url, like_count, image_url, urls, youtube_id, url_id, modified)   = ( EXCLUDED.username, EXCLUDED.attachment_url, EXCLUDED.signup_form_id, EXCLUDED.text, EXCLUDED.hashtags, EXCLUDED.profile_image, EXCLUDED.web_url, EXCLUDED.chunks,  EXCLUDED.facebook_username_id, EXCLUDED.favorite_count, EXCLUDED.zipcodes, EXCLUDED.display_name, EXCLUDED.media, EXCLUDED.image_width, EXCLUDED.attachment_title, EXCLUDED.followers_count, EXCLUDED.image_height, EXCLUDED.is_retweet, EXCLUDED.retweet_count, EXCLUDED.type, EXCLUDED.token_ids, EXCLUDED.status, EXCLUDED.facebook_account_id, EXCLUDED.friends_count, EXCLUDED.comment_count, EXCLUDED.reach, EXCLUDED.token_id, EXCLUDED.plays_count, EXCLUDED.link, EXCLUDED.attachment_description, EXCLUDED.shares_count, EXCLUDED.url, EXCLUDED.like_count, EXCLUDED.image_url, EXCLUDED.urls, EXCLUDED.youtube_id, EXCLUDED.url_id, NOW());
ELSEIF (date(NEW.created) >= DATE '2018-02-01' AND date(NEW.created) <= DATE '2018-02-28' ) THEN
          INSERT INTO adfunnel.tweets_20180201 VALUES (NEW.*) on conflict (id, token_id) do update set (username, attachment_url, signup_form_id, text, hashtags, profile_image, web_url, chunks,  facebook_username_id, favorite_count, zipcodes, display_name, media, image_width, attachment_title, followers_count, image_height, is_retweet, retweet_count, type, token_ids, status, facebook_account_id, friends_count, comment_count, reach, token_id, plays_count, link, attachment_description, shares_count, url, like_count, image_url, urls, youtube_id, url_id, modified)   = ( EXCLUDED.username, EXCLUDED.attachment_url, EXCLUDED.signup_form_id, EXCLUDED.text, EXCLUDED.hashtags, EXCLUDED.profile_image, EXCLUDED.web_url, EXCLUDED.chunks,  EXCLUDED.facebook_username_id, EXCLUDED.favorite_count, EXCLUDED.zipcodes, EXCLUDED.display_name, EXCLUDED.media, EXCLUDED.image_width, EXCLUDED.attachment_title, EXCLUDED.followers_count, EXCLUDED.image_height, EXCLUDED.is_retweet, EXCLUDED.retweet_count, EXCLUDED.type, EXCLUDED.token_ids, EXCLUDED.status, EXCLUDED.facebook_account_id, EXCLUDED.friends_count, EXCLUDED.comment_count, EXCLUDED.reach, EXCLUDED.token_id, EXCLUDED.plays_count, EXCLUDED.link, EXCLUDED.attachment_description, EXCLUDED.shares_count, EXCLUDED.url, EXCLUDED.like_count, EXCLUDED.image_url, EXCLUDED.urls, EXCLUDED.youtube_id, EXCLUDED.url_id, NOW());
ELSEIF (date(NEW.created) >= DATE '2018-03-01' AND date(NEW.created) <= DATE '2018-03-31' ) THEN
          INSERT INTO adfunnel.tweets_20180301 VALUES (NEW.*) on conflict (id, token_id) do update set (username, attachment_url, signup_form_id, text, hashtags, profile_image, web_url, chunks,  facebook_username_id, favorite_count, zipcodes, display_name, media, image_width, attachment_title, followers_count, image_height, is_retweet, retweet_count, type, token_ids, status, facebook_account_id, friends_count, comment_count, reach, token_id, plays_count, link, attachment_description, shares_count, url, like_count, image_url, urls, youtube_id, url_id, modified)   = ( EXCLUDED.username, EXCLUDED.attachment_url, EXCLUDED.signup_form_id, EXCLUDED.text, EXCLUDED.hashtags, EXCLUDED.profile_image, EXCLUDED.web_url, EXCLUDED.chunks,  EXCLUDED.facebook_username_id, EXCLUDED.favorite_count, EXCLUDED.zipcodes, EXCLUDED.display_name, EXCLUDED.media, EXCLUDED.image_width, EXCLUDED.attachment_title, EXCLUDED.followers_count, EXCLUDED.image_height, EXCLUDED.is_retweet, EXCLUDED.retweet_count, EXCLUDED.type, EXCLUDED.token_ids, EXCLUDED.status, EXCLUDED.facebook_account_id, EXCLUDED.friends_count, EXCLUDED.comment_count, EXCLUDED.reach, EXCLUDED.token_id, EXCLUDED.plays_count, EXCLUDED.link, EXCLUDED.attachment_description, EXCLUDED.shares_count, EXCLUDED.url, EXCLUDED.like_count, EXCLUDED.image_url, EXCLUDED.urls, EXCLUDED.youtube_id, EXCLUDED.url_id, NOW());
ELSEIF (date(NEW.created) >= DATE '2018-04-01' AND date(NEW.created) <= DATE '2018-04-30' ) THEN
          INSERT INTO adfunnel.tweets_20180401 VALUES (NEW.*) on conflict (id, token_id) do update set (username, attachment_url, signup_form_id, text, hashtags, profile_image, web_url, chunks,  facebook_username_id, favorite_count, zipcodes, display_name, media, image_width, attachment_title, followers_count, image_height, is_retweet, retweet_count, type, token_ids, status, facebook_account_id, friends_count, comment_count, reach, token_id, plays_count, link, attachment_description, shares_count, url, like_count, image_url, urls, youtube_id, url_id, modified)   = ( EXCLUDED.username, EXCLUDED.attachment_url, EXCLUDED.signup_form_id, EXCLUDED.text, EXCLUDED.hashtags, EXCLUDED.profile_image, EXCLUDED.web_url, EXCLUDED.chunks,  EXCLUDED.facebook_username_id, EXCLUDED.favorite_count, EXCLUDED.zipcodes, EXCLUDED.display_name, EXCLUDED.media, EXCLUDED.image_width, EXCLUDED.attachment_title, EXCLUDED.followers_count, EXCLUDED.image_height, EXCLUDED.is_retweet, EXCLUDED.retweet_count, EXCLUDED.type, EXCLUDED.token_ids, EXCLUDED.status, EXCLUDED.facebook_account_id, EXCLUDED.friends_count, EXCLUDED.comment_count, EXCLUDED.reach, EXCLUDED.token_id, EXCLUDED.plays_count, EXCLUDED.link, EXCLUDED.attachment_description, EXCLUDED.shares_count, EXCLUDED.url, EXCLUDED.like_count, EXCLUDED.image_url, EXCLUDED.urls, EXCLUDED.youtube_id, EXCLUDED.url_id, NOW());
ELSEIF (date(NEW.created) >= DATE '2018-05-01' AND date(NEW.created) <= DATE '2018-05-31' ) THEN
          INSERT INTO adfunnel.tweets_20180501 VALUES (NEW.*) on conflict (id, token_id) do update set (username, attachment_url, signup_form_id, text, hashtags, profile_image, web_url, chunks,  facebook_username_id, favorite_count, zipcodes, display_name, media, image_width, attachment_title, followers_count, image_height, is_retweet, retweet_count, type, token_ids, status, facebook_account_id, friends_count, comment_count, reach, token_id, plays_count, link, attachment_description, shares_count, url, like_count, image_url, urls, youtube_id, url_id, modified)   = ( EXCLUDED.username, EXCLUDED.attachment_url, EXCLUDED.signup_form_id, EXCLUDED.text, EXCLUDED.hashtags, EXCLUDED.profile_image, EXCLUDED.web_url, EXCLUDED.chunks,  EXCLUDED.facebook_username_id, EXCLUDED.favorite_count, EXCLUDED.zipcodes, EXCLUDED.display_name, EXCLUDED.media, EXCLUDED.image_width, EXCLUDED.attachment_title, EXCLUDED.followers_count, EXCLUDED.image_height, EXCLUDED.is_retweet, EXCLUDED.retweet_count, EXCLUDED.type, EXCLUDED.token_ids, EXCLUDED.status, EXCLUDED.facebook_account_id, EXCLUDED.friends_count, EXCLUDED.comment_count, EXCLUDED.reach, EXCLUDED.token_id, EXCLUDED.plays_count, EXCLUDED.link, EXCLUDED.attachment_description, EXCLUDED.shares_count, EXCLUDED.url, EXCLUDED.like_count, EXCLUDED.image_url, EXCLUDED.urls, EXCLUDED.youtube_id, EXCLUDED.url_id, NOW());
ELSEIF (date(NEW.created) >= DATE '2018-06-01' AND date(NEW.created) <= DATE '2018-06-30' ) THEN
          INSERT INTO adfunnel.tweets_20180601 VALUES (NEW.*) on conflict (id, token_id) do update set (username, attachment_url, signup_form_id, text, hashtags, profile_image, web_url, chunks,  facebook_username_id, favorite_count, zipcodes, display_name, media, image_width, attachment_title, followers_count, image_height, is_retweet, retweet_count, type, token_ids, status, facebook_account_id, friends_count, comment_count, reach, token_id, plays_count, link, attachment_description, shares_count, url, like_count, image_url, urls, youtube_id, url_id, modified)   = ( EXCLUDED.username, EXCLUDED.attachment_url, EXCLUDED.signup_form_id, EXCLUDED.text, EXCLUDED.hashtags, EXCLUDED.profile_image, EXCLUDED.web_url, EXCLUDED.chunks,  EXCLUDED.facebook_username_id, EXCLUDED.favorite_count, EXCLUDED.zipcodes, EXCLUDED.display_name, EXCLUDED.media, EXCLUDED.image_width, EXCLUDED.attachment_title, EXCLUDED.followers_count, EXCLUDED.image_height, EXCLUDED.is_retweet, EXCLUDED.retweet_count, EXCLUDED.type, EXCLUDED.token_ids, EXCLUDED.status, EXCLUDED.facebook_account_id, EXCLUDED.friends_count, EXCLUDED.comment_count, EXCLUDED.reach, EXCLUDED.token_id, EXCLUDED.plays_count, EXCLUDED.link, EXCLUDED.attachment_description, EXCLUDED.shares_count, EXCLUDED.url, EXCLUDED.like_count, EXCLUDED.image_url, EXCLUDED.urls, EXCLUDED.youtube_id, EXCLUDED.url_id, NOW());
ELSEIF (date(NEW.created) >= DATE '2018-07-01' AND date(NEW.created) <= DATE '2018-07-31' ) THEN
          INSERT INTO adfunnel.tweets_20180701 VALUES (NEW.*) on conflict (id, token_id) do update set (username, attachment_url, signup_form_id, text, hashtags, profile_image, web_url, chunks,  facebook_username_id, favorite_count, zipcodes, display_name, media, image_width, attachment_title, followers_count, image_height, is_retweet, retweet_count, type, token_ids, status, facebook_account_id, friends_count, comment_count, reach, token_id, plays_count, link, attachment_description, shares_count, url, like_count, image_url, urls, youtube_id, url_id, modified)   = ( EXCLUDED.username, EXCLUDED.attachment_url, EXCLUDED.signup_form_id, EXCLUDED.text, EXCLUDED.hashtags, EXCLUDED.profile_image, EXCLUDED.web_url, EXCLUDED.chunks,  EXCLUDED.facebook_username_id, EXCLUDED.favorite_count, EXCLUDED.zipcodes, EXCLUDED.display_name, EXCLUDED.media, EXCLUDED.image_width, EXCLUDED.attachment_title, EXCLUDED.followers_count, EXCLUDED.image_height, EXCLUDED.is_retweet, EXCLUDED.retweet_count, EXCLUDED.type, EXCLUDED.token_ids, EXCLUDED.status, EXCLUDED.facebook_account_id, EXCLUDED.friends_count, EXCLUDED.comment_count, EXCLUDED.reach, EXCLUDED.token_id, EXCLUDED.plays_count, EXCLUDED.link, EXCLUDED.attachment_description, EXCLUDED.shares_count, EXCLUDED.url, EXCLUDED.like_count, EXCLUDED.image_url, EXCLUDED.urls, EXCLUDED.youtube_id, EXCLUDED.url_id, NOW());
ELSEIF (date(NEW.created) >= DATE '2018-08-01' AND date(NEW.created) <= DATE '2018-08-31' ) THEN
          INSERT INTO adfunnel.tweets_20180801 VALUES (NEW.*) on conflict (id, token_id) do update set (username, attachment_url, signup_form_id, text, hashtags, profile_image, web_url, chunks,  facebook_username_id, favorite_count, zipcodes, display_name, media, image_width, attachment_title, followers_count, image_height, is_retweet, retweet_count, type, token_ids, status, facebook_account_id, friends_count, comment_count, reach, token_id, plays_count, link, attachment_description, shares_count, url, like_count, image_url, urls, youtube_id, url_id, modified)   = ( EXCLUDED.username, EXCLUDED.attachment_url, EXCLUDED.signup_form_id, EXCLUDED.text, EXCLUDED.hashtags, EXCLUDED.profile_image, EXCLUDED.web_url, EXCLUDED.chunks,  EXCLUDED.facebook_username_id, EXCLUDED.favorite_count, EXCLUDED.zipcodes, EXCLUDED.display_name, EXCLUDED.media, EXCLUDED.image_width, EXCLUDED.attachment_title, EXCLUDED.followers_count, EXCLUDED.image_height, EXCLUDED.is_retweet, EXCLUDED.retweet_count, EXCLUDED.type, EXCLUDED.token_ids, EXCLUDED.status, EXCLUDED.facebook_account_id, EXCLUDED.friends_count, EXCLUDED.comment_count, EXCLUDED.reach, EXCLUDED.token_id, EXCLUDED.plays_count, EXCLUDED.link, EXCLUDED.attachment_description, EXCLUDED.shares_count, EXCLUDED.url, EXCLUDED.like_count, EXCLUDED.image_url, EXCLUDED.urls, EXCLUDED.youtube_id, EXCLUDED.url_id, NOW());
ELSEIF (date(NEW.created) >= DATE '2018-09-01' AND date(NEW.created) <= DATE '2018-09-30' ) THEN
          INSERT INTO adfunnel.tweets_20180901 VALUES (NEW.*) on conflict (id, token_id) do update set (username, attachment_url, signup_form_id, text, hashtags, profile_image, web_url, chunks,  facebook_username_id, favorite_count, zipcodes, display_name, media, image_width, attachment_title, followers_count, image_height, is_retweet, retweet_count, type, token_ids, status, facebook_account_id, friends_count, comment_count, reach, token_id, plays_count, link, attachment_description, shares_count, url, like_count, image_url, urls, youtube_id, url_id, modified)   = ( EXCLUDED.username, EXCLUDED.attachment_url, EXCLUDED.signup_form_id, EXCLUDED.text, EXCLUDED.hashtags, EXCLUDED.profile_image, EXCLUDED.web_url, EXCLUDED.chunks,  EXCLUDED.facebook_username_id, EXCLUDED.favorite_count, EXCLUDED.zipcodes, EXCLUDED.display_name, EXCLUDED.media, EXCLUDED.image_width, EXCLUDED.attachment_title, EXCLUDED.followers_count, EXCLUDED.image_height, EXCLUDED.is_retweet, EXCLUDED.retweet_count, EXCLUDED.type, EXCLUDED.token_ids, EXCLUDED.status, EXCLUDED.facebook_account_id, EXCLUDED.friends_count, EXCLUDED.comment_count, EXCLUDED.reach, EXCLUDED.token_id, EXCLUDED.plays_count, EXCLUDED.link, EXCLUDED.attachment_description, EXCLUDED.shares_count, EXCLUDED.url, EXCLUDED.like_count, EXCLUDED.image_url, EXCLUDED.urls, EXCLUDED.youtube_id, EXCLUDED.url_id, NOW());
ELSEIF (date(NEW.created) >= DATE '2018-10-01' AND date(NEW.created) <= DATE '2018-10-31' ) THEN
          INSERT INTO adfunnel.tweets_20181001 VALUES (NEW.*) on conflict (id, token_id) do update set (username, attachment_url, signup_form_id, text, hashtags, profile_image, web_url, chunks,  facebook_username_id, favorite_count, zipcodes, display_name, media, image_width, attachment_title, followers_count, image_height, is_retweet, retweet_count, type, token_ids, status, facebook_account_id, friends_count, comment_count, reach, token_id, plays_count, link, attachment_description, shares_count, url, like_count, image_url, urls, youtube_id, url_id, modified)   = ( EXCLUDED.username, EXCLUDED.attachment_url, EXCLUDED.signup_form_id, EXCLUDED.text, EXCLUDED.hashtags, EXCLUDED.profile_image, EXCLUDED.web_url, EXCLUDED.chunks,  EXCLUDED.facebook_username_id, EXCLUDED.favorite_count, EXCLUDED.zipcodes, EXCLUDED.display_name, EXCLUDED.media, EXCLUDED.image_width, EXCLUDED.attachment_title, EXCLUDED.followers_count, EXCLUDED.image_height, EXCLUDED.is_retweet, EXCLUDED.retweet_count, EXCLUDED.type, EXCLUDED.token_ids, EXCLUDED.status, EXCLUDED.facebook_account_id, EXCLUDED.friends_count, EXCLUDED.comment_count, EXCLUDED.reach, EXCLUDED.token_id, EXCLUDED.plays_count, EXCLUDED.link, EXCLUDED.attachment_description, EXCLUDED.shares_count, EXCLUDED.url, EXCLUDED.like_count, EXCLUDED.image_url, EXCLUDED.urls, EXCLUDED.youtube_id, EXCLUDED.url_id, NOW());
ELSEIF (date(NEW.created) >= DATE '2018-11-01' AND date(NEW.created) <= DATE '2018-11-30' ) THEN
          INSERT INTO adfunnel.tweets_20181101 VALUES (NEW.*) on conflict (id, token_id) do update set (username, attachment_url, signup_form_id, text, hashtags, profile_image, web_url, chunks,  facebook_username_id, favorite_count, zipcodes, display_name, media, image_width, attachment_title, followers_count, image_height, is_retweet, retweet_count, type, token_ids, status, facebook_account_id, friends_count, comment_count, reach, token_id, plays_count, link, attachment_description, shares_count, url, like_count, image_url, urls, youtube_id, url_id, modified)   = ( EXCLUDED.username, EXCLUDED.attachment_url, EXCLUDED.signup_form_id, EXCLUDED.text, EXCLUDED.hashtags, EXCLUDED.profile_image, EXCLUDED.web_url, EXCLUDED.chunks,  EXCLUDED.facebook_username_id, EXCLUDED.favorite_count, EXCLUDED.zipcodes, EXCLUDED.display_name, EXCLUDED.media, EXCLUDED.image_width, EXCLUDED.attachment_title, EXCLUDED.followers_count, EXCLUDED.image_height, EXCLUDED.is_retweet, EXCLUDED.retweet_count, EXCLUDED.type, EXCLUDED.token_ids, EXCLUDED.status, EXCLUDED.facebook_account_id, EXCLUDED.friends_count, EXCLUDED.comment_count, EXCLUDED.reach, EXCLUDED.token_id, EXCLUDED.plays_count, EXCLUDED.link, EXCLUDED.attachment_description, EXCLUDED.shares_count, EXCLUDED.url, EXCLUDED.like_count, EXCLUDED.image_url, EXCLUDED.urls, EXCLUDED.youtube_id, EXCLUDED.url_id, NOW());
ELSEIF (date(NEW.created) >= DATE '2018-12-01' AND date(NEW.created) <= DATE '2018-12-31' ) THEN
          INSERT INTO adfunnel.tweets_20181201 VALUES (NEW.*) on conflict (id, token_id) do update set (username, attachment_url, signup_form_id, text, hashtags, profile_image, web_url, chunks,  facebook_username_id, favorite_count, zipcodes, display_name, media, image_width, attachment_title, followers_count, image_height, is_retweet, retweet_count, type, token_ids, status, facebook_account_id, friends_count, comment_count, reach, token_id, plays_count, link, attachment_description, shares_count, url, like_count, image_url, urls, youtube_id, url_id, modified)   = ( EXCLUDED.username, EXCLUDED.attachment_url, EXCLUDED.signup_form_id, EXCLUDED.text, EXCLUDED.hashtags, EXCLUDED.profile_image, EXCLUDED.web_url, EXCLUDED.chunks,  EXCLUDED.facebook_username_id, EXCLUDED.favorite_count, EXCLUDED.zipcodes, EXCLUDED.display_name, EXCLUDED.media, EXCLUDED.image_width, EXCLUDED.attachment_title, EXCLUDED.followers_count, EXCLUDED.image_height, EXCLUDED.is_retweet, EXCLUDED.retweet_count, EXCLUDED.type, EXCLUDED.token_ids, EXCLUDED.status, EXCLUDED.facebook_account_id, EXCLUDED.friends_count, EXCLUDED.comment_count, EXCLUDED.reach, EXCLUDED.token_id, EXCLUDED.plays_count, EXCLUDED.link, EXCLUDED.attachment_description, EXCLUDED.shares_count, EXCLUDED.url, EXCLUDED.like_count, EXCLUDED.image_url, EXCLUDED.urls, EXCLUDED.youtube_id, EXCLUDED.url_id, NOW());
ELSEIF (date(NEW.created) >= DATE '2019-01-01' AND date(NEW.created) <= DATE '2019-01-31' ) THEN
          INSERT INTO adfunnel.tweets_20190101 VALUES (NEW.*) on conflict (id, token_id) do update set (username, attachment_url, signup_form_id, text, hashtags, profile_image, web_url, chunks,  facebook_username_id, favorite_count, zipcodes, display_name, media, image_width, attachment_title, followers_count, image_height, is_retweet, retweet_count, type, token_ids, status, facebook_account_id, friends_count, comment_count, reach, token_id, plays_count, link, attachment_description, shares_count, url, like_count, image_url, urls, youtube_id, url_id, modified)   = ( EXCLUDED.username, EXCLUDED.attachment_url, EXCLUDED.signup_form_id, EXCLUDED.text, EXCLUDED.hashtags, EXCLUDED.profile_image, EXCLUDED.web_url, EXCLUDED.chunks,  EXCLUDED.facebook_username_id, EXCLUDED.favorite_count, EXCLUDED.zipcodes, EXCLUDED.display_name, EXCLUDED.media, EXCLUDED.image_width, EXCLUDED.attachment_title, EXCLUDED.followers_count, EXCLUDED.image_height, EXCLUDED.is_retweet, EXCLUDED.retweet_count, EXCLUDED.type, EXCLUDED.token_ids, EXCLUDED.status, EXCLUDED.facebook_account_id, EXCLUDED.friends_count, EXCLUDED.comment_count, EXCLUDED.reach, EXCLUDED.token_id, EXCLUDED.plays_count, EXCLUDED.link, EXCLUDED.attachment_description, EXCLUDED.shares_count, EXCLUDED.url, EXCLUDED.like_count, EXCLUDED.image_url, EXCLUDED.urls, EXCLUDED.youtube_id, EXCLUDED.url_id, NOW());
ELSEIF (date(NEW.created) >= DATE '2019-02-01' AND date(NEW.created) <= DATE '2019-02-28' ) THEN
          INSERT INTO adfunnel.tweets_20190201 VALUES (NEW.*) on conflict (id, token_id) do update set (username, attachment_url, signup_form_id, text, hashtags, profile_image, web_url, chunks,  facebook_username_id, favorite_count, zipcodes, display_name, media, image_width, attachment_title, followers_count, image_height, is_retweet, retweet_count, type, token_ids, status, facebook_account_id, friends_count, comment_count, reach, token_id, plays_count, link, attachment_description, shares_count, url, like_count, image_url, urls, youtube_id, url_id, modified)   = ( EXCLUDED.username, EXCLUDED.attachment_url, EXCLUDED.signup_form_id, EXCLUDED.text, EXCLUDED.hashtags, EXCLUDED.profile_image, EXCLUDED.web_url, EXCLUDED.chunks,  EXCLUDED.facebook_username_id, EXCLUDED.favorite_count, EXCLUDED.zipcodes, EXCLUDED.display_name, EXCLUDED.media, EXCLUDED.image_width, EXCLUDED.attachment_title, EXCLUDED.followers_count, EXCLUDED.image_height, EXCLUDED.is_retweet, EXCLUDED.retweet_count, EXCLUDED.type, EXCLUDED.token_ids, EXCLUDED.status, EXCLUDED.facebook_account_id, EXCLUDED.friends_count, EXCLUDED.comment_count, EXCLUDED.reach, EXCLUDED.token_id, EXCLUDED.plays_count, EXCLUDED.link, EXCLUDED.attachment_description, EXCLUDED.shares_count, EXCLUDED.url, EXCLUDED.like_count, EXCLUDED.image_url, EXCLUDED.urls, EXCLUDED.youtube_id, EXCLUDED.url_id, NOW());
ELSEIF (date(NEW.created) >= DATE '2019-03-01' AND date(NEW.created) <= DATE '2019-03-31' ) THEN
          INSERT INTO adfunnel.tweets_20190301 VALUES (NEW.*) on conflict (id, token_id) do update set (username, attachment_url, signup_form_id, text, hashtags, profile_image, web_url, chunks,  facebook_username_id, favorite_count, zipcodes, display_name, media, image_width, attachment_title, followers_count, image_height, is_retweet, retweet_count, type, token_ids, status, facebook_account_id, friends_count, comment_count, reach, token_id, plays_count, link, attachment_description, shares_count, url, like_count, image_url, urls, youtube_id, url_id, modified)   = ( EXCLUDED.username, EXCLUDED.attachment_url, EXCLUDED.signup_form_id, EXCLUDED.text, EXCLUDED.hashtags, EXCLUDED.profile_image, EXCLUDED.web_url, EXCLUDED.chunks,  EXCLUDED.facebook_username_id, EXCLUDED.favorite_count, EXCLUDED.zipcodes, EXCLUDED.display_name, EXCLUDED.media, EXCLUDED.image_width, EXCLUDED.attachment_title, EXCLUDED.followers_count, EXCLUDED.image_height, EXCLUDED.is_retweet, EXCLUDED.retweet_count, EXCLUDED.type, EXCLUDED.token_ids, EXCLUDED.status, EXCLUDED.facebook_account_id, EXCLUDED.friends_count, EXCLUDED.comment_count, EXCLUDED.reach, EXCLUDED.token_id, EXCLUDED.plays_count, EXCLUDED.link, EXCLUDED.attachment_description, EXCLUDED.shares_count, EXCLUDED.url, EXCLUDED.like_count, EXCLUDED.image_url, EXCLUDED.urls, EXCLUDED.youtube_id, EXCLUDED.url_id, NOW());
ELSEIF (date(NEW.created) >= DATE '2019-04-01' AND date(NEW.created) <= DATE '2019-04-30' ) THEN
          INSERT INTO adfunnel.tweets_20190401 VALUES (NEW.*) on conflict (id, token_id) do update set (username, attachment_url, signup_form_id, text, hashtags, profile_image, web_url, chunks,  facebook_username_id, favorite_count, zipcodes, display_name, media, image_width, attachment_title, followers_count, image_height, is_retweet, retweet_count, type, token_ids, status, facebook_account_id, friends_count, comment_count, reach, token_id, plays_count, link, attachment_description, shares_count, url, like_count, image_url, urls, youtube_id, url_id, modified)   = ( EXCLUDED.username, EXCLUDED.attachment_url, EXCLUDED.signup_form_id, EXCLUDED.text, EXCLUDED.hashtags, EXCLUDED.profile_image, EXCLUDED.web_url, EXCLUDED.chunks,  EXCLUDED.facebook_username_id, EXCLUDED.favorite_count, EXCLUDED.zipcodes, EXCLUDED.display_name, EXCLUDED.media, EXCLUDED.image_width, EXCLUDED.attachment_title, EXCLUDED.followers_count, EXCLUDED.image_height, EXCLUDED.is_retweet, EXCLUDED.retweet_count, EXCLUDED.type, EXCLUDED.token_ids, EXCLUDED.status, EXCLUDED.facebook_account_id, EXCLUDED.friends_count, EXCLUDED.comment_count, EXCLUDED.reach, EXCLUDED.token_id, EXCLUDED.plays_count, EXCLUDED.link, EXCLUDED.attachment_description, EXCLUDED.shares_count, EXCLUDED.url, EXCLUDED.like_count, EXCLUDED.image_url, EXCLUDED.urls, EXCLUDED.youtube_id, EXCLUDED.url_id, NOW());
ELSEIF (date(NEW.created) >= DATE '2019-05-01' AND date(NEW.created) <= DATE '2019-05-31' ) THEN
          INSERT INTO adfunnel.tweets_20190501 VALUES (NEW.*) on conflict (id, token_id) do update set (username, attachment_url, signup_form_id, text, hashtags, profile_image, web_url, chunks,  facebook_username_id, favorite_count, zipcodes, display_name, media, image_width, attachment_title, followers_count, image_height, is_retweet, retweet_count, type, token_ids, status, facebook_account_id, friends_count, comment_count, reach, token_id, plays_count, link, attachment_description, shares_count, url, like_count, image_url, urls, youtube_id, url_id, modified)   = ( EXCLUDED.username, EXCLUDED.attachment_url, EXCLUDED.signup_form_id, EXCLUDED.text, EXCLUDED.hashtags, EXCLUDED.profile_image, EXCLUDED.web_url, EXCLUDED.chunks,  EXCLUDED.facebook_username_id, EXCLUDED.favorite_count, EXCLUDED.zipcodes, EXCLUDED.display_name, EXCLUDED.media, EXCLUDED.image_width, EXCLUDED.attachment_title, EXCLUDED.followers_count, EXCLUDED.image_height, EXCLUDED.is_retweet, EXCLUDED.retweet_count, EXCLUDED.type, EXCLUDED.token_ids, EXCLUDED.status, EXCLUDED.facebook_account_id, EXCLUDED.friends_count, EXCLUDED.comment_count, EXCLUDED.reach, EXCLUDED.token_id, EXCLUDED.plays_count, EXCLUDED.link, EXCLUDED.attachment_description, EXCLUDED.shares_count, EXCLUDED.url, EXCLUDED.like_count, EXCLUDED.image_url, EXCLUDED.urls, EXCLUDED.youtube_id, EXCLUDED.url_id, NOW());
ELSEIF (date(NEW.created) >= DATE '2019-06-01' AND date(NEW.created) <= DATE '2019-06-30' ) THEN
          INSERT INTO adfunnel.tweets_20190601 VALUES (NEW.*) on conflict (id, token_id) do update set (username, attachment_url, signup_form_id, text, hashtags, profile_image, web_url, chunks,  facebook_username_id, favorite_count, zipcodes, display_name, media, image_width, attachment_title, followers_count, image_height, is_retweet, retweet_count, type, token_ids, status, facebook_account_id, friends_count, comment_count, reach, token_id, plays_count, link, attachment_description, shares_count, url, like_count, image_url, urls, youtube_id, url_id, modified)   = ( EXCLUDED.username, EXCLUDED.attachment_url, EXCLUDED.signup_form_id, EXCLUDED.text, EXCLUDED.hashtags, EXCLUDED.profile_image, EXCLUDED.web_url, EXCLUDED.chunks,  EXCLUDED.facebook_username_id, EXCLUDED.favorite_count, EXCLUDED.zipcodes, EXCLUDED.display_name, EXCLUDED.media, EXCLUDED.image_width, EXCLUDED.attachment_title, EXCLUDED.followers_count, EXCLUDED.image_height, EXCLUDED.is_retweet, EXCLUDED.retweet_count, EXCLUDED.type, EXCLUDED.token_ids, EXCLUDED.status, EXCLUDED.facebook_account_id, EXCLUDED.friends_count, EXCLUDED.comment_count, EXCLUDED.reach, EXCLUDED.token_id, EXCLUDED.plays_count, EXCLUDED.link, EXCLUDED.attachment_description, EXCLUDED.shares_count, EXCLUDED.url, EXCLUDED.like_count, EXCLUDED.image_url, EXCLUDED.urls, EXCLUDED.youtube_id, EXCLUDED.url_id, NOW());
ELSEIF (date(NEW.created) >= DATE '2019-07-01' AND date(NEW.created) <= DATE '2019-07-31' ) THEN
          INSERT INTO adfunnel.tweets_20190701 VALUES (NEW.*) on conflict (id, token_id) do update set (username, attachment_url, signup_form_id, text, hashtags, profile_image, web_url, chunks,  facebook_username_id, favorite_count, zipcodes, display_name, media, image_width, attachment_title, followers_count, image_height, is_retweet, retweet_count, type, token_ids, status, facebook_account_id, friends_count, comment_count, reach, token_id, plays_count, link, attachment_description, shares_count, url, like_count, image_url, urls, youtube_id, url_id, modified)   = ( EXCLUDED.username, EXCLUDED.attachment_url, EXCLUDED.signup_form_id, EXCLUDED.text, EXCLUDED.hashtags, EXCLUDED.profile_image, EXCLUDED.web_url, EXCLUDED.chunks,  EXCLUDED.facebook_username_id, EXCLUDED.favorite_count, EXCLUDED.zipcodes, EXCLUDED.display_name, EXCLUDED.media, EXCLUDED.image_width, EXCLUDED.attachment_title, EXCLUDED.followers_count, EXCLUDED.image_height, EXCLUDED.is_retweet, EXCLUDED.retweet_count, EXCLUDED.type, EXCLUDED.token_ids, EXCLUDED.status, EXCLUDED.facebook_account_id, EXCLUDED.friends_count, EXCLUDED.comment_count, EXCLUDED.reach, EXCLUDED.token_id, EXCLUDED.plays_count, EXCLUDED.link, EXCLUDED.attachment_description, EXCLUDED.shares_count, EXCLUDED.url, EXCLUDED.like_count, EXCLUDED.image_url, EXCLUDED.urls, EXCLUDED.youtube_id, EXCLUDED.url_id, NOW());
ELSEIF (date(NEW.created) >= DATE '2019-08-01' AND date(NEW.created) <= DATE '2019-08-31' ) THEN
          INSERT INTO adfunnel.tweets_20190801 VALUES (NEW.*) on conflict (id, token_id) do update set (username, attachment_url, signup_form_id, text, hashtags, profile_image, web_url, chunks,  facebook_username_id, favorite_count, zipcodes, display_name, media, image_width, attachment_title, followers_count, image_height, is_retweet, retweet_count, type, token_ids, status, facebook_account_id, friends_count, comment_count, reach, token_id, plays_count, link, attachment_description, shares_count, url, like_count, image_url, urls, youtube_id, url_id, modified)   = ( EXCLUDED.username, EXCLUDED.attachment_url, EXCLUDED.signup_form_id, EXCLUDED.text, EXCLUDED.hashtags, EXCLUDED.profile_image, EXCLUDED.web_url, EXCLUDED.chunks,  EXCLUDED.facebook_username_id, EXCLUDED.favorite_count, EXCLUDED.zipcodes, EXCLUDED.display_name, EXCLUDED.media, EXCLUDED.image_width, EXCLUDED.attachment_title, EXCLUDED.followers_count, EXCLUDED.image_height, EXCLUDED.is_retweet, EXCLUDED.retweet_count, EXCLUDED.type, EXCLUDED.token_ids, EXCLUDED.status, EXCLUDED.facebook_account_id, EXCLUDED.friends_count, EXCLUDED.comment_count, EXCLUDED.reach, EXCLUDED.token_id, EXCLUDED.plays_count, EXCLUDED.link, EXCLUDED.attachment_description, EXCLUDED.shares_count, EXCLUDED.url, EXCLUDED.like_count, EXCLUDED.image_url, EXCLUDED.urls, EXCLUDED.youtube_id, EXCLUDED.url_id, NOW());
ELSEIF (date(NEW.created) >= DATE '2019-09-01' AND date(NEW.created) <= DATE '2019-09-30' ) THEN
          INSERT INTO adfunnel.tweets_20190901 VALUES (NEW.*) on conflict (id, token_id) do update set (username, attachment_url, signup_form_id, text, hashtags, profile_image, web_url, chunks,  facebook_username_id, favorite_count, zipcodes, display_name, media, image_width, attachment_title, followers_count, image_height, is_retweet, retweet_count, type, token_ids, status, facebook_account_id, friends_count, comment_count, reach, token_id, plays_count, link, attachment_description, shares_count, url, like_count, image_url, urls, youtube_id, url_id, modified)   = ( EXCLUDED.username, EXCLUDED.attachment_url, EXCLUDED.signup_form_id, EXCLUDED.text, EXCLUDED.hashtags, EXCLUDED.profile_image, EXCLUDED.web_url, EXCLUDED.chunks,  EXCLUDED.facebook_username_id, EXCLUDED.favorite_count, EXCLUDED.zipcodes, EXCLUDED.display_name, EXCLUDED.media, EXCLUDED.image_width, EXCLUDED.attachment_title, EXCLUDED.followers_count, EXCLUDED.image_height, EXCLUDED.is_retweet, EXCLUDED.retweet_count, EXCLUDED.type, EXCLUDED.token_ids, EXCLUDED.status, EXCLUDED.facebook_account_id, EXCLUDED.friends_count, EXCLUDED.comment_count, EXCLUDED.reach, EXCLUDED.token_id, EXCLUDED.plays_count, EXCLUDED.link, EXCLUDED.attachment_description, EXCLUDED.shares_count, EXCLUDED.url, EXCLUDED.like_count, EXCLUDED.image_url, EXCLUDED.urls, EXCLUDED.youtube_id, EXCLUDED.url_id, NOW());
ELSEIF (date(NEW.created) >= DATE '2019-10-01' AND date(NEW.created) <= DATE '2019-10-31' ) THEN
          INSERT INTO adfunnel.tweets_20191001 VALUES (NEW.*) on conflict (id, token_id) do update set (username, attachment_url, signup_form_id, text, hashtags, profile_image, web_url, chunks,  facebook_username_id, favorite_count, zipcodes, display_name, media, image_width, attachment_title, followers_count, image_height, is_retweet, retweet_count, type, token_ids, status, facebook_account_id, friends_count, comment_count, reach, token_id, plays_count, link, attachment_description, shares_count, url, like_count, image_url, urls, youtube_id, url_id, modified)   = ( EXCLUDED.username, EXCLUDED.attachment_url, EXCLUDED.signup_form_id, EXCLUDED.text, EXCLUDED.hashtags, EXCLUDED.profile_image, EXCLUDED.web_url, EXCLUDED.chunks,  EXCLUDED.facebook_username_id, EXCLUDED.favorite_count, EXCLUDED.zipcodes, EXCLUDED.display_name, EXCLUDED.media, EXCLUDED.image_width, EXCLUDED.attachment_title, EXCLUDED.followers_count, EXCLUDED.image_height, EXCLUDED.is_retweet, EXCLUDED.retweet_count, EXCLUDED.type, EXCLUDED.token_ids, EXCLUDED.status, EXCLUDED.facebook_account_id, EXCLUDED.friends_count, EXCLUDED.comment_count, EXCLUDED.reach, EXCLUDED.token_id, EXCLUDED.plays_count, EXCLUDED.link, EXCLUDED.attachment_description, EXCLUDED.shares_count, EXCLUDED.url, EXCLUDED.like_count, EXCLUDED.image_url, EXCLUDED.urls, EXCLUDED.youtube_id, EXCLUDED.url_id, NOW());
ELSEIF (date(NEW.created) >= DATE '2019-11-01' AND date(NEW.created) <= DATE '2019-11-30' ) THEN
          INSERT INTO adfunnel.tweets_20191101 VALUES (NEW.*) on conflict (id, token_id) do update set (username, attachment_url, signup_form_id, text, hashtags, profile_image, web_url, chunks,  facebook_username_id, favorite_count, zipcodes, display_name, media, image_width, attachment_title, followers_count, image_height, is_retweet, retweet_count, type, token_ids, status, facebook_account_id, friends_count, comment_count, reach, token_id, plays_count, link, attachment_description, shares_count, url, like_count, image_url, urls, youtube_id, url_id, modified)   = ( EXCLUDED.username, EXCLUDED.attachment_url, EXCLUDED.signup_form_id, EXCLUDED.text, EXCLUDED.hashtags, EXCLUDED.profile_image, EXCLUDED.web_url, EXCLUDED.chunks,  EXCLUDED.facebook_username_id, EXCLUDED.favorite_count, EXCLUDED.zipcodes, EXCLUDED.display_name, EXCLUDED.media, EXCLUDED.image_width, EXCLUDED.attachment_title, EXCLUDED.followers_count, EXCLUDED.image_height, EXCLUDED.is_retweet, EXCLUDED.retweet_count, EXCLUDED.type, EXCLUDED.token_ids, EXCLUDED.status, EXCLUDED.facebook_account_id, EXCLUDED.friends_count, EXCLUDED.comment_count, EXCLUDED.reach, EXCLUDED.token_id, EXCLUDED.plays_count, EXCLUDED.link, EXCLUDED.attachment_description, EXCLUDED.shares_count, EXCLUDED.url, EXCLUDED.like_count, EXCLUDED.image_url, EXCLUDED.urls, EXCLUDED.youtube_id, EXCLUDED.url_id, NOW());
ELSEIF (date(NEW.created) >= DATE '2019-12-01' AND date(NEW.created) <= DATE '2019-12-31' ) THEN
          INSERT INTO adfunnel.tweets_20191201 VALUES (NEW.*) on conflict (id, token_id) do update set (username, attachment_url, signup_form_id, text, hashtags, profile_image, web_url, chunks,  facebook_username_id, favorite_count, zipcodes, display_name, media, image_width, attachment_title, followers_count, image_height, is_retweet, retweet_count, type, token_ids, status, facebook_account_id, friends_count, comment_count, reach, token_id, plays_count, link, attachment_description, shares_count, url, like_count, image_url, urls, youtube_id, url_id, modified)   = ( EXCLUDED.username, EXCLUDED.attachment_url, EXCLUDED.signup_form_id, EXCLUDED.text, EXCLUDED.hashtags, EXCLUDED.profile_image, EXCLUDED.web_url, EXCLUDED.chunks,  EXCLUDED.facebook_username_id, EXCLUDED.favorite_count, EXCLUDED.zipcodes, EXCLUDED.display_name, EXCLUDED.media, EXCLUDED.image_width, EXCLUDED.attachment_title, EXCLUDED.followers_count, EXCLUDED.image_height, EXCLUDED.is_retweet, EXCLUDED.retweet_count, EXCLUDED.type, EXCLUDED.token_ids, EXCLUDED.status, EXCLUDED.facebook_account_id, EXCLUDED.friends_count, EXCLUDED.comment_count, EXCLUDED.reach, EXCLUDED.token_id, EXCLUDED.plays_count, EXCLUDED.link, EXCLUDED.attachment_description, EXCLUDED.shares_count, EXCLUDED.url, EXCLUDED.like_count, EXCLUDED.image_url, EXCLUDED.urls, EXCLUDED.youtube_id, EXCLUDED.url_id, NOW());
ELSEIF (date(NEW.created) >= DATE '2020-01-01' AND date(NEW.created) <= DATE '2020-01-31' ) THEN
          INSERT INTO adfunnel.tweets_20200101 VALUES (NEW.*) on conflict (id, token_id) do update set (username, attachment_url, signup_form_id, text, hashtags, profile_image, web_url, chunks,  facebook_username_id, favorite_count, zipcodes, display_name, media, image_width, attachment_title, followers_count, image_height, is_retweet, retweet_count, type, token_ids, status, facebook_account_id, friends_count, comment_count, reach, token_id, plays_count, link, attachment_description, shares_count, url, like_count, image_url, urls, youtube_id, url_id, modified)   = ( EXCLUDED.username, EXCLUDED.attachment_url, EXCLUDED.signup_form_id, EXCLUDED.text, EXCLUDED.hashtags, EXCLUDED.profile_image, EXCLUDED.web_url, EXCLUDED.chunks,  EXCLUDED.facebook_username_id, EXCLUDED.favorite_count, EXCLUDED.zipcodes, EXCLUDED.display_name, EXCLUDED.media, EXCLUDED.image_width, EXCLUDED.attachment_title, EXCLUDED.followers_count, EXCLUDED.image_height, EXCLUDED.is_retweet, EXCLUDED.retweet_count, EXCLUDED.type, EXCLUDED.token_ids, EXCLUDED.status, EXCLUDED.facebook_account_id, EXCLUDED.friends_count, EXCLUDED.comment_count, EXCLUDED.reach, EXCLUDED.token_id, EXCLUDED.plays_count, EXCLUDED.link, EXCLUDED.attachment_description, EXCLUDED.shares_count, EXCLUDED.url, EXCLUDED.like_count, EXCLUDED.image_url, EXCLUDED.urls, EXCLUDED.youtube_id, EXCLUDED.url_id, NOW());
ELSEIF (date(NEW.created) >= DATE '2020-02-01' AND date(NEW.created) <= DATE '2020-02-29' ) THEN
          INSERT INTO adfunnel.tweets_20200201 VALUES (NEW.*) on conflict (id, token_id) do update set (username, attachment_url, signup_form_id, text, hashtags, profile_image, web_url, chunks,  facebook_username_id, favorite_count, zipcodes, display_name, media, image_width, attachment_title, followers_count, image_height, is_retweet, retweet_count, type, token_ids, status, facebook_account_id, friends_count, comment_count, reach, token_id, plays_count, link, attachment_description, shares_count, url, like_count, image_url, urls, youtube_id, url_id, modified)   = ( EXCLUDED.username, EXCLUDED.attachment_url, EXCLUDED.signup_form_id, EXCLUDED.text, EXCLUDED.hashtags, EXCLUDED.profile_image, EXCLUDED.web_url, EXCLUDED.chunks,  EXCLUDED.facebook_username_id, EXCLUDED.favorite_count, EXCLUDED.zipcodes, EXCLUDED.display_name, EXCLUDED.media, EXCLUDED.image_width, EXCLUDED.attachment_title, EXCLUDED.followers_count, EXCLUDED.image_height, EXCLUDED.is_retweet, EXCLUDED.retweet_count, EXCLUDED.type, EXCLUDED.token_ids, EXCLUDED.status, EXCLUDED.facebook_account_id, EXCLUDED.friends_count, EXCLUDED.comment_count, EXCLUDED.reach, EXCLUDED.token_id, EXCLUDED.plays_count, EXCLUDED.link, EXCLUDED.attachment_description, EXCLUDED.shares_count, EXCLUDED.url, EXCLUDED.like_count, EXCLUDED.image_url, EXCLUDED.urls, EXCLUDED.youtube_id, EXCLUDED.url_id, NOW());
ELSEIF (date(NEW.created) >= DATE '2020-03-01' AND date(NEW.created) <= DATE '2020-03-31' ) THEN
          INSERT INTO adfunnel.tweets_20200301 VALUES (NEW.*) on conflict (id, token_id) do update set (username, attachment_url, signup_form_id, text, hashtags, profile_image, web_url, chunks,  facebook_username_id, favorite_count, zipcodes, display_name, media, image_width, attachment_title, followers_count, image_height, is_retweet, retweet_count, type, token_ids, status, facebook_account_id, friends_count, comment_count, reach, token_id, plays_count, link, attachment_description, shares_count, url, like_count, image_url, urls, youtube_id, url_id, modified)   = ( EXCLUDED.username, EXCLUDED.attachment_url, EXCLUDED.signup_form_id, EXCLUDED.text, EXCLUDED.hashtags, EXCLUDED.profile_image, EXCLUDED.web_url, EXCLUDED.chunks,  EXCLUDED.facebook_username_id, EXCLUDED.favorite_count, EXCLUDED.zipcodes, EXCLUDED.display_name, EXCLUDED.media, EXCLUDED.image_width, EXCLUDED.attachment_title, EXCLUDED.followers_count, EXCLUDED.image_height, EXCLUDED.is_retweet, EXCLUDED.retweet_count, EXCLUDED.type, EXCLUDED.token_ids, EXCLUDED.status, EXCLUDED.facebook_account_id, EXCLUDED.friends_count, EXCLUDED.comment_count, EXCLUDED.reach, EXCLUDED.token_id, EXCLUDED.plays_count, EXCLUDED.link, EXCLUDED.attachment_description, EXCLUDED.shares_count, EXCLUDED.url, EXCLUDED.like_count, EXCLUDED.image_url, EXCLUDED.urls, EXCLUDED.youtube_id, EXCLUDED.url_id, NOW());
ELSEIF (date(NEW.created) >= DATE '2020-04-01' AND date(NEW.created) <= DATE '2020-04-30' ) THEN
          INSERT INTO adfunnel.tweets_20200401 VALUES (NEW.*) on conflict (id, token_id) do update set (username, attachment_url, signup_form_id, text, hashtags, profile_image, web_url, chunks,  facebook_username_id, favorite_count, zipcodes, display_name, media, image_width, attachment_title, followers_count, image_height, is_retweet, retweet_count, type, token_ids, status, facebook_account_id, friends_count, comment_count, reach, token_id, plays_count, link, attachment_description, shares_count, url, like_count, image_url, urls, youtube_id, url_id, modified)   = ( EXCLUDED.username, EXCLUDED.attachment_url, EXCLUDED.signup_form_id, EXCLUDED.text, EXCLUDED.hashtags, EXCLUDED.profile_image, EXCLUDED.web_url, EXCLUDED.chunks,  EXCLUDED.facebook_username_id, EXCLUDED.favorite_count, EXCLUDED.zipcodes, EXCLUDED.display_name, EXCLUDED.media, EXCLUDED.image_width, EXCLUDED.attachment_title, EXCLUDED.followers_count, EXCLUDED.image_height, EXCLUDED.is_retweet, EXCLUDED.retweet_count, EXCLUDED.type, EXCLUDED.token_ids, EXCLUDED.status, EXCLUDED.facebook_account_id, EXCLUDED.friends_count, EXCLUDED.comment_count, EXCLUDED.reach, EXCLUDED.token_id, EXCLUDED.plays_count, EXCLUDED.link, EXCLUDED.attachment_description, EXCLUDED.shares_count, EXCLUDED.url, EXCLUDED.like_count, EXCLUDED.image_url, EXCLUDED.urls, EXCLUDED.youtube_id, EXCLUDED.url_id, NOW());
ELSEIF (date(NEW.created) >= DATE '2020-05-01' AND date(NEW.created) <= DATE '2020-05-31' ) THEN
          INSERT INTO adfunnel.tweets_20200501 VALUES (NEW.*) on conflict (id, token_id) do update set (username, attachment_url, signup_form_id, text, hashtags, profile_image, web_url, chunks,  facebook_username_id, favorite_count, zipcodes, display_name, media, image_width, attachment_title, followers_count, image_height, is_retweet, retweet_count, type, token_ids, status, facebook_account_id, friends_count, comment_count, reach, token_id, plays_count, link, attachment_description, shares_count, url, like_count, image_url, urls, youtube_id, url_id, modified)   = ( EXCLUDED.username, EXCLUDED.attachment_url, EXCLUDED.signup_form_id, EXCLUDED.text, EXCLUDED.hashtags, EXCLUDED.profile_image, EXCLUDED.web_url, EXCLUDED.chunks,  EXCLUDED.facebook_username_id, EXCLUDED.favorite_count, EXCLUDED.zipcodes, EXCLUDED.display_name, EXCLUDED.media, EXCLUDED.image_width, EXCLUDED.attachment_title, EXCLUDED.followers_count, EXCLUDED.image_height, EXCLUDED.is_retweet, EXCLUDED.retweet_count, EXCLUDED.type, EXCLUDED.token_ids, EXCLUDED.status, EXCLUDED.facebook_account_id, EXCLUDED.friends_count, EXCLUDED.comment_count, EXCLUDED.reach, EXCLUDED.token_id, EXCLUDED.plays_count, EXCLUDED.link, EXCLUDED.attachment_description, EXCLUDED.shares_count, EXCLUDED.url, EXCLUDED.like_count, EXCLUDED.image_url, EXCLUDED.urls, EXCLUDED.youtube_id, EXCLUDED.url_id, NOW());

      ELSE
          RAISE EXCEPTION 'Bigtable insert date is out of range!';
      END IF;

      RETURN NULL;
  END;
  $$
  LANGUAGE plpgsql;

  CREATE TRIGGER tweets_insert_trigger BEFORE INSERT ON adfunnel.tweets FOR EACH ROW EXECUTE PROCEDURE tweets_insert_function();

  
