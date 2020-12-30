# frozen_string_literal: true

require 'excon'
require 'cgi'
require 'json'

module Acw
  class Client
    API_VERSION = 3
    Result = Struct.new(:success?, :error, :value)

    def initialize(configs = {})
      @config = configs
    end

    attr_reader :config

    def connection
      @connection ||= Excon.new(config[:url])
    end

    # CONTACTS
    def create_contact(args = {})
      safe_http_call do
        params = { contact: args }
        connection.post(
          path: "/api/#{API_VERSION}/contacts",
          headers: headers,
          body: params.to_json
        )
      end
    end

    def sync_contact(args = {})
      safe_http_call do
        params = { contact: args }
        connection.post(
          path: "/api/#{API_VERSION}/contact/sync",
          headers: headers,
          body: params.to_json
        )
      end
    end

    def retrieve_contact(id)
      safe_http_call do
        connection.get(path: "/api/#{API_VERSION}/contacts/#{id}", headers: headers)
      end
    end

    def retrieve_contact_by_email(email)
      safe_http_call do
        uemail = CGI.escape email
        connection.get(path: "/api/#{API_VERSION}/contacts?search=#{uemail}", headers: headers)
      end
    end

    # LISTS
    def retrieve_lists
      safe_http_call do
        connection.get(path: "/api/#{API_VERSION}/lists", headers: headers)
      end
    end

    # TAGS
    def create_tag(args = {})
      safe_http_call do
        params = { tag: args }
        connection.post(
          path: "/api/#{API_VERSION}/tags",
          headers: headers,
          body: params.to_json
        )
      end
    end

    def add_contact_tag(args = {})
      safe_http_call do
        params = { 'contactTag': args }
        connection.post(
          path: "/api/#{API_VERSION}/contactTags",
          headers: headers,
          body: params.to_json
        )
      end
    end

    def remove_contact_tag(id)
      safe_http_call do
        connection.delete(path: "/api/#{API_VERSION}/contactTags/#{id}", headers: headers)
      end
    end

    # FIELD_VALUES
    def create_field_value(args = {})
      safe_http_call do
        params = { 'fieldValue': args }
        connection.post(
          path: "/api/#{API_VERSION}/fieldValues",
          headers: headers,
          body: params.to_json
        )
      end
    end

    def update_field_value(id, args = {})
      safe_http_call do
        params = { 'fieldValue': args }
        connection.put(
          path: "/api/#{API_VERSION}/fieldValues/#{id}",
          headers: headers,
          body: params.to_json
        )
      end
    end

    private

    def headers
      {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Api-Token': config[:token]
      }
    end

    def safe_http_call
      response = yield
      raise response.body unless success_http_status(response.status)

      Result.new(true, nil, JSON.parse(response.body))
    rescue StandardError => e
      Result.new(false, e.message, nil)
    end

    def success_http_status(status)
      [200, 201, 202].include?(status)
    end
  end
end
