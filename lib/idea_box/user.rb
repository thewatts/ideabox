class User

  attr_reader :id, :login, :email, :first_name, :last_name,
              :updated_at, :created_at

  def initialize(attributes = {})
    @id                    = attributes["id"].to_i
    @login                 = attributes["login"].downcase
    @email                 = attributes["email"].downcase
    @password              = attributes["password"]
    @first_name            = attributes["first_name"]
    @last_name             = attributes["last_name"]
    @created_at            = attributes["created_at"]
    @updated_at            = attributes["updated_at"]
  end

  def save
    UserStore.create(to_h)
  end

  def to_h
    {
      "id"         => id,
      "login"      => login,
      "email"      => email,
      "password"   => password,
      "first_name" => first_name,
      "last_name"  => last_name,
      "created_at" => created_at,
      "updated_at" => created_at
    }
  end

  private
  attr_reader :password

end
