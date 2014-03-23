require 'active_record'
require 'ar_pg_array'

ActiveRecord::Schema.define do |s|
  options = { force: true, id: false }

  create_table :items, options do |t|
    t.binary    :id,                            null: false, limit: 16
    t.string    :name, :version,                null: false
    t.string    :item_type,                     null: false
    t.binary    :user_id,                       null: false, limit: 16
    t.string    :summary, :description
    t.timestamp :uploaded
    t.boolean   :reviewed,     default: false
    t.integer   :downloads,    default: 0
    t.string_array :tags
    t.string_array :authors,   default: [] # todo
    t.string    :digest_auth

    t.index :id,               unique: true, name: 'items_id_index'
    t.index [:name, :version], unique: true
  end
  execute 'ALTER TABLE items ADD PRIMARY KEY USING INDEX items_id_index'
  execute 'ALTER TABLE items ALTER COLUMN uploaded SET DEFAULT CURRENT_TIMESTAMP'

  create_table :users, options do |t|
    t.binary       :id,                      null: false, limit: 16
    t.string       :name, :mail ,            null: false
    t.string       :pw,                      null: false, limit: 64
    t.string_array :privileges, default: []
    t.timestamp    :joined

    t.index :id,   unique: true, name: 'users_id_index'
    t.index :name, unique: true
    t.index :mail, unique: true
  end
  execute 'ALTER TABLE users ADD PRIMARY KEY USING INDEX users_id_index'
  execute 'ALTER TABLE users ALTER COLUMN joined SET DEFAULT CURRENT_TIMESTAMP'

  create_table :ratings, options do |t|
    t.binary :user, :item, null: false, limit: 16
    t.integer :rating, default: 0

    t.index [:user, :item], unique: true, name: 'rating_index'
  end
  execute 'ALTER TABLE ratings ADD PRIMARY KEY USING INDEX rating_index'

  create_table :digest_auth_tokens, options do |t|
    t.string :opaque
    t.string :nonce

    t.index :opaque, unique: true, name: 'opaque_index'
  end
  execute 'ALTER TABLE digest_auth_tokens ADD PRIMARY KEY USING INDEX opaque_index'
end