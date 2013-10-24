require './test/test_helper'
require './test/app_helper'
require './lib/app'

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
    assert_equal 302, last_response.status
  end

  def test_it_shouldnt_hit_a_users_profile_page_without_auth
    get '/users/thewatts'
    refute last_response.ok?, "Can get to Users Profile page w/out auth"
  end

end
