require_relative 'site2rss'
require 'mechanize'

class BangGoodRCToysAndHobbies
  @title = 'Banggood RC Toys & Hobbies'
  @link = 'http://www.banggood.com/new-arrivals-c-1729-0-28-6.html'
  @about = 'Banggood RC Toys & Hobbies New Products'
  @author = 'Fabio Pugliese Ornellas'
  class << self
    include Site2RSS
    def items
      agent ||= Mechanize.new
      items = Array.new
      for p in 1..4
        products = agent.get('http://www.banggood.com/new-arrivals-c-1729-0-36-6-page' + p.to_s + '.html').parser.css('div.best').css('li')
        if products.size == 0
          raise "Failed to parse HTML."
        end
        products.each do |li|
          item = Hash.new
          item['title'] = li.css('a.name').text
          item['link'] = li.css('a.name')[0]['href']
          image = li.css('div.pic').css('img')[0]['src']
          price = li.css('a.pri02').text
          item['description'] = '<div><a href="' + item['link'] + '">' + '<img alt="Product" src="' + image + '"><br><b>' + price + '</b>' + '</a></div>'
          items.push item
        end
      end
      items
    end
  end
end

BangGoodRCToysAndHobbies.generate
