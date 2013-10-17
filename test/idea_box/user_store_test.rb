require './test/test_helper'
require './lib/idea_box/user'
require './lib/idea_box/user_store'

class UserStoreTest < MiniTest::Test

  attr_reader :store

  def setup
    UserStore.create(
      "login"      => "thewatts",
      "password"   => "asdf",
      "email"      => "reg@nathanielwatts.com",
      "created_at" => time,
      "updated_at" => time,
      "first_name" => "Nathaniel",
      "last_name"  => "Watts"
    )
  end

  def teardown
    UserStore.destroy_db
  end

  def test_it_exists
    assert UserStore
  end

  def test_it_has_a_database
    assert_kind_of YAML::Store, UserStore.database
  end

  def test_it_can_destroy_its_database
    assert_equal 1, UserStore.all.count
    UserStore.destroy_db
    assert_equal 0, UserStore.all.count
  end

  def test_it_can_find_all_of_the_ideas_in_the_database
    assert_equal 1, UserStore.all.count
    UserStore.create("title" => "The Title",
                     "description" => "Description")
    assert_equal 2, UserStore.all.count
  end

  def test_it_can_find_an_idea_by_the_id
    login = "THEWATTS"
    id = 1
    idea = UserStore.find(id)
    assert_equal login.downcase, idea.login
  end

  def test_it_can_create_ideas_in_the_database_from_attributes
    UserStore.create("title" => "The Title",
                     "description" => "Description")
    assert_equal 2, UserStore.all.count
  end

  def test_it_can_delete_ideas_from_the_database
    UserStore.create("title" => "The Title",
                     "description" => "The Description")
    assert_equal 2, UserStore.all.count
    UserStore.delete(1)
    assert_equal 1, UserStore.all.count
  end

  def test_it_can_update_ideas_in_the_database
    login = "LOGIN!"
    UserStore.update(1, "login" => login)
    assert_equal login.downcase, UserStore.find(1).login
  end

  def test_it_can_find_the_next_id
    UserStore.create("login" => "user-login")
    assert_equal 3, UserStore.next_id
  end

end
