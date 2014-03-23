module ALD
  module SinatraHelpers
    module Routes
      AUTH_REALM = 'ALD API @ libba.herokuapp.com'

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
        if authorization.provided? && authorization.digest?
          check_auth
        else
          start_auth
        end
      end

      private

      def authorization
        @auth ||= Rack::Auth::Digest::Request.new(request.env)
      end

      def start_auth
        opaque = Rack::Auth::Digest::Nonce.new.to_s
        nonce = Rack::Auth::Digest::Nonce.new.to_s
        DigestAuthToken.create(opaque: opaque, nonce: nonce)
        headers['WWW-Authenticate'] = "Digest realm=\"#{AUTH_REALM}\" nonce=\"#{nonce}\" opaque=\"#{opaque}\""
        halt 401
      end

      def check_auth
        halt 403 unless authorization.correct_uri?
        halt 403 unless authorization.realm == AUTH_REALM

        digest = DigestAuthToken.find_by(opaque: authorization.opaque)
        restart_auth if digest.nil?

        restart_auth if digest.nonce != authorization.nonce.to_s
        restart_auth if authorization.nonce.stale?

        user = User.find_by(name: authorization.username)
        restart_auth if user.nil?

        ha1 = user.digest_auth
        ha2 = Digest::MD5.hexdigest("#{authorization.method}:#{authorization.uri}")
        response = Digest::MD5.hexdigest("#{ha1}:#{digest.nonce}:#{ha2}")

        restart_auth unless response == authorization.response
      end

      def restart_auth
        # cleanup the table
        DigestAuthToken.all.each do |digest|
          nonce = Rack::Auth::Digest::Nonce.parse(digest.nonce)
          digest.destroy if nonce.stale?
        end
        start_auth
      end
    end
  end
end

helpers ALD::SinatraHelpers::Routes