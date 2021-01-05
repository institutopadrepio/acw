module Acw
  module Helpers
    Result = Struct.new(:success?, :error, :value)

    def headers(token)
      @headers ||= {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Api-Token': token
      }
    end

    def result(success, error, value)
      Result.new(success, error, value)
    end
  end
end
