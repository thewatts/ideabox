require './lib/idea_box/data_store'
require './lib/idea_box'

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

    def find_by_nickname(nickname)
      all.find { |user| user.nickname == nickname }
    end

    def find_by_phone(phone)
      all.find { |user| user.phone == phone }
    end

  end

  attr_accessor :id, :uid, :name, :nickname,
                :image, :phone, :created_at, :updated_at

  def initialize(attributes = {})
    @uid                   = validate(attributes[:uid])
    @name                  = validate(attributes[:name])
    @nickname              = validate(attributes[:nickname])
    @image                 = attributes[:image]
    @phone                 = attributes[:phone]
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

  def ideas
    Idea.find_all_by_user_id(id)
  end

  private
  attr_reader :password

end
