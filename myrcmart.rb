require_relative 'site2rss'
require 'mechanize'

class MyRCMart
  @title = 'MyRCMart'
  @link = 'http://www.myrcmart.com/products_new.php?page=1'
  @about = 'New Products'
  @author = 'Fabio Pugliese Ornellas'
  class << self
    include Site2RSS
    def items
      agent ||= Mechanize.new
      items = Array.new
      for p in 1..1
        products = agent.get('http://www.myrcmart.com/products_new.php?page=' + p.to_s).parser.css('table').css('tr').css('td').css('table').css('tr').css('table').css('tr')
        if products.size == 0
          raise "Failed to parse HTML."
        end
        products.each  do |td|
          p = td.css('td.main')
          next if 0 == p.size
          item = Hash.new
          item['title'] = p.css('u').text
          item['link'] = p.css('a')[0]['href']
          image = 'http://www.myrcmart.com/' + p.css('img.prodThumb')[0]['src']
          price = p.css('td.main')[1]
          price.css('a').remove 
          item['description'] = '<a href="' + item['link'] + '">' + '<img alt="Product" src="' + image + '">' + '</a><br>' + price
          items.push item
        end
      end
      items
    end
  end
end

MyRCMart.generate
