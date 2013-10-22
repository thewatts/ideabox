require './test/test_helper'
require './lib/idea_box'
require 'pry'

class UserTest < MiniTest::Test

  attr_reader :user, :attributes

  def setup
    User.destroy_db
    Idea.destroy_db
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

  def test_it_can_return_its_items
    new_user = User.create(attributes)
    idea1 = Idea.create(
      "title" => "go do things", "description" => "like swimming",
      "user_id" => new_user.id)
    idea2 = Idea.create(
      "title" => "go do more things", "description" => "like running",
      "user_id" => new_user.id)

    assert_equal [idea1, idea2], new_user.ideas
  end

  def test_it_can_be_found_by_phone_number
    attributes = @attributes.merge({:phone => "123-123-1234"})
    new_user = User.create(attributes)
    assert_equal new_user.id, User.find_by_phone("123-123-1234").id
  end

end
