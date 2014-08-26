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

      option :authorize_params, {
        'scope' => 'CompanyFile'
      }

      uid { raw_info[0]['Id'] }

      info do
        {
          'name'     => raw_info[0]['Name'].to_s,
          'uri'      => raw_info[0]['Uri'].to_s,
        }
      end

      extra do
        { :raw_info => raw_info }
      end

      def raw_info
        @raw_info ||= MultiJson.load(access_token.get('https://api.myob.com/accountright/', {:headers => headers}).body)
      end

      private

      def headers
        @headers ||= {
          'x-myobapi-key'     => options.client_id,
          'x-myobapi-cftoken' => '',
          'x-myobapi-version' => 'v2',
        }
      end

    end
  end
end