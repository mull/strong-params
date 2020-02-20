require_relative 'types'

module StrongParams
  module Column
    def self.of(model, column_name)
      unless model.ancestors.include?(ActiveRecord::Base)
        raise ArgumentError, "StrongParams.of only works with ActiveRecord models"
      end

      column = model.columns.find { |c| c.name == column_name.to_s }
      type = model.type_for_attribute(column_name)
      attribute_value = model.attribute_types[column_name.to_s]

      klass =
        case type
        when ActiveRecord::Enum::EnumType
          Types::Enum
        end

      klass ||=
        case column.type
        when :binary
          Types::Binary
        when :boolean
          Types::Boolean
        when :date
          Types::Date
        when :datetime
          Types::DateTime
        when :time
          Types::Time
        when :float
          Types::Float
        when :bigint, :integer
          Types::Integer
        when :numeric, :decimal
          Types::Decimal
        when :string, :text
          Types::String
        end

      raise ArgumentError, "Wut? #{column_name} #{column.type} #{type}" if klass.nil?

      wrapper =
        if defined?(ActiveRecord::ConnectionAdapters::PostgreSQL)
          if attribute_value.is_a? ActiveRecord::ConnectionAdapters::PostgreSQL::OID::Array
            Types::Array
          end
        end

      scalar_type = klass.new(type, column)

      if wrapper
        wrapper.wrap(scalar_type)
      else
        scalar_type
      end
    end
  end
end
