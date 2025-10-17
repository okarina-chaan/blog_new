class HatenaBlogService
  BASE_URL = "https://blog.hatena.ne.jp"
 
  def initialize
    @username = ENV['HATENA_USERNAME']
    @blog_id = ENV['HATENA_BLOG_ID']
    @api_key = ENV['HATENA_API_KEY']
  end

  def fetch_articles(limit: 10)
    uri = URI.parse(HATENA_ATOM_URL)
    request = Net::HTTP::Get.new(uri)
    request.basic_auth(ENV['HATENA_USERNAME'], ENV['HATENA_API_KEY'])

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

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

end
