require_relative 'site2rss'
require 'mechanize'

class ElecFreaks
  @title = 'ElecFreaks'
  @link = 'http://www.elecfreaks.com/store/products_all.html?page=1&disp_order=6'
  @about = 'New products'
  @author = 'Fabio Pugliese Ornellas'
  class << self
    include Site2RSS
    def items
      agent ||= Mechanize.new
      items = Array.new
      for p in 1..5
        agent.get('http://www.elecfreaks.com/store/products_all.html?disp_order=6&page=' + p.to_s)
        products = agent.page.parser.css('tr.productListing-odd').css('td')
        if products.size == 0
          raise "Failed to parse HTML."
        end
        while products.size >= 3
          item = Hash.new
          item['title'] = products[1].css('a').css('strong')[0].text
          item['link'] = products[0].css('a')[0]['href'].split('?')[0]
          image = products[0].css('a img')[0]['src']
          text = products[2].children[0].text
          price = products[1].children[5].text
          item['description'] = '<a href="' + item['link'] + '">' + '<img alt="Proto-little" src="' + image + '">' + '</a><br>' + price + '<br>' + text
          items.push item
          products = products.drop(3)
        end
      end
      items
    end
  end
end

ElecFreaks.generate
