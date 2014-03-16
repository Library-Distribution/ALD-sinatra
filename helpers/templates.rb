module ALD
  module SinatraHelpers
    module Templates
      def prefix(hash)
        Hash[hash.map { |k, v| ['ald:' + k, v] }]
      end

      def filter(data, keys)
        SinatraHelpers::Templates.filter(data, keys)
      end

      def self.filter(data, keys) # to be accessible by other code
        if data.is_a? Hash # filter this hash
          data.select { |k, v| keys.include? k }
        else # make a hash from this object
          Hash[keys.select { |k| data.respond_to? k }.map { |k| [k, data.send(k.to_sym)] }]
        end
      end
    end
  end
end

helpers ALD::SinatraHelpers::Templates