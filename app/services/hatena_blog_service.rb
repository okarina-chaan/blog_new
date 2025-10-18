require 'net/http'
require 'nokogiri'

class HatenaBlogService
  BASE_URL = "https://blog.hatena.ne.jp"
 
  def initialize
    @username = ENV['HATENA_USERNAME']
    @blog_id = ENV['HATENA_BLOG_ID']
    @api_key = ENV['HATENA_API_KEY']
  end

  def fetch_articles(limit: 10)
    uri = URI.parse(atom_url)
    request = Net::HTTP::Get.new(uri)
    request.basic_auth(ENV['HATENA_USERNAME'], ENV['HATENA_API_KEY'])

    http = Net::HTTP.new(uri.hostname, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE if Rails.env.development?
    
    response = http.request(request)

    unless response.is_a?(Net::HTTPSuccess)
      Rails.logger.error("Hatena API Error: #{response.code} #{response.message}")
      return []
    end

    parse_articles(response.body).first(limit)
  rescue => e
    Rails.logger.error("HatenaClient Error: #{e.message}")
    []
  end

  private

  def atom_url
    "#{BASE_URL}/#{@username}/#{@blog_id}/atom/entry"
  end

  def parse_articles(xml_body)
    doc = Nokogiri::XML(xml_body)
    
    entries = doc.xpath('//atom:entry', 'atom' => 'http://www.w3.org/2005/Atom')

    entries.map do |entry|
      {
        title: entry.at_xpath('atom:title', 'atom' => 'http://www.w3.org/2005/Atom')&.text,
        url: entry.at_xpath('atom:link[@rel="alternate"]', 'atom' => 'http://www.w3.org/2005/Atom')&.[]('href'),
        published_at: entry.at_xpath('atom:published', 'atom' => 'http://www.w3.org/2005/Atom')&.text,
      }
    end
  rescue => e
    Rails.logger.error("ParseArticles Error: #{e.message}")
    []
  end
end
