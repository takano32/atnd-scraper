#!/usr/bin/env ruby

require_relative './atnd'

event_ids = [
  25836, # InnoDB Deep Talk #1
  33779, # ぐだぐだMySQL
  37387, # MyNA(日本MySQLユーザ会)会 2013年3月
  48639, # MyNA(日本MySQLユーザ会)会 2014年4月
]

users = []
event_ids.each do |event_id|
  e = ATND::Scraper::Event.new(event_id)
  e.scrape
  users += e.users
end

twitter_ids = []
users.each do |user|
  next unless user[:twitter]
  twitter_ids << user[:twitter]
end

twitter_ids.uniq.each do |twitter_id|
  puts twitter_id
end

