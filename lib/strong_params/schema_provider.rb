module StrongParams
  class SchemaProvider
    def initialize(params)
      @params_cache = params
    end

    def require(*columns)
      columns.each do |col|
        huh = dsl.required(col)
        apply_type(huh, column_information!(col))
      end

      self
    end

    def optional(*columns)
      columns.each do |col|
        huh = dsl.optional(col)
        apply_type(huh, column_information!(col))
      end

      self
    end

    def call(params)
      dsl.call.(params)
    end

    def inspect
      "#<StrongParams::SchemaProvider:#{object_id}>"
    end

    def columns
      @params_cache
    end

    private

    def column_information!(col_name)
      raise "Cannot find information on model for column #{col_name}" if @params_cache[col_name].nil?
      @params_cache[col_name]
    end

    def dsl
      @dsl ||= Dry::Schema::DSL.new(processor_type: Dry::Schema::Params)
    end

    def apply_type(col, type_klass)
      value_method =
        if type_klass.nullable?
          :maybe
        else
          :value
        end

      col.send(value_method, *type_klass.type_options)
    end
  end
end
