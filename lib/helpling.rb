require 'delegate'
require 'helpling/version'
require 'json'

module Helpling
  module AbstractAdapter
    class Request < SimpleDelegator
      def initialize(*args)
        @headers = {}
        super
      end

      def header key, value
        @headers[key] = value
      end

      def get(path, parameters = nil, headers = {})
        __getobj__.get(path, parameters, @headers.merge(headers))
      end

      def post(path, parameters = nil, headers = {})
        __getobj__.post(path, parameters, @headers.merge(headers))
      end

      def patch(path, parameters = nil, headers = {})
        __getobj__.patch(path, parameters, @headers.merge(headers))
      end

      def put(path, parameters = nil, headers = {})
        __getobj__.put(path, parameters, @headers.merge(headers))
      end

      def delete(path, parameters = nil, headers = {})
        __getobj__.delete(path, parameters, @headers.merge(headers))
      end
    end
  end

  module RackAdapter
    class Response < SimpleDelegator
      def body
        case __getobj__.original_headers['Content-Type']
        when 'application/json'
          JSON.parse(__getobj__.body)
        else
          __getobj__.body
        end
      end
    end

    class Request < AbstractAdapter::Request
      def get_json(path, parameters = nil, headers = {})
        __getobj__.get(path, json_dump(parameters), @headers.merge(headers).merge('CONTENT_TYPE' => 'application/json'))
      end

      def post_json(path, parameters = nil, headers = {})
        __getobj__.post(path, json_dump(parameters), @headers.merge(headers).merge('CONTENT_TYPE' => 'application/json'))
      end

      def patch_json(path, parameters = nil, headers = {})
        __getobj__.patch(path, json_dump(parameters), @headers.merge(headers).merge('CONTENT_TYPE' => 'application/json'))
      end

      def put_json(path, parameters = nil, headers = {})
        __getobj__.put(path, json_dump(parameters), @headers.merge(headers).merge('CONTENT_TYPE' => 'application/json'))
      end

      def delete_json(path, parameters = nil, headers = {})
        __getobj__.delete(path, json_dump(parameters), @headers.merge(headers).merge('CONTENT_TYPE' => 'application/json'))
      end

      def response
        Response.new(__getobj__.last_response)
      end

      private

      def json_dump(parameters)
        parameters ? JSON.dump(parameters) : nil
      end
    end
  end

  module RailsAdapter
    class Response < SimpleDelegator
      def body
        case __getobj__.content_type
        when 'application/json'
          JSON.parse(__getobj__.body)
        else
          __getobj__.body
        end
      end
    end

    class Request < AbstractAdapter::Request
      def get_json(path, parameters = nil, headers = {})
        __getobj__.get(path, json_dump(parameters), @headers.merge(headers).merge('Content-Type' => 'application/json'))
      end

      def post_json(path, parameters = nil, headers = {})
        __getobj__.post(path, json_dump(parameters), @headers.merge(headers).merge('Content-Type' => 'application/json'))
      end

      def patch_json(path, parameters = nil, headers = {})
        __getobj__.patch(path, json_dump(parameters), @headers.merge(headers).merge('Content-Type' => 'application/json'))
      end

      def put_json(path, parameters = nil, headers = {})
        __getobj__.put(path, json_dump(parameters), @headers.merge(headers).merge('Content-Type' => 'application/json'))
      end

      def delete_json(path, parameters = nil, headers = {})
        __getobj__.delete(path, json_dump(parameters), @headers.merge(headers).merge('Content-Type' => 'application/json'))
      end

      def response
        Response.new(__getobj__.response)
      end

      private

      def json_dump(parameters)
        parameters ? JSON.dump(parameters) : nil
      end
    end
  end

  module TestHelper
    class UnknownAdapterError < StandardError
    end

    def r
      @r ||= begin
        case
        when defined?(ActionDispatch::Integration::Runner) && self.class.ancestors.include?(ActionDispatch::Integration::Runner)
          RailsAdapter::Request.new(self)
        when defined?(Rack::Test::Methods) && self.class.ancestors.include?(Rack::Test::Methods)
          RackAdapter::Request.new(self)
        else
          raise UnknownAdapterError, 'could not detect rails or rack'
        end
      end
    end
  end
end
