require './lib/idea_box/data_store'
require './lib/idea_box'
require 'pusher'

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
        data = {
          :nickname => user.nickname,
          :image    => user.image
        }
        Pusher['activity_channel'].trigger('new_user', :data => data)
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

    def find_by_access_key(key)
      all.find { |user| user.access_key == key }
    end

  end

  attr_accessor :id, :uid, :name, :nickname, :image, :phone,
                :access_key, :created_at, :updated_at

  def initialize(attributes = {})
    @uid                   = validate(attributes[:uid])
    @name                  = validate(attributes[:name])
    @nickname              = validate(attributes[:nickname])
    @image                 = attributes[:image]
    @phone                 = attributes[:phone]
    @access_key            = create_key
  end

  def create_key
    Digest::SHA1.hexdigest(secret)
  end

  def secret
   "Make everything as simple as possible, but not simpler. #{uid}"
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
