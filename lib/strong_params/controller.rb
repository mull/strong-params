module StrongParams
  module Controller
    extend ActiveSupport::Concern

    included do
      rescue_from(ActionController::ParameterMissing) do |parameter_missing_exception|
        render json: "Required parameter missing: #{parameter_missing_exception.param}", status: :unprocessable_entity
      end
    end

    class_methods do
      def registered_endpoint_schemas
        @_strong_params_cache || {}
      end

      def params_for(action, key, schema)
        @_strong_params_cache ||= {}
        @_strong_params_cache[action] = [key, schema]

        method = "#{action}_params".to_sym

        define_method(method) do
          scoped =
            if key.nil?
              params
            else
              params.require(key)
            end
            .permit!.to_hash

          result = schema.(scoped)
          if result.success?
            result.to_h
          else
            raise ActionController::ParameterMissing.new(result.errors.messages.first.path)
          end
        end
      end
    end
  end
end
