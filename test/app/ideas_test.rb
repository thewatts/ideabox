require './test/test_helper'
require './test/app_helper'
require './lib/idea_box'

class IdeaBoxAppTest < MiniTest::Test
  include Rack::Test::Methods

  def app
    IdeaBoxApp.new
  end

  def setup
    Idea.destroy_db
    Idea.create("title" => "The Title",
                "description" => "The Description")
  end

  def test_it_should_hit_the_home_page
    get '/'
    assert last_response.ok?
  end

  def test_it_creates_an_idea
    user = User.create(:nickname => "thewatts", :euid => "1234")

    url =  '/'
    params = {
      idea: {
        "title" => "Another Title",
        "description" => "YAHOO!"
      }
    }
    session = {
      "rack.session" => { :user_id => user.id }
    }

    post url, params, session

    assert_equal 2, Idea.all.count
  end

  def test_it_goes_to_idea_edit_page
    #skip
    get '/1/edit'
    assert last_response.ok?
  end

  def test_it_updates_an_idea
    #skip
    assert_equal "The Title", Idea.all.first.title
    put '/1', :idea => { "title" => "Another Title",
                         "description" => "YAHOO!" }
    assert_equal "Another Title", Idea.all.first.title
  end

  def test_it_likes_an_idea
    #skip
    id = 1
    post "/#{id}/like"
    idea = Idea.find(id)
    assert_equal 1, idea.rank
    assert_equal "The Title", idea.title
  end

  def test_it_deletes_an_idea
    #skip
    assert_equal 1, Idea.all.count
    delete '/1'
    assert_equal "http://example.org/1", last_request.url
    assert_equal 0, Idea.all.count
  end

end
