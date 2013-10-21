require './test/test_helper'
require './test/app_helper'
require './lib/idea_box'

class UsersControllerTest < MiniTest::Test
  include Rack::Test::Methods


  attr_reader :attributes

  def app
    IdeaBoxApp.new
  end

  def setup
    User.destroy_db
    @attributes = {
      :uid      => "1234",
      :nickname => "thewatts",
      :name     => "Nathaniel Watts",
      :image    => "http://google.com"
    }
    User.create(@attributes)
  end

  def teardown
    User.destroy_db
  end

  def test_it_should_hit_the_users_page
    get '/users'
    assert last_response.ok?, "Users page not 200"
  end

  def test_it_should_hit_a_users_profile_page
    get '/users/thewatts'
    assert last_response.ok?, "Can't get to Users Profile page"
  end

end
