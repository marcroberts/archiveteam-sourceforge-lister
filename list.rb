require 'rubygems'
require 'bundler'

Bundler.require

require 'open-uri'


page = 0

max = 17778

mutex = Mutex.new

projects = File.open('projects.txt', 'a')

threads = 4

def fetch_page n, io
  STDERR.print "Listing page #{n}\n"

  html = open("http://sourceforge.net/directory/?sort=name&page=#{n}")

  doc = Nokogiri::HTML(html)
  doc.css('ul.projects a.project-icon').each do |link|
    io.write "http://sourceforge.net#{link['href'].gsub(/\/\?.*/, '/')}\n"
  end
  io.flush

rescue
  sleep 5
  retry
end



threads.times.map do

  Thread.new do
    begin
      thread_page = mutex.synchronize{ page = page + 1 }

      fetch_page thread_page, projects

    end while thread_page <= max
  end

end.each(&:join)
