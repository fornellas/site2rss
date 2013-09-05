require 'rss'

module Site2RSS
  attr_reader :title
  attr_reader :link
  attr_reader :about
  attr_reader :author
  def generate
    rss = RSS::Maker.make('atom') do |maker|
      maker.channel.title = title
      maker.channel.author = author
      maker.channel.link = link
      maker.channel.about = about
      maker.channel.updated = Time.now
      items.each do |new_item|
        maker.items.new_item do |item|
          item.title = new_item['title']
          item.link = new_item['link']
          item.description = new_item['description']
          item.updated = Time.now
        end
      end
    end
    puts rss
  end
end
