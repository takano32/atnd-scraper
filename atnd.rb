#!/usr/bin/env ruby

require 'nokogiri'
require 'open-uri'

module ATND; end
module ATND::Scraper; end

class ATND::Scraper::Event
  def initialize(id)
    @id = id
    uri = URI.parse "https://atnd.org/events/#{id}"
    @doc = Nokogiri::HTML(open uri)
    @users = []
  end

  def scrape
    @doc.xpath("//section[@id='members-join']").each do |user_link|
      p user_link
    end
  end
end

if __FILE__ == $0 then
  e = ATND::Scraper::Event.new(25836)
  e.scrape
end

