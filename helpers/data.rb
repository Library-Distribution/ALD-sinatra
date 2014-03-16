module ALD
  module SinatraHelpers
    module Data
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
end

helpers ALD::SinatraHelpers::Data