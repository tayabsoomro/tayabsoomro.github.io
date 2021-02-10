require 'feedjira'
require 'httparty'
require 'nokogiri'
require 'jekyll-timeago'
include Jekyll::Timeago

module Jekyll
  class MediumPostDisplay < Generator
    safe true
    priority :high
def generate(site)
      jekyll_coll = Jekyll::Collection.new(site, 'external_feed')
      site.collections['external_feed'] = jekyll_coll
xml = HTTParty.get("https://medium.com/feed/@tayabsoomro").body
feed = Feedjira.parse(xml)
feed.entries.each do |e|
        title = e[:title]
        content = e[:content]
        guid = e[:guid]
        link = e[:url]
        pubDate = e[:published]
        path = "./_external_feed/" + title + ".md"
        path = site.in_source_dir(path)
        doc = Jekyll::Document.new(path, { :site => site, :collection => jekyll_coll })
        doc.data['title'] = title;
        doc.data['feed_content'] = content;
        doc.data['link'] = link
        doc.data['pubDate'] = Jekyll::Timeago.timeago(pubDate, to = Date.today, options = {locale: :en})
        doc.data['cover_img'] = Nokogiri::HTML(content).xpath("//img")[0]
        jekyll_coll.docs << doc
      end
    end
  end
end
