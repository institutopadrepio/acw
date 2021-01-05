# frozen_string_literal: true

require 'excon'
require 'cgi'
require 'json'

module Acw
  class Client
    include Acw::Helpers

    API_VERSION = 3

    def initialize(configs = {})
      @config = configs
    end

    attr_reader :config

    def connection
      @connection ||= Excon.new(config[:url])
    end

    def create_contact(args = {})
      safe_http_call do
        params = { contact: args }
        connection.post(
          path: "/api/#{API_VERSION}/contacts",
          headers: headers(config[:token]),
          body: params.to_json
        )
      end
    end

    def sync_contact(params)
      safe_http_call do
        connection.post(
          path: "/api/#{API_VERSION}/contact/sync",
          headers: headers(config[:token]),
          body: params.to_json
        )
      end
    end

    def retrieve_contact(id)
      safe_http_call do
        connection.get(
          path: "/api/#{API_VERSION}/contacts/#{id}",
          headers: headers(config[:token])
        )
      end
    end

    def retrieve_contact_by_email(email)
      safe_http_call do
        uemail = CGI.escape email
        connection.get(
          path: "/api/#{API_VERSION}/contacts?search=#{uemail}",
          headers: headers(config[:token])
        )
      end
    end

    def retrieve_lists
      safe_http_call do
        connection.get(
          path: "/api/#{API_VERSION}/lists",
          headers: headers(config[:token])
        )
      end
    end

    def create_tag(args = {})
      safe_http_call do
        params = { tag: args }
        connection.post(
          path: "/api/#{API_VERSION}/tags",
          headers: headers(config[:token]),
          body: params.to_json
        )
      end
    end

    def add_contact_tag(args = {})
      safe_http_call do
        params = { 'contactTag': args }
        connection.post(
          path: "/api/#{API_VERSION}/contactTags",
          headers: headers(config[:token]),
          body: params.to_json
        )
      end
    end

    def remove_contact_tag(id)
      safe_http_call do
        connection.delete(
          path: "/api/#{API_VERSION}/contactTags/#{id}",
          headers: headers(config[:token])
        )
      end
    end

    def create_field_value(args = {})
      safe_http_call do
        params = { 'fieldValue': args }
        connection.post(
          path: "/api/#{API_VERSION}/fieldValues",
          headers: headers(config[:token]),
          body: params.to_json
        )
      end
    end

    def update_field_value(id, args = {})
      safe_http_call do
        params = { 'fieldValue': args }
        connection.put(
          path: "/api/#{API_VERSION}/fieldValues/#{id}",
          headers: headers(config[:token]),
          body: params.to_json
        )
      end
    end

    private

    def safe_http_call
      response = yield
      raise response.body unless success_http_status(response.status)

      result(true, nil, JSON.parse(response.body))
    rescue StandardError => e
      result(false, e.message, nil)
    end

    def success_http_status(status)
      [200, 201, 202].include?(status)
    end
  end
end
