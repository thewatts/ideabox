require './test/test_helper'
require './test/app_helper'

class SMSControllerTest < MiniTest::Test
  include Rack::Test::Methods

  def app
    IdeaBoxApp
  end

  def setup
    User.reset_table
    Idea.reset_table
  end

  def test_an_idea_can_be_created_via_sms
    user_params = {
      :phone => "+15172434516"
    }
    User.create(user_params)

    assert_equal 0, Idea.all.count

    url = '/sms'
    params = {
      :Body => "title :: description # cheese, steak, chicken",
      :From => "+15172434516"
    }

    get url, params

    assert_equal 1, Idea.all.count
    idea = Idea.all.last
    assert_equal "title", idea.title
    assert_equal "description", idea.description
    assert_equal "cheese, steak, chicken", idea.raw_tags
    assert_equal 1, idea.user_id
  end

  def test_an_idea_wont_be_created_via_sms_if_user_doesnt_exist
    user_params = {
      :id    => 1,
      :phone => "+15172434516"
    }
    User.create(user_params)

    assert_equal 0, Idea.all.count

    url = '/sms'
    params = {
      :Body => "title :: description # cheese, steak, chicken",
      :From => "+123"
    }

    get url, params

    assert_equal 0, Idea.all.count
    refute Idea.all.last
  end
end
