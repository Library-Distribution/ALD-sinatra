module IdRecord
  def id
    IdRecord.hex(super)
  end

  def self.hex(binary)
    binary.unpack('H*').first.upcase
  end

  def self.unhex(str)
    [str].pack('H*')
  end

  def self.included(o)
    o.extend(ClassMethods)
  end

  module ClassMethods
    def find(*args)
      args = [IdRecord.unhex(args.first)] unless args.length > 1 || args.first.is_a?(Array) # workaround if just ID is passed
      super *args
    end

    def exists?(conditions = :none)
      conditions = IdRecord.unhex(conditions) if conditions.is_a?(String) # workaround if just ID is passed
      super conditions
    end
  end
end

module Liquidable
  def to_liquid
    serializable_hash
  end
end

class Item < ActiveRecord::Base
  include IdRecord
  include Liquidable

  def user_id
    IdRecord.hex(super)
  end

  belongs_to :user

  has_many :ratings, foreign_key: 'item'
  has_many :rating_users, through: :ratings, source: :user
end

class User < ActiveRecord::Base
  include IdRecord
  include Liquidable

  has_many :items, dependent: :restrict_with_error

  has_many :ratings, foreign_key: 'user'
  has_many :rated_items, through: :ratings, source: :item
end

class Rating < ActiveRecord::Base
  include Liquidable

  belongs_to :item, foreign_key: 'item'
  belongs_to :user, foreign_key: 'user'
end

class DigestAuthToken < ActiveRecord::Base
end