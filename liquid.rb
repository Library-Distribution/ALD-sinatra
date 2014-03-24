require 'json'

module ALD
  module LiquidExtensions
    def json(object)
      object.to_json
    end

    def parse_json(str)
      JSON.parse(str)
    end

    def merge(hsh, *others)
      others.each do |other|
        hsh.merge!(other)
      end
      hsh
    end

    def filter(object, *keys)
      SinatraHelpers::Templates.filter(object, keys)
    end
  end
end

Liquid::Template.register_filter ALD::LiquidExtensions