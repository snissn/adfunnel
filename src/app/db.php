<?php

// Report all PHP errors


  $pw = file_get_contents("db_password");
  $db_connection = pg_connect("host=localhost dbname=postgres user=mike password=$pw");


function get_trending(){
  global $db_connection;
  $ret =[];
  $days = 1;
  $sql = "select sum(favorite_count), count(*), tokens.* from adfunnel.tweets join adfunnel.tokens on tokens.id = tweets.token_id where tweets.created  >= NOW() - '$days days'::INTERVAL  group by tokens.id order by 1 desc;";
  $result = pg_query($db_connection, $sql);
  while($row = pg_fetch_assoc($result)){
    $ret[] = $row;
  }
  return $ret;

}



function get_coin_info($id){
  global $db_connection;
  $sql = 'select * from  adfunnel.tokens where id = $1;';
  $result = pg_query_params($db_connection, $sql, [$id]);
  while($row = pg_fetch_assoc($result)){
    return $row;
  }
}

function get_tweets($id){
  global $db_connection;
  $ret =[];
  $sql = 'select * from  adfunnel.tweets where tweets.created  >= NOW() - \'1 days\'::INTERVAL  and token_id = $1  order by log(coalesce(favorite_count,0)+1) - extract(epoch from (now() - tweets.created))/604800  desc limit 100;';
  $result = pg_query_params($db_connection, $sql, [$id]);
  while($row = pg_fetch_assoc($result)){
    $ret[] = $row;
  }
  return $ret;

}
