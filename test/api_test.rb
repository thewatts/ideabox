require './test/api_helper'
require 'json'

class ApiTest < MiniTest::Test
  include Rack::Test::Methods

  attr_reader :user, :access_key

  def app
    IdeaBoxAPI
  end

  def setup
    secret = "Make everything as simple as possible, but not simpler. abc1234"
    @user  = User.create(:uid => "abc1234", :name => "Nathaniel",
                         :nickname => "thewatts")
    @access_key = Digest::SHA1.hexdigest(secret)
  end

  def teardown
    User.reset_table
    Idea.reset_table
  end

  def content_type
    {"CONTENT_TYPE" => "application/json"}
  end

  def test_it_exists
    assert IdeaBoxAPI
  end

  def test_authentication_required
    get '/'
    assert_equal 401, last_response.status
  end

  def test_idea_creation_with_valid_key
    assert_equal 0, Idea.all.count

    url = '/ideas/new'
    params = {
      :idea => {
        "title"       => "Cook Food",
        "description" => "Like Hot Pockets!",
        "tags"        => "food, cooking, microwave"
      },
      :access_key => access_key
    }

    post url, params.to_json.to_s, content_type

    assert_equal 200, last_response.status
    assert_equal 1, Idea.all.count
  end

  def test_idea_cant_be_created_with_invalid_key
    assert_equal 0, Idea.all.count

    url = '/ideas/new'
    params = {
      :idea => {
        "title"       => "Cook Food",
        "description" => "Like Hot Pockets!",
        "tags"        => "food, cooking, microwave"
      },
      :access_key => "1234"
    }

    post url, params.to_json.to_s, content_type

    assert_equal 401, last_response.status
    assert_equal 0, Idea.all.count
  end

  def test_get_ideas_with_access_key
    idea1_attributes = {
      "title"       => "Go to the Beach",
      "description" => "This Sunday!",
      "tags"        => "beach, sun, swimming",
      "user_id"     => user.id
    }
    idea1 = Idea.create(idea1_attributes)

    idea2_attributes = {
      "title"       => "Go to the Movies!",
      "description" => "This Weekend!",
      "tags"        => "popcorn, candy, flicks",
      "user_id"     => user.id
    }
    idea2 = Idea.create(idea2_attributes)

    ideas_json = {:ideas => [idea1.to_h, idea2.to_h]}.to_json

    assert_equal 2, Idea.all.count

    url = '/ideas'
    params = { :access_key => access_key }

    get url, params
    assert_equal 200, last_response.status
    assert_equal ideas_json, last_response.body
  end

  def test_prevent_getting_ideas_without_access_key
    url = '/ideas'
    params = { :access_key => "asdf" }

    get url, params
    assert_equal 401, last_response.status
  end

  def test_editing_of_idea_with_access_key
    idea_attributes = {
      "title"       => "Go to the Beach",
      "description" => "This Sunday!",
      "tags"        => "beach, sun, swimming",
      "user_id"     => user.id
    }
    idea = Idea.create(idea_attributes)

    assert_equal 1, Idea.all.count

    url = '/ideas/1'
    params = {
      :idea => {
        "title" => "Go to the MOON!"
      },
      :access_key => access_key
    }

    put url, params.to_json.to_s, content_type

    idea = Idea.all.last
    assert_equal 200, last_response.status
    assert_equal "Go to the MOON!", idea.title
  end

  def test_prevent_edit_ideas_without_access_key
    url = '/ideas/1'
    params = { :access_key => "asdf" }

    put url, params.to_json.to_s, content_type
    assert_equal 401, last_response.status
  end

  def test_delete_idea_with_access_key
    idea_attributes = {
      "title"       => "Go to the Beach",
      "description" => "This Sunday!",
      "tags"        => "beach, sun, swimming",
      "user_id"     => user.id
    }
    idea = Idea.create(idea_attributes)

    assert_equal 1, Idea.all.count

    url = '/ideas/1'
    params = { :access_key => access_key }

    delete url, params.to_json.to_s, content_type
    assert_equal 200, last_response.status
    assert_equal 0, Idea.all.count
  end

  def test_prevent_delete_idea_without_access_key
    url = '/ideas/1'
    params = { :access_key => "asdf" }

    delete url, params.to_json.to_s, content_type
    assert_equal 401, last_response.status
  end

end
