module IdRecord
  def id
    super.unpack('H*').first.upcase
  end
end

class Item < ActiveRecord::Base
  include IdRecord
end

class User < ActiveRecord::Base
  include IdRecord
end