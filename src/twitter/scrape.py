import datetime
import time
import sys
import traceback
import random
import json
import tweepy
from dateutil.parser import parse as parse_date


import sql
sql_client = sql.SQL()
write_tweets = sql.Tweet()
write_tweets.tablename = 'adfunnel.tweets'
api_credentials = json.loads(open("../api_credentials.json").read())
#print client.user_timeline(username,count=200, tweet_mode='extended')

def get_client():
  key = random.choice(api_credentials)
  auth = tweepy.AppAuthHandler(key['key'], key['secret'])
  client = tweepy.API(auth, wait_on_rate_limit=True,
                     wait_on_rate_limit_notify=True)
    
  return client

def write_format(tweet, organization_id):
    cutoff =  datetime.datetime.now()-datetime.timedelta(weeks=1)
    data = {}
    data['id'] = tweet.id
    data['token_id'] = organization_id
    data['type'] = 'tweet'
    data['url_id'] = None
    data['text'] = tweet.full_text
    full_text = tweet._json.get('retweeted_status',{}).get("full_text")
    if full_text:
      data['text'] = "RT " + tweet.full_text[3:].split(" ")[0] + " " + full_text
    data['favorite_count'] = tweet.favorite_count
    data['retweet_count'] = tweet.retweet_count
    data['created'] = tweet.created_at

    #if data['created'] < cutoff:
      #continue

    data['username'] = tweet.user.screen_name
    data['followers_count'] = tweet.user.followers_count
    data['friends_count'] = tweet.user.friends_count
    data['profile_image']  = tweet.user.profile_image_url
    data['display_name'] = tweet.user.name

    hashtags = []

    data['hashtags'] = filter(None, [x.get('text') for x in tweet.entities['hashtags'] ])

    urls = []
    for twt_urls in tweet.entities['urls']:
      urls.append(twt_urls.get('expanded_url'))
    data['urls'] = filter(None, urls)

    data['media'] = []
    for twt_media in tweet.entities.get('media',[]):
      data['media'].append(twt_media['media_url_https'])

    data['is_retweet'] = tweet.retweeted
    return data


def scrape(row):
  max_tweets = 100
  client = get_client()
  query = "{} OR ${}".format(row['title'], row['ticker'])
  for status in tweepy.Cursor(client.search, q=query, tweet_mode='extended').items(max_tweets):
    writeme = write_format(status, row['id'])
    write_tweets.write_later(writeme)
  write_tweets.write_all()

def main(limit_arg):
  limit=""
  if limit_arg:
    limit = "limit " + limit_arg
  print 'limit', limit
  while True:
    for row in sql_client.read_raw( "select id , title, ticker from adfunnel.tokens order by id asc "+limit):
      try:
        print row
        scrape(row)
      except Exception as oops:
        print oops
        traceback.print_stack()
    time.sleep(30)

if __name__=="__main__":
  if len(sys.argv)==1:
    limit = None
  else:
    limit = sys.argv[1]
  main(limit)


