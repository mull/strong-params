require 'rspec_api_documentation/dsl'

module StrongParams
  module Rspec
    extend ActiveSupport::Concern

    module ClassMethods
      extend RspecApiDocumentation::DSL::Resource::ClassMethods

      def assert_all_parameters_described!
      end

      def self.override_method(method_name)
        original_method = method(method_name)

        copy_name = "_#{method_name}".to_sym
        define_method copy_name, original_method

        define_method method_name do |*args, &block|
          options = args.extract_options!
          path = args.first
          recognized = Rails.application.routes.recognize_path(path, method: method_name)

          controller = (recognized[:controller].camelize + "Controller").constantize

          # Assert that controller is responding to the correct method to find schema
          # Assert that its defined for this action

          byebug

          args.push(options)

          send(copy_name, *args, &block)
        end
      end

      override_method :post
      override_method :get
      override_method :patch
      override_method :put
      override_method :head

      # Override parameter method to use dsl_options from StrongParams::Column
    end

    def included(klass)
      klass.extend ClassMethods
    end
  end
end

