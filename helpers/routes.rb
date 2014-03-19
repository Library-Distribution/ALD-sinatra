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
          else
            halt 406
        end
      end

      def describe_user(user)
        user_hash = user.serializable_hash
        user_hash['mail-md5'] = Digest::MD5.hexdigest(user.mail)

        # unset mail (only if authenticated)
        # privilege (list of strings)

        format :"users/describe", 'user' => user_hash
      end

      def authorize!
        halt 401, { 'WWW-Authenticate' => 'Basic realm="Restricted API"' } unless authorized?
      end

      def authorized? # adapted from the Sinatra FAQ
        @auth ||= Rack::Auth::Basic::Request.new(request.env)
        @auth.provided? && @auth.basic? && @auth.credentials && User.exists?(name: @auth.credentials[0], pw: Digest::SHA256.hexdigest(@auth.credentials[1]))
      end
    end
  end
end

helpers ALD::SinatraHelpers::Routes