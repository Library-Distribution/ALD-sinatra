require 'json'

module ALD
  module LiquidExtensions
    def json(object)
      object.reject {|k,v| k == "collections" }.to_json
    end

    def filter(object, *keys)
      Helpers.filter(object, keys)
    end
  end
end

Liquid::Template.register_filter ALD::LiquidExtensions