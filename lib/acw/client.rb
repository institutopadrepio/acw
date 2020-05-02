require 'faraday'
require 'cgi'
require 'json'

module Acw
  class Client

    Result = Struct.new(:success?, :error, :value)

    def initialize(configs = {})
      @config = configs
    end

    attr_reader :config

    def connection
      @connection ||= Faraday.new(url: config[:url]) do |faraday|
        faraday.headers["Accept"] = 'application/json'
        faraday.headers['Content-Type'] = 'application/json'
        faraday.headers['Api-Token'] = config[:token]
        faraday
      end
    end

    #CONTACTS
    def create_contact(args={})
      safe_http_call do
        params = { contact: args }
        connection.post("contacts", params.to_json)
      end
    end

    def sync_contact(args={})
      safe_http_call do
        params = { contact: args }
        connection.post("contact/sync", params.to_json)
      end
    end

    def retrieve_contact(id)
      safe_http_call do
        connection.get("contacts/#{id}")
      end
    end

    def retrieve_contact_by_email(email)
      safe_http_call do
        uemail = CGI.escape email
        connection.get("contacts?search=#{uemail}")
      end
    end

    #LISTS
    def retrieve_lists
      safe_http_call do
        connection.get("lists")
      end
    end

    #TAGS
    def create_tag(args={})
      safe_http_call do
        params = {"tag": args}
        connection.post("tags", params.to_json)
      end
    end
    
    def add_contact_tag(args={})
      safe_http_call do
        params = {"contactTag": args}
        connection.post("contactTags", params.to_json)
      end
    end
    
    def remove_contact_tag(id)
      safe_http_call do
        connection.delete("contactTags/#{id}")
      end
    end

    private

    def safe_http_call
      response = yield
      raise response.body unless success_http_status(response.status)
      Result.new(true, nil, JSON.parse(response.body))
    rescue StandardError => e
      Result.new(false, e.message, nil)
    end

    def success_http_status(status)
      status == 200 || status == 201
    end
  end
end