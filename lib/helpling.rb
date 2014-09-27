require 'delegate'
require 'helpling/version'
require 'json'

module Helpling
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

    def get_json(path, parameters, headers = {})
      __getobj__.get(path, JSON.dump(parameters), @headers.merge(headers).merge('Content-Type' => 'application/json'))
    end

    def post_json(path, parameters, headers = {})
      __getobj__.post(path, JSON.dump(parameters), @headers.merge(headers).merge('Content-Type' => 'application/json'))
    end

    def patch_json(path, parameters, headers = {})
      __getobj__.patch(path, JSON.dump(parameters), @headers.merge(headers).merge('Content-Type' => 'application/json'))
    end

    def put_json(path, parameters, headers = {})
      __getobj__.put(path, JSON.dump(parameters), @headers.merge(headers).merge('Content-Type' => 'application/json'))
    end

    def delete_json(path, parameters, headers = {})
      __getobj__.delete(path, JSON.dump(parameters), @headers.merge(headers).merge('Content-Type' => 'application/json'))
    end

    def response
      Response.new(__getobj__.response)
    end
  end

  module TestHelper
    def r
      @r ||= Request.new(self)
    end
  end
end
