require_relative "strong_params/version"
require_relative "strong_params/column"
require_relative "strong_params/schema_provider"
require_relative "strong_params/controller"

module StrongParams
  def self.of(model, *columns)
    gathered = model.column_names.each_with_object({}) do |col, obj|
      obj[col.to_sym] = Column.of(model, col)
    end

    SchemaProvider.new(gathered)
  end
end
