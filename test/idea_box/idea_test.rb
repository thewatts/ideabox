require './test/test_helper'
require './lib/idea_box/idea'

class IdeaTest < MiniTest::Test

  attr_reader :idea

  def setup
    attributes = {
      "id"          => 1,
      "title"       => "The Title",
      "description" => "The Description of this Idea",
      "rank"        => 0,
      "tags"        => "life, work, pizza, cheese"
    }
    @idea = Idea.new(attributes)
  end

  def test_it_exists
    assert Idea
  end

  def test_it_can_be_created_with_the_correct_attributes
    assert_equal 1, idea.id
    assert_equal "The Title", idea.title
    assert_equal "The Description of this Idea", idea.description
    assert_equal 0, idea.rank
  end

  def test_it_can_be_liked_increasing_its_like_count_by_1
    assert_equal 0, idea.rank
    idea.like!
    assert_equal 1, idea.rank
    assert_equal 1, idea.id
    assert_equal "The Title", idea.title
    assert_equal "The Description of this Idea", idea.description
    assert_equal "life, work, pizza, cheese", idea.tags_original
  end

  def test_it_can_put_its_attributes_into_a_hash
    hash = {
      "title" => "The Title",
      "description" => "The Description of this Idea",
      "rank" => 0,
      "user_id" => 0
    }
    assert_equal hash, idea.to_h
  end

  def testit_can_take_in_and_split_tags
    idea = Idea.new("tags" => "cool things, chicken, cheesy potatoes & gravy")
    assert_equal 3, idea.tags.count
    assert idea.tags.include "cool things"
    assert idea.tags.include "chicken"
    assert idea.tags.include "cheesy potatoes & gravy"
  end

end
