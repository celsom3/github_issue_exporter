# Copyright (c) 2015 Scott Williams

require "net/http"
require "json"

module IssueExporting
  class Exporter

    attr_accessor :outputter

    def initialize(owner, repo, token = nil, options = {})
      @owner = owner
      @repo = repo
      @token = token
      @options = options
      outputter_options = options.select { |k,v| [:path, :multiple_files].include? k }
      @outputter = FileOutputter.new outputter_options
    end

    def export
      error_handler = ErrorHandler.new
      url = IssueExporting.make_uri @owner, @repo, @token, @options
      response = Net::HTTP::get url
      if err = error_handler.error_message(response)
        error_handler.handle_error err
      else
        outputter.write response
      end
    end
  end
end

