require 'ipizza'
require 'omniauth/oauth'
require 'rack/utils'

module OmniAuth
  module Strategies
    class Ipizza
      include OmniAuth::Strategy
      
      attr_accessor :logger
      
      def initialize(app, title, options = {})
        super(app, :ipizza)
        
        @title = title
        self.logger = options.delete(:logger)
        
        ::Ipizza::Config.load_from_file(options.delete(:config))
      end

      def request_phase
        if env['REQUEST_METHOD'] == 'GET'
          get_credentials
        else
          provider = ipizza_provider_for(request.params['bank'])

          req = provider.authentication_request
          
          # TODO: it is not very nice to ask for service url via class parameter.
          url = [provider.class.service_url, Rack::Utils.build_query(req.request_params)] * '?'
          
          redirect url
        end
      end

      def get_credentials
        OmniAuth::Form.build(@title) do
          text_field 'Bank', 'bank'
        end.to_response
      end

      def callback_phase
        debug "Callback in iPizza authentication. Parameters: #{request.params.inspect}"

        @env['REQUEST_METHOD'] = 'GET'
        
        provider = ipizza_provider_for(request.params['VK_SND_ID'])
        resp = provider.authentication_response(request.params)
        
        if resp.success? and resp.valid?
          @user_data = {'personal_code' => resp.info_social_security_id, 'name' => resp.info_name}
          @env['omniauth.auth'] = auth_hash
          
          debug "iPizza request was authenticated successfully. User data: #{auth_hash.inspect}"
          
          call_app!
        else
          debug 'Could not authenticate iPizza request'
          fail!(:invalid_credentials, {'error' => 'Invalid bank response'})
        end
      end
      
      def user_info
        @user_data
      end
      
      def auth_hash
        OmniAuth::Utils.deep_merge(super, {'uid' => @user_data['personal_code'], 'user_info' => user_info})
      end

      def debug(message)
        logger.debug("#{Time.now} #{message}") if logger
      end
      
      private
      
      def ipizza_provider_for(bank)
        case bank.downcase
        when 'swedbank'
          ::Ipizza::Provider::Swedbank.new
        when 'eyp'
          ::Ipizza::Provider::Seb.new
        when 'seb'
          ::Ipizza::Provider::Seb.new
        when 'sampo'
          ::Ipizza::Provider::Sampo.new
        when 'nordea'
          ::Ipizza::Provider::Nordea.new
        end
      end

    end
  end
end
