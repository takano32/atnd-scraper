#!/usr/bin/env ruby

require 'open-uri'

require 'rubygems'
require 'nokogiri'
require 'parallel'

module ATND; end
module ATND::Scraper; end

class ATND::Scraper::Event
  attr_reader :users

  def initialize(id)
    @id = id
    @uri = URI.parse "https://atnd.org/events/#{id}"
    @doc = Nokogiri::HTML(open @uri)
    @users = []
  end

  def scrape
    user_ids =[]
    @doc.xpath("//section[@id='members-join']/ol/li/span/a").each do |user_link|
      user_path = user_link[:href]
      next unless user_path
      next unless user_path =~ %r!/users/([0-9]+)!
      user_ids << $1.to_i
    end

    Parallel.each(user_ids, in_threads: 10) do |user_id|
      u = ATND::Scraper::User.new(user_id)
      user = u.scrape
      @users << user
    end
  end
end

class ATND::Scraper::User
  def initialize(id)
    @id = id
  end

  def scrape
    user = {id: @id}
    uri = "https://atnd.org/users/#{@id}"
    doc = Nokogiri::HTML(open uri)
    doc.xpath("//div[@id='users-show-info']/dl/dd/a").each do |links|
      link = links[:href]
      if link =~ %r!http://twitter.com/(.+)!
        user[:twitter] = $1
      end
    end
    user
  end
end

if __FILE__ == $0 then
  e = ATND::Scraper::Event.new(25836)
  e.scrape
  e.users.each do |user|
    next unless user[:twitter]
    puts user[:twitter]
  end
end

