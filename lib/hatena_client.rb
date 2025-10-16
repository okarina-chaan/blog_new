# lib/hatena_client.rb
require "net/http"
require "uri"
require "nokogiri"
require "time"

class HatenaClient
  HATENA_ATOM_URL = "https://blog.hatena.ne.jp/#{ENV['HATENA_USERNAME']}/#{ENV['HATENA_BLOG_ID']}/atom/entry"

  def self.fetch_articles(limit: 10)
    uri = URI.parse(HATENA_ATOM_URL)
    request = Net::HTTP::Get.new(uri)
    request.basic_auth(ENV["HATENA_USERNAME"], ENV["HATENA_API_KEY"])

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(request) }

    unless response.is_a?(Net::HTTPSuccess)
      Rails.logger.error("Hatena API Error: #{response.code} #{response.message}")
      return []
    end

    parse_articles(response.body).first(limit)
  rescue => e
    Rails.logger.error("HatenaClient Error(fetch_articles): #{e.class} #{e.message}")
    []
  end

  def self.fetch_article(entry_id)
    uri = URI.parse("#{HATENA_ATOM_URL}/#{entry_id}")
    request = Net::HTTP::Get.new(uri)
    request.basic_auth(ENV["HATENA_USERNAME"], ENV["HATENA_API_KEY"])

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(request) }

    return nil unless response.is_a?(Net::HTTPSuccess)
    parse_article(response.body)
  rescue => e
    Rails.logger.error("HatenaClient Error(fetch_article): #{e.class} #{e.message}")
    nil
  end

  private

  # XMLから記事リストを取り出す（ハッシュ配列で返す）
  def self.parse_articles(xml_data)
    doc = Nokogiri::XML(xml_data)
    entries = []
    doc.xpath("//xmlns:entry").each do |entry|
      entries << {
        title:        entry.at_xpath("xmlns:title")&.text,
        content:      entry.at_xpath("xmlns:content")&.text,
        published_at: parse_time(entry.at_xpath("xmlns:published")&.text),
        url:          entry.at_xpath("xmlns:link[@rel='alternate']")&.[]("href")
      }
    end
    entries
  end

  # XMLから個別記事を取り出す（ハッシュで返す）
  def self.parse_article(xml_data)
    doc = Nokogiri::XML(xml_data)
    entry = doc.at_xpath("//xmlns:entry")
    return nil unless entry

    {
      title:        entry.at_xpath("xmlns:title")&.text,
      content:      entry.at_xpath("xmlns:content")&.text,
      published_at: parse_time(entry.at_xpath("xmlns:published")&.text),
      url:          entry.at_xpath("xmlns:link[@rel='alternate']")&.[]("href")
    }
  end

  def self.parse_time(str)
    return nil if str.to_s.strip.empty?
    Time.parse(str)
  rescue
    nil
  end
end
