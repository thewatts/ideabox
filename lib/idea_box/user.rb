class User

  attr_reader :id, :login, :email, :first_name, :last_name,
              :updated_at, :created_at

  def initialize(attributes = {})
    @id                    = attributes["id"].to_s.to_i
    @login                 = attributes["login"].to_s.downcase
    @email                 = attributes["email"].to_s.downcase
    @password              = attributes["password"].to_s
    @first_name            = attributes["first_name"].to_s
    @last_name             = attributes["last_name"].to_s
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
