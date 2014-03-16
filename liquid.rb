require 'json'

module ALD
  module LiquidExtensions
    def json(object)
      object.to_json
    end

    def filter(object, *keys)
      SinatraHelpers::Templates.filter(object, keys)
    end
  end
end

Liquid::Template.register_filter ALD::LiquidExtensions