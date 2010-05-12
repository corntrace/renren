require 'net/http'
require 'digest/md5'
require 'pp'

module Renren
  class Service
    DEBUG = false

    def post(params)
      pp "### Posting Params: #{params.inspect}" if DEBUG
	  sorted_params_str_with_secret_key = params.sort{|a,b| a.to_s <=> b.to_s}.map do |pair|
        "#{pair.first}=#{pair.last}"
      end.join('') << ::Renren.secret_key
      sig = Digest::MD5.hexdigest sorted_params_str_with_secret_key
      Net::HTTP.post_form(url, params.merge(:sig => sig))
    end

    private

    def url
      URI.parse('http://api.renren.com/restserver.do')
    end
  end
end

