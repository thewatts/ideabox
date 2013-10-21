require './test/test_helper'
require './lib/idea_box/user'
require './lib/idea_box/user_store'

class UserTest < MiniTest::Test

  attr_reader :user, :attributes

  def setup
    @attributes = {
      :nickname => "thewatts",
      :name     => "Nathaniel",
      :image    => "http://google.com"
    }
    @user = User.new(attributes)
  end

  def test_it_exists
    assert User
  end

  def test_its_initializes_with_correct_attributes
    assert_equal "thewatts",               user.nickname
    assert_equal "Nathaniel",              user.name
    assert_equal "http://google.com",      user.image
  end

  def test_it_can_be_saved_to_the_database
    User.reset_table
    new_user = User.new(attributes)
    new_user.save
    assert_equal 1, User.all.count
    assert_equal 1, User.first.id
    assert_equal "thewatts", User.first.nickname
  end

  def test_it_can_update_its_attributes
    User.reset_table
    new_user = User.new(attributes)
    new_user.save
    assert_equal 1, User.all.count
    new_user.update_attributes(:nickname => "the_new_login")
    assert_equal "the_new_login", User.first.nickname
  end


end
