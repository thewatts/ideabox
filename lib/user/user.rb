class User

  def initialize(attributes = {})
    @id                    = attributes["id"]
    @login                 = attributes["login"].downcase
    @email                 = attributes["email"].downcase
    @password              = attributes["password"]
    @password_confirmation = attributes["password_confirmation"]
  end
end
