class IdRecord < ActiveRecord::Base
  def id
    super.unpack('H*').first.upcase
  end
end

class Item < IdRecord
end

class User < IdRecord
end