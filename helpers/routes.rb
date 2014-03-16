module ALD
  module SinatraHelpers
    module Routes
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
    end
  end
end

helpers ALD::SinatraHelpers::Routes