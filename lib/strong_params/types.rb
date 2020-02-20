module StrongParams
  module Types
    class Base
      def initialize(type, column)
        @type = type
        @column = column
      end

      def nullable?
        column.null
      end

      def type_options
        []
      end

      def dsl_options
        {}
      end

      private

      attr_reader :type, :column
    end

    class Array < Base
      attr_reader :subtype

      def self.wrap(subtype)
        new(subtype)
      end

      def initialize(subtype)
        @subtype = subtype
      end

      def type_options
        @subtype.type_options.merge(array: true)
      end

      # TODO: This isn't quite right... AR being the piece of shit it is
      def nullable?
        subtype.nullable?
      end
    end

    class String < Base
      def type_options
        [:string]
      end
    end

    class Enum < Base
      def type_options
        [:string, included_in?: external_values]
      end

      def dsl_options
        {enum: external_values}
      end

      def external_values
        type.send(:mapping).keys
      end
    end


    class Date < Base
      def type_options
        [:date]
      end
    end

    class Float < Base
      def type_options
        [:float]
      end
    end

    class Decimal < Base
      def type_options
        [:decimal]
      end
    end

    class Boolean < Base
      def type_options
        [:bool]
      end
    end

    class Integer < Base
      def type_options
        [:integer]
      end
    end

    class Time < Base
      def type_options
        [:time]
      end
    end

    class DateTime < Base
      def type_options
        [:datetime]
      end
    end

    class Binary < Base
      def type_options
        [:bool]
      end
    end
  end
end
