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

class Item < ActiveRecord::Base
  include IdRecord

  def user_id
    IdRecord.hex(super)
  end

  belongs_to :user
end

class User < ActiveRecord::Base
  include IdRecord

  has_many :items, dependent: :restrict_with_error
end