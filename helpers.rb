module ALD
  module Helpers
    def format(view, data)
      type = request.preferred_type(ALD::OUTPUT_TYPES)
      case type
        when 'application/xml', 'text/xml'
          haml view,
              :locals => data,
              :content_type => type,
              :format => :xhtml
        when 'application/json'
          liquid view,
              :locals => data,
              :content_type => type
      end
    end

    def describe_user(user)
      user_hash = user.serializable_hash
      user_hash['mail-md5'] = Digest::MD5.hexdigest(user.mail)

      # unset mail (only if authenticated)
      # privilege (list of strings)

      format :"users/describe", 'user' => user_hash
    end

    def hash(data)
      data.to_a.map(&:serializable_hash)
    end

    def prefix(hash)
      Hash[hash.map { |k, v| ['ald:' + k, v] }]
    end

    def filter(hash, keys)
      Helpers.filter(hash, keys)
    end

    def self.filter(hash, keys) # to be accessible by other code
      hash.select { |k, v| keys.include? k }
    end

    def restrict(data)
      if params[:count]
        data = data.limit(params[:count].to_i)
      end

      if params[:start]
        data = data.limit(data.count) unless params[:count] # there must be a limit for offset to work
        data = data.offset(params[:start].to_i)
      end

      data
    end

    def conditions(allowed_params)
      query = []
      data = []

      (allowed_params[:exact] || []).each do |param|
        if params[param]
          query << "#{param.to_s} = ?"
          data << params[param]
        end
      end

      (allowed_params[:range] || []).each do |param|
        { "min" => ">=", "max" => "<=" }.each_pair do |k, op|
          if params[:"#{param}-#{k}"]
            query << "#{param.to_s} #{op} ?"
            data << params[:"#{param}-#{k}"]
          end
        end
      end

      (allowed_params[:array] || []).each do |param|
        if params[param]
          params[param].split(",").each do |entry|
            query << "? = ANY (#{param})"
            data << entry
          end
        end
      end

      [query.join(" and ")].concat(data)
    end

    def sort(criteria)
      order = {}

      sort = (params[:sort] || '').split(',')
      sort.each do |param|
        dir = :asc
        if param[0] == '-'
          param = param[1..-1]
          dir = :desc
        end

        if criteria.include?(param)
          order[param] = dir
        end
      end

      order
    end
  end
end

helpers ALD::Helpers