require './test/test_helper'
require './lib/idea_box'

class UserStoreTest < MiniTest::Test

  User.destroy_db if User.database

  attr_reader :store

  def setup
    User.create(
      :nickname => "thewatts",
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
    User.reset_table
    assert_equal 0, User.all.count
  end

  def test_it_can_find_all_of_the_ideas_in_the_database
    assert_equal 1, User.all.count
    User.create(:nickname => "thenewlogin",
                :email => "newemail")
    assert_equal 2, User.all.count
  end

  def test_it_can_find_an_idea_by_the_id
    nickname = "THEWATTS"
    id = 1
    idea = User.find(id)
    assert_equal nickname.downcase, idea.nickname
  end

  def test_it_can_create_ideas_in_the_database_from_attributes
    User.create(:nickname => "the_new_login",
                :mail     => "email@example.com")
    assert_equal 2, User.all.count
  end

  def test_it_can_delete_ideas_from_the_database
    User.create(:nickname => "nickname")
    assert_equal 2, User.all.count
    User.delete(1)
    assert_equal 1, User.all.count
  end

  def test_it_can_update_ideas_in_the_database
    nickname = "login"
    User.update(1, :nickname => nickname)
    assert_equal nickname, User.find(1).nickname
  end

  def test_it_can_find_the_next_id
    User.create("nickname" => "user-login")
    assert_equal 3, User.next_id
  end

  def test_it_can_find_first_or_create_by_uid_and_params
    User.reset_table
    assert_equal 0, User.all.count

    uid_hash   = { :uid => "1234" }
    attributes = {
      :uid      => "1234",
      :nickname => "thewatts",
      :name     => "Nathaniel Watts",
      :image    => "http://google.com/"
    }
    User.first_or_create(uid_hash, attributes)

    assert_equal 1, User.all.count
    assert_equal 1, User.all.first.id
    assert_equal "1234", User.all.first.uid

    User.first_or_create(uid_hash, attributes)
    assert_equal 1, User.all.count

    uid_hash   = { :uid => "4567" }
    attributes = {
      :uid      => "4567",
      :nickname => "thewatts",
      :name     => "Nathaniel Watts",
      :image    => "http://google.com/"
    }
    User.first_or_create(uid_hash, attributes)

    assert_equal 2, User.all.count
    assert_equal "4567", User.find(2).uid
  end

  def test_it_can_find_by_nickname
    user = User.find_by_nickname("thewatts")
    assert_equal "thewatts", user.nickname
  end

end
