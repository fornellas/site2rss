require_relative 'site2rss'
require 'mechanize'

class KickstarterTechnology
  @title = 'Kickstarter Technology'
  @link = 'http://www.kickstarter.com/discover/categories/technology/popular?page=1'
  @about = 'Kickstarter Technology Projects'
  @author = 'Fabio Pugliese Ornellas'
  class << self
    include Site2RSS
    def items
      agent ||= Mechanize.new
      items = Array.new
      for p in 1..4
        projects = agent.get('http://www.kickstarter.com/discover/categories/technology/popular?page=' + p.to_s).parser.css('li.project')
        if projects.size == 0
          raise "Failed to parse HTML."
        end
        projects.each  do |li|
          item = Hash.new
          item['title'] = li.css('h2.bbcard_name').css('strong').css('a').text
          item['link'] = 'http://www.kickstarter.com/' + li.css('div.project-thumbnail').css('a')[0]['href']
          image = li.css('div.project-thumbnail').css('img')[0]['src']
          text = li.css('p.bbcard_blurb').text
          item['description'] = '<a href="' + item['link'] + '">' + '<img align="top" alt="Proto-little" src="' + image + '">' + '</a><br>' + text
          items.push item
        end
      end
      items
    end
  end
end

KickstarterTechnology.generate
