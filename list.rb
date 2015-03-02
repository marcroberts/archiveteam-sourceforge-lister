require 'rubygems'
require 'bundler'

Bundler.require

require 'open-uri'


page = 1

begin

  STDERR.print "Listing page #{page}\n"

  html = open("http://sourceforge.net/directory/?sort=name&page=#{page}").read

  doc = Nokogiri::HTML(html)
  doc.css('ul.projects a.project-icon').each do |link|
    print "http://sourceforge.net#{link['href'].gsub(/\/\?.*/, '/')}\n"
  end

  page += 1

  sleep 0.3

end while page < 17778 #
