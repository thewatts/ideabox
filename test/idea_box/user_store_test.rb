require './test/test_helper'
require './lib/idea_box/user'

class UserTest < MiniTest::Test

  attr_reader :store

  def setup
    User.create(
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
    User.reset_table
  end

  def test_it_exists
    assert User
  end

  def test_it_has_a_database
    assert_kind_of YAML::Store, User.database
  end

  def test_it_can_destroy_its_database
    assert_equal 1, User.all.count
    User.destroy_db
    assert_equal 0, User.all.count
  end

  def test_it_can_find_all_of_the_ideas_in_the_database
    assert_equal 1, User.all.count
    User.create("login" => "thenewlogin",
                "email" => "newemail")
    assert_equal 2, User.all.count
  end

  def test_it_can_find_an_idea_by_the_id
    login = "THEWATTS"
    id = 1
    idea = User.find(id)
    assert_equal login.downcase, idea.login
  end

  def test_it_can_create_ideas_in_the_database_from_attributes
    User.create("title" => "The Title",
                     "description" => "Description")
    assert_equal 2, User.all.count
  end

  def test_it_can_delete_ideas_from_the_database
    User.create("title" => "The Title",
                     "description" => "The Description")
    assert_equal 2, User.all.count
    User.delete(1)
    assert_equal 1, User.all.count
  end

  def test_it_can_update_ideas_in_the_database
    login = "LOGIN!"
    User.update(1, "login" => login)
    assert_equal login.downcase, User.find(1).login
  end

  def test_it_can_find_the_next_id
    User.create("login" => "user-login")
    assert_equal 3, User.next_id
  end

end
