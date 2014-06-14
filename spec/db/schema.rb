# encoding: UTF-8

ActiveRecord::Schema.define(:version => 0) do

  create_table(:blogs, force: true) do |t|
    t.string :name
  end

  create_table(:posts, force: true) do |t|
    t.string :title
    t.integer :blog_id
    t.integer :author_id
  end

  create_table(:users, force: true) do |t|
    t.string :name
  end

  create_table(:addresses, force: true) do |t|
    t.string :city
    t.integer :user_id
  end

  create_table(:groups, force: true) do |t|
    t.string :name
  end

  create_table(:tags, force: true) do |t|
    t.string :name
    t.integer :parent_id
    t.string :owner_type
    t.integer :owner_id
  end

  create_table(:post_tags, force: true) do |t|
    t.integer :post_id
    t.integer :tag_id
  end
end

class Tag < ActiveRecord::Base
  belongs_to :parent, class_name: 'Tag'
  has_many :children, class_name: 'Tag', foreign_key: :parent_id

  belongs_to :owner, polymorphic: true
  has_many :post_tags
  has_many :posts, through: :post_tags

  if Goldiloader::Compatibility.mass_assignment_security_enabled?
    attr_accessible :name
  end
end

class PostTag < ActiveRecord::Base
  belongs_to :post
  belongs_to :tag
end

class Blog < ActiveRecord::Base
  has_many :posts
  has_many :posts_without_auto_include, auto_include: false, class_name: 'Post'
  has_many :posts_included_on_access, auto_include_on_access: true, class_name: 'Post'
  has_many :authors, through: :posts

  if Goldiloader::Compatibility.mass_assignment_security_enabled?
    attr_accessible :name
  end
end

class Post < ActiveRecord::Base
  belongs_to :blog
  belongs_to :blog_without_auto_include, auto_include: false, class_name: 'Blog', foreign_key: :blog_id
  belongs_to :author, class_name: 'User'
  has_many :post_tags
  has_many :tags, through: :post_tags

  if Goldiloader::Compatibility.mass_assignment_security_enabled?
    attr_accessible :title
  end
end

class User < ActiveRecord::Base
  has_many :posts, foreign_key: :author_id
  has_many :tags, as: :owner
  has_one :address
  has_one :address_without_auto_include, auto_include: false, class_name: 'Address'

  if Goldiloader::Compatibility.mass_assignment_security_enabled?
    attr_accessible :name
  end
end

class Address < ActiveRecord::Base
  belongs_to :user

  if Goldiloader::Compatibility.mass_assignment_security_enabled?
    attr_accessible :city
  end
end

class Group < ActiveRecord::Base
  has_many :tags, as: :owner

  if Goldiloader::Compatibility.mass_assignment_security_enabled?
    attr_accessible :name
  end
end
