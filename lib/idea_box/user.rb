require './lib/idea_box/data_store'

class User

  include DataStore

  class << self

    def table
      "users"
    end

    def klass
      User
    end

  end

  attr_reader   :login, :email
  attr_accessor :id, :first_name, :last_name,
                :created_at, :updated_at

  def initialize(attributes = {})
    @login                 = validate_login(attributes["login"])
    @email                 = validate_email(attributes["email"])
    @password              = validate(attributes["password"])
    @first_name            = validate(attributes["first_name"])
    @last_name             = validate(attributes["last_name"])
  end

  def save
    User.create(self)
  end

  def update_attibutes(hash)
    self.class.update(self.id, hash)
  end

  def validate(data)
    data.to_s
  end

  def validate_login(data)
    data.to_s.downcase
  end

  def validate_email(data)
    data.to_s.downcase
  end

  def login=(new_login)
    @login = new_login.to_s.downcase
  end

  def email=(new_email)
    @email = new_email.to_s.downcase
  end

  private
  attr_reader :password

end
