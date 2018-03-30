import sys
import os
import time
import json
import collections


import psycopg2
import psycopg2.extras
from psycopg2.extras import Json
class SQL(object):

  def __init__(self, connection_string = None, cursor=False):
    self.keys = None
    self.rows = []
    self.use_cursor = cursor
    self.N = 2000

  def remove_nulls_if_string(self,value):
    if type(value) == type('') or type(value) == type(u''):
      return value.replace('\0','')
    return value


  def remove_duplicates(self,rowdict_array, key):
    ret = {}
    for row in rowdict_array:
      ret[row[key]] = row
    return ret.values()

  def write_later(self, data):
    self.rows.append(data)
    if len(self.rows) == self.N:
      self.write_all()

  def write_all(self):
    if self.rows:
      self.write_many(self.tablename, self.rows)
    self.rows = []
  def close(self):
    self.con.close()

  def connect(self):
    username=os.getlogin()
    password=open("db_password").read().strip() 
    self.connection_string = "postgresql://{username}:{password}@localhost/postgres".format(username=username,password=password)
    self.con = psycopg2.connect(self.connection_string)
    if hasattr(self, 'use_cursor') and self.use_cursor:
      self.cursor = self.con.cursor('sscursor', cursor_factory=psycopg2.extras.DictCursor) # is server side cursor because we give it a name
      self.cursor.itersize = 8096
    else:
      self.cursor = self.con.cursor(cursor_factory=psycopg2.extras.DictCursor) # is server side cursor because we give it a name
    return self.con

  def raw(self, sql):
      self.connect()
      self.cursor.execute(sql)
      self.con.commit()


  def read_raw(self, sql, values=None):
    #self.use_cursor = True
    self.connect()
    if not values:
      self.cursor.execute(sql)
    else:
      self.cursor.execute(sql, values)
    for item in self.cursor:
      yield dict(item)
    self.con.commit()

  def onconflict(self, keys):
    return ' ON CONFLICT DO NOTHING'

  def read_by_id(self, tablename, where):
    self.connect()
    sql = "select * from {} where id = {} ".format(tablename,where)
    self.cursor.execute(sql)
    for item in self.cursor:
      yield item



  def read_not_null(self, tablename, where=[], true_values = [], false_values = [] ):
    self.use_cursor = True
    self.connect()
    sql = "select * from {} where ".format(tablename)
    clauses = []
    for field in where:
      clauses += ["{} is not null or {} != ''".format(field, field)]
    for field in true_values:
      clauses += ["{}  = 1".format(field)]
    for field in false_values:
      clauses += ["{}  = 0".format(field)]
    sql = sql + " AND ".join(clauses)
    self.cursor.execute(sql)
    for item in self.cursor:
      yield item



  def read_all(self, tablename=None, fields = '*'):
    self.use_cursor = True
    if not tablename:
      tablename = self.tablename
    self.connect()
    sql = "select {fields} from {tablename} ;".format(tablename =tablename, fields = fields)
    self.cursor.execute(sql)
    for item in self.cursor:
      yield item


  def read_where(self, tablename, where={}):
    self.connect()
    sql = "select * from {} where ".format(tablename)
    where_value_clauses = []
    tmp_where_clauses = [] 
    for key,val in where.items():
      tmp_where_clauses.append("{} like %s ".format(key))
      where_value_clauses.append(val)
    sql = sql + " AND ".join(tmp_where_clauses)
    sql += " Order by id ASC"
    self.cursor.execute(sql, where_value_clauses)
    for item in self.cursor:
      yield item

  def build_insert(self, tablename, rowdict_array):
      con = self.connect()
      keys = map(self.remove_nulls_if_string, rowdict_array[0].keys())# assuming homogenious
      columns = ", ".join(keys)
      sql = "insert into %s (%s) values" % ( tablename, columns)
      values_template = "(" + ", ".join(["%s"] * len(keys)) + ")"
      sql += ", ".join([values_template]*len(rowdict_array))
      sql += self.onconflict(keys)
      for rowdict in rowdict_array:
        for key in keys:
          rowdict[key] = rowdict.get(key) # make sure all keys are set homogenously

      values = [self.remove_nulls_if_string(item[key]) for item in rowdict_array for key in keys ] #val in item.values() ]
      return sql, values

  def write_one_get_id(self, tablename, row):
    rowdict_array = [ row ]
    return self.write_many_get_ids(tablename, rowdict_array)[0]

  def write_many_get_fields(self, tablename, rowdict_array, fields):
      sql, values = self.build_insert( tablename, rowdict_array)
      sql = sql + " returning " + ", ".join(fields) + " ;"
      self.cursor.execute(sql, values)
      print self.cursor.mogrify(sql, values)[0:100]
      ret = []
      for item in self.cursor:
        ret.append(dict(item))
      self.con.commit()
      return ret
  def write_many_get_ids(self, tablename, rowdict_array):
      sql, values = self.build_insert( tablename, rowdict_array)
      sql = sql + " returning id"
      self.cursor.execute(sql, values)
      ret = []
      for item in self.cursor:
        ret.append(item[0])
      self.con.commit()
      return ret

  def filter(self,rowdict_array):
      if not self.keys:
        return rowdict_array
      data = {}
      for row in rowdict_array:
        key = tuple(map(lambda k: row.get(k), self.keys))
        data[key] = row
      return data.values()


  def write_many_mogrify(self, tablename, rowdict_array):
      if not rowdict_array:
        return
      rowdict_array = self.filter(rowdict_array)
      sql, values = self.build_insert( tablename, rowdict_array)
      return  self.cursor.mogrify(sql, values)

  def write_many(self, tablename, rowdict_array):
      if not rowdict_array:
        return
      rowdict_array = self.filter(rowdict_array)
      sql, values = self.build_insert( tablename, rowdict_array)
      self.cursor.execute(sql, values)
      #print self.tablename, self.cursor.mogrify(sql, values)[0:100]
      self.con.commit()



  def write(self, tablename, rowdict):
      # XXX tablename not sanitized
      # XXX test for allowed keys is case-sensitive
      self.connect()
      keys = rowdict.keys()

      columns = ", ".join(keys)
      values_template = ", ".join(["%s"] * len(keys))

      sql = "insert into %s (%s) values (%s) ON CONFLICT DO NOTHING" % (
          tablename, columns, values_template)
      values = tuple(rowdict[key] for key in keys)
      self.cursor.execute(sql, values)
      self.con.commit()
