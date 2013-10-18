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

  end

  attr_reader   :login, :email, :first_name, :last_name
  attr_accessor :id, :created_at, :updated_at

  def initialize(attributes = {})
    @login                 = attributes["login"].to_s.downcase
    @email                 = attributes["email"].to_s.downcase
    @password              = attributes["password"].to_s
    @first_name            = attributes["first_name"].to_s
    @last_name             = attributes["last_name"].to_s
  end

  def save
    UserStore.create(self)
  end

#  def to_h
#    {
#      "id"         => id,
#      "login"      => login,
#      "email"      => email,
#      "password"   => password,
#      "first_name" => first_name,
#      "last_name"  => last_name,
#      "created_at" => created_at,
#      "updated_at" => updated_at
#    }
#  end

  private
  attr_reader :password

end
