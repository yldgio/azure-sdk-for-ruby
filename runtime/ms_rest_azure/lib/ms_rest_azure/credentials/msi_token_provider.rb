# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

module MsRestAzure
  #
  # Class that provides access to authentication token via Managed Service Identity.
  #
  class MSITokenProvider < MsRest::TokenProvider

    private

    TOKEN_ACQUIRE_URL = 'http://localhost:{port}/oauth2/token'
    REQUEST_BODY_PATTERN = 'resource={resource_uri}'
    USER_ASSIGNED_IDENTITY = '{id_type}={user_assigned_identity}'
    DEFAULT_SCHEME = 'Bearer'

    # @return [MSIActiveDirectoryServiceSettings] settings.
    attr_accessor :settings

    # @return [Integer] port number where MSI service is running.
    attr_accessor :port

    # @return [String] client id for user assigned managed identity
    attr_accessor :client_id

    # @return [String] object id for user assigned managed identity
    attr_accessor :object_id

    # @return [String] ms_res id for user assigned managed identity
    attr_accessor :msi_res_id

    # @return [String] auth token.
    attr_accessor :token

    # @return [Time] the date when the current token expires.
    attr_accessor :token_expires_on

    # @return [Integer] the amount of time we refresh token before it expires.
    attr_reader :expiration_threshold

    # @return [String] the type of token.
    attr_reader :token_type

    public

    #
    # Creates and initialize new instance of the MSITokenProvider class.
    # @param port [Integer] port number where MSI service is running.
    # @param settings [ActiveDirectoryServiceSettings] active directory setting.
    # @param msi_id [Hash] MSI id for user assigned managed service identity,
    #   msi_id = {'client_id': 'client id of user assigned identity'}
    # or
    #  msi_id = {'object_id': 'object id of user assigned identity'}
    # or
    #  msi_id = {'msi_rest_id': 'resource id of user assigned identity'}
    # The above key,value pairs are mutually exclusive.
    def initialize(port = 50342, settings = ActiveDirectoryServiceSettings.get_azure_settings, msi_id = nil)
      fail ArgumentError, 'Port cannot be nil' if port.nil?
      fail ArgumentError, 'Port must be an Integer' unless port.is_a? Integer
      fail ArgumentError, 'Azure AD settings cannot be nil' if settings.nil?
      fail ArgumentError, 'msi_id must include either client_id, object_id or msi_res_id exclusively' if (!msi_id.nil? && msi_id.length > 1)

      @port = port
      @settings = settings
      if !msi_id.nil?
        @client_id = msi_id[:client_id] unless msi_id[:client_id].nil?
        @object_id = msi_id[:object_id] unless msi_id[:object_id].nil?
        @msi_res_id = msi_id[:msi_res_id] unless msi_id[:msi_res_id].nil?
      end

      @expiration_threshold = 5 * 60
    end

    #
    # Returns the string value which needs to be attached
    # to HTTP request header in order to be authorized.
    #
    # @return [String] authentication headers.
    def get_authentication_header
      acquire_token if token_expired
      "#{token_type} #{token}"
    end

    private

    #
    # Checks whether token is about to expire.
    #
    # @return [Bool] True if token is about to expire, false otherwise.
    def token_expired
      @token.nil? || Time.now >= @token_expires_on + expiration_threshold
    end

    #
    # Retrieves a new authentication token.
    #
    # @return [String] new authentication token.
    def acquire_token
      token_acquire_url = TOKEN_ACQUIRE_URL.dup
      token_acquire_url['{port}'] = @port.to_s

      url = URI.parse(token_acquire_url)

      connection = Faraday.new(:url => url, :ssl => MsRest.ssl_options) do |builder|
        builder.adapter Faraday.default_adapter
      end

      request_body = REQUEST_BODY_PATTERN.dup
      request_body['{resource_uri}'] = ERB::Util.url_encode(@settings.token_audience)
      request_body = set_msi_id(request_body, 'client_id', @client_id) unless @client_id.nil?
      request_body = set_msi_id(request_body, 'object_id', @object_id) unless @object_id.nil?
      request_body = set_msi_id(request_body, 'msi_res_id', @msi_res_id) unless @msi_res_id.nil?

      response = connection.post do |request|
        request.headers['content-type'] = 'application/x-www-form-urlencoded'
        request.headers['Metadata'] = 'true'
        request.body = request_body
      end

      fail AzureOperationError,
          'Couldn\'t acquire access token from Managed Service Identity, please verify your tenant id, port and settings' unless response.status == 200

      response_body = JSON.load(response.body)
      @token = response_body['access_token']
      @token_expires_on = Time.at(Integer(response_body['expires_on']))
      @token_type = response_body['token_type']
    end

    #
    # Sets user assigned identity value in request body
    # @param request_body [String] body of the request used to acquire token
    # @param id_type [String] type of id to send 'client_id', 'object_id' or 'msi_res_id'
    # @param id_value [String] id of the user assigned identity
    #
    # @return [String] new request body with the addition of <id_type>=<id_value>.
    def set_msi_id(request_body, id_type, id_value)
      user_assigned_identity = USER_ASSIGNED_IDENTITY.dup
      request_body = [request_body, user_assigned_identity].join(',')
      request_body['{id_type}'] = id_type
      request_body['{user_assigned_identity}'] = ERB::Util.url_encode(id_value)

      return request_body
    end
  end

end