class Generic(SQL):
  def __init__(self, tablename, connection_string = None):
    self.rows = []
    self.keys = None
    self.N = 100
    self.tablename = tablename
    self.connection_string = connection_string

  def onconflict(self, keys):
    keys_comma = ", ".join(keys + [ 'modified'] )
    excludeds = [' EXCLUDED.{key}'.format(key=key) for key in keys] + ["NOW()"]
    excludeds = ' , '.join(excludeds)
    return ' on conflict (id) do update set (' + keys_comma + ")   = (" + excludeds + ") "
  

class DatePartition(Generic):
  
  def __init__(self, tablename=None, connection_string = None):
    self.rows_dates = collections.defaultdict(list)
    self.tablename = tablename
    super(Generic, self).__init__(tablename,connection_string)
    self.connection_string = connection_string

  def write_later(self, data):
    #vision2.tweets_analytics_partition_20170801
    created = data['created']
    table_date_shorthand = "{}{}01".format(created.year, str(created.month).zfill(2))
    table_name = "{table_name}_{table_date}".format(table_name=self.tablename, table_date = table_date_shorthand)


    self.rows_dates[table_name].append(data)
    if len(self.rows_dates[table_name]) == self.N:
      self.write_all()

  def write_all_mogrify(self):
    for table_name in self.rows_dates:
      if self.rows_dates[table_name]:
        yield self.write_many_mogrify(table_name, self.rows_dates[table_name])
        self.rows_dates[table_name] = []
    self.rows = []


  def write_all(self):
    for table_name in self.rows_dates:
      if self.rows_dates[table_name]:
        self.write_many(table_name, self.rows_dates[table_name])
        self.rows_dates[table_name] = []
    self.rows = []


class Tweet(DatePartition):
  def onconflict(self, keys):
    keys_comma = ", ".join(keys + [ 'modified'] )
    excludeds = [' EXCLUDED.{key}'.format(key=key) for key in keys] + ["NOW()"]
    excludeds = ' , '.join(excludeds)
    return ' on conflict (id, organization_id) do nothing' #update set (' + keys_comma + ")   = (" + excludeds + ") ;"

  def write_all(self):
    for table_name in self.rows_dates:
      if self.rows_dates[table_name]:
        self.write_many(table_name, self.rows_dates[table_name])
        self.rows_dates[table_name] = []
    self.rows = []

class TweetStats(DatePartition):
  def write_many(self, tablename, rowdict_array):
      nodupes = self.remove_duplicates(rowdict_array,'post_id')
      sql, values = self.build_insert( tablename, self.remove_duplicates(rowdict_array,'post_id'))
      self.cursor.execute(sql, values)
      print self.tablename, self.cursor.mogrify(sql, values)[0:100]
      self.con.commit()

  def onconflict(self, keys):
    keys_comma = ", ".join(keys)
    excludeds = [' EXCLUDED.{key}'.format(key=key) for key in keys]
    excludeds = ' , '.join(excludeds)
    return ' on conflict (post_id)  do update set (' + keys_comma + ")   = (" + excludeds + ") ;"





class Tokens(Generic):
  def onconflict(self, keys):
    keys_comma = ", ".join(keys + [ 'modified'] )
    excludeds = [' EXCLUDED.{key}'.format(key=key) for key in keys] + ["NOW()"]
    excludeds = ' , '.join(excludeds)
    return ' on conflict (title, ticker) do update set (' + keys_comma + ")   = (" + excludeds + ") ;"


