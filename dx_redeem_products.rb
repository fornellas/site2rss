require_relative 'site2rss'
require 'mechanize'

class DXRedeemProducts
  @title = 'Deal Extreme - Redeem Products'
  @link = 'http://dx.com/redeem-points'
  @about = 'Redeem Products'
  @author = 'Fabio Pugliese Ornellas'
  class << self
    include Site2RSS
    def items
      agent ||= Mechanize.new
      items = Array.new
      products = agent.get('http://dx.com/redeem-points').parser.css('div.points_list').css('li')
      if products.size == 0
        raise "Failed to parse HTML."
      end
      products.each  do |li|
        item = Hash.new
        item['title'] = li.css('h3').css('a')[0].text
        item['link'] = 'http://dx.com/' + li.css('h3').css('a')[0]['href']
        image = 'http:' + li.css('div.pic').css('img')[0]['src']
        price = li.css('div.clearfix').css('div.price').css('del')[0].text.strip
        points = li.css('div.clearfix').css('div.price').css('h4')[0].text.strip
        item['description'] = '<a href="' + item['link'] + '">' + '<img alt="Product" src="' + image + '">' + '</a><br>' + points + '&nbsp;points<br>' + price
        items.push item
      end
      items
    end
  end
end

DXRedeemProducts.generate
