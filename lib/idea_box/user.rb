require './lib/idea_box/data_store'

class User

  extend DataStore

  class << self

    def table
      "users"
    end

    def klass
      User
    end

    def first_or_create(uid_hash, attributes)
      user = find_by_uid(uid_hash[:uid])
      if user.nil?
        user = create(User.new(attributes))
      end
      user
    end

    def find_by_uid(uid)
      all.find { |user| user.uid == uid }
    end

  end

  attr_accessor :id, :uid, :name, :nickname,
                :image, :created_at, :updated_at

  def initialize(attributes = {})
    @uid                   = validate(attributes[:uid])
    @name                  = validate(attributes[:name])
    @nickname              = validate(attributes[:nickname])
    @image                 = attributes[:image]
  end

  def save
    User.create(self)
  end

  def update_attributes(hash)
    self.class.update(self.id, hash)
  end

  def validate(data)
    data.to_s
  end

  def validate_login(data)
    data.to_s
  end

  def login=(new_login)
    @login = new_login.to_s
  end

  private
  attr_reader :password

end
