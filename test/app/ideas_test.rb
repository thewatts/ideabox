require './test/test_helper'
require './test/app_helper'
require 'CGI'

class IdeaBoxAppTest < MiniTest::Test
  include Rack::Test::Methods

  def app
    IdeaBoxApp.new
  end

  def setup
    IdeaStore.create("id" => 1, "title" => "The Title",
                     "description" => "The Description")
  end

  def teardown
    IdeaStore.destroy_db
  end

  def test_it_should_hit_the_home_page
    get '/'
    assert last_response.ok?
  end

  def test_it_creates_an_idea
    post '/', :idea => { "title" => "Another Title",
                         "description" => "YAHOO!" }
    assert_equal 2, IdeaStore.all.count
  end

  def test_it_goes_to_idea_edit_page
    get '/0/edit'
    assert last_response.ok?
  end

  def test_it_updates_an_idea
    assert_equal "The Title", IdeaStore.all.first.title
    put '/0', :idea => { "title" => "Another Title",
                         "description" => "YAHOO!" }
    assert_equal "Another Title", IdeaStore.all.first.title
  end

  def test_it_likes_an_idea
    id = 0
    post "/#{id}/like"
    idea = IdeaStore.find(id)
    assert_equal 1, idea.rank
  end

  def test_it_deletes_an_idea
    assert_equal 1, IdeaStore.all.count
    delete '/0'
    assert_equal "http://example.org/0", last_request.url
    assert_equal 0, IdeaStore.all.count
  end

end
