require "omniauth/strategies/oauth2"

module OmniAuth
  module Strategies
    class Myob < OmniAuth::Strategies::OAuth2

      option :name, 'myob'

      option :client_options, {
        :site          => 'https://secure.myob.com',
        :authorize_url => '/oauth2/account/authorize',
        :token_url     => '/oauth2/v1/authorize',
      }

      uid {
        raw_info[0]['Id']
      }

      def raw_info
        begin
          @raw_info ||= MultiJson.load(access_token.get('https://api.myob.com/accountright/', {:headers => headers}).body)
        rescue => e
          Raven.capture_exception(e)
        end
      end

      private

      def headers
        {
          'x-myobapi-key'     => options.client_id,
          'x-myobapi-cftoken' => '',
        }
      end

    end
  end
end