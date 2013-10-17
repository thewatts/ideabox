require 'test_helper'
require './lib/idea_box/user'
require './lib/idea_box/user_store'

class UserTest < MiniTest::Test

  attr_reader :user, :time

  def setup
    @time = Time.now.utc
    attributes = {
      "id"         => 1,
      "login"      => "TheWatts",
      "password"   => "asdf",
      "email"      => "REG@nathanielwatts.com",
      "created_at" => time,
      "updated_at" => time,
      "first_name" => "Nathaniel",
      "last_name"  => "Watts"
    }
    @user = User.new(attributes)
  end

  def test_it_exists
    assert User
  end

  def test_its_initializes_with_correct_attributes
    assert_equal "thewatts",               user.login
    assert_equal "reg@nathanielwatts.com", user.email
    assert_equal "Nathaniel",              user.first_name
    assert_equal "Watts",                  user.last_name
    assert_equal time,                     user.created_at
    assert_equal time,                     user.updated_at
  end

  def test_it_can_store_its_attributes_in_a_hash
    attributes = {
      "id"         => 1,
      "login"      => "thewatts",
      "password"   => "asdf",
      "email"      => "reg@nathanielwatts.com",
      "created_at" => time,
      "updated_at" => time,
      "first_name" => "Nathaniel",
      "last_name"  => "Watts"
    }
    assert_equal attributes, user.to_h
  end

  def test_it_can_be_saved_to_the_database
    attributes = {
      "login"      => "thewatts",
      "password"   => "asdf",
      "email"      => "reg@nathanielwatts.com",
      "created_at" => time,
      "updated_at" => time,
      "first_name" => "Nathaniel",
      "last_name"  => "Watts"
    }
    new_user = User.new(attributes)
    UserStore
  end


end