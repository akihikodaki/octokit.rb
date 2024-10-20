# frozen_string_literal: true

require 'octokit/default'
require 'octokit/client'
require 'octokit/enterprise_admin_client'
require 'octokit/enterprise_management_console_client'
require 'octokit/manage_ghes_client'

# Ruby toolkit for the GitHub API
module Octokit
  class << self
    include Octokit::Configurable

    # API client based on configured options {Configurable}
    #
    # @return [Octokit::Client] API wrapper
    def client
      return @client if defined?(@client) && @client.same_options?(options)

      @client = Octokit::Client.new(options)
    end

    # EnterpriseAdminClient client based on configured options {Configurable}
    #
    # @return [Octokit::EnterpriseAdminClient] API wrapper
    def enterprise_admin_client
      if defined?(@enterprise_admin_client) && @enterprise_admin_client.same_options?(options)
        return @enterprise_admin_client
      end

      @enterprise_admin_client = Octokit::EnterpriseAdminClient.new(options)
    end

    # EnterpriseManagementConsoleClient client based on configured options {Configurable}
    #
    # @return [Octokit::EnterpriseManagementConsoleClient] API wrapper
    def enterprise_management_console_client
      if defined?(@enterprise_management_console_client) && @enterprise_management_console_client.same_options?(options)
        return @enterprise_management_console_client
      end

      @enterprise_management_console_client = Octokit::EnterpriseManagementConsoleClient.new(options)
    end

    # ManageGHESClient client based on configured options {Configurable}
    #
    # @return [Octokit::ManageGHESClient] API wrapper
    def manage_ghes_client
      if defined?(@manage_ghes_client) && @manage_ghes_client.same_options?(options)
        return @manage_ghes_client
      end

      @manage_ghes_client = Octokit::ManageGHESClient.new(options)
    end

    private

    def respond_to_missing?(method_name, include_private = false)
      client.respond_to?(method_name, include_private) ||
        enterprise_admin_client.respond_to?(method_name, include_private) ||
        enterprise_management_console_client.respond_to?(method_name, include_private) ||
        manage_ghes_client.respond_to?(method_name, include_private)
    end

    def method_missing(method_name, *args, &block)
      if client.respond_to?(method_name)
        return client.send(method_name, *args, &block)
      elsif enterprise_admin_client.respond_to?(method_name)
        return enterprise_admin_client.send(method_name, *args, &block)
      elsif enterprise_management_console_client.respond_to?(method_name)
        return enterprise_management_console_client.send(method_name, *args, &block)
      elsif manage_ghes_client.respond_to?(method_name)
        return manage_ghes_client.send(method_name, *args, &block)
      end

      super
    end
  end

  module Middleware
    # In Faraday 2.x, Faraday::Request::Retry was moved to a separate gem
    # so we use it only when requested.
    autoload :Retry, 'octokit/middleware/retry'
  end
end

Octokit.setup
