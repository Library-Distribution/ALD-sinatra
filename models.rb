module IdRecord
  def id
    IdRecord.hex(super)
  end

  def self.hex(binary)
    binary.unpack('H*').first.upcase
  end

  def self.included(o)
    o.extend(ClassMethods)
  end

  module ClassMethods
    def find(id)
      find_by "id = E'\\\\x#{id}'"
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
  belongs_to :item_type
end

class User < ActiveRecord::Base
  include IdRecord
  include Liquidable

  has_many :items, dependent: :restrict_with_error
end

class ItemType < ActiveRecord::Base
  include Liquidable
  self.table_name = 'types'
end