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
    @idea = Idea.create(attributes)
  end

  def test_it_exists
    assert Idea
  end

  def test_it_can_be_created_with_the_correct_attributes
    assert_equal "The Title", idea.title
    assert_equal "The Description of this Idea", idea.description
    assert_equal 0, idea.rank
  end

  def test_it_can_be_liked_increasing_its_like_count_by_1
    assert_equal 0, idea.rank
    idea.like!

    assert_equal 1, idea.rank
    assert_equal "The Title", idea.title
    assert_equal "The Description of this Idea", idea.description
    assert_equal "life, work, pizza, cheese", idea.raw_tags
  end

  def test_it_can_put_its_attributes_into_a_hash
    skip
    hash = {
      "title" => "The Title",
      "description" => "The Description of this Idea",
      "rank" => 0,
      "idea_id" => 0
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

  def test_it_can_be_saved_to_the_database
    Idea.reset_table
    attributes = {
      "title" => "The Title",
      "description" => "The Description"
    }
    new_idea = Idea.new(attributes)
    new_idea.save
    assert_equal 1, Idea.all.count
    assert_equal 1, Idea.first.id
  end

  def test_it_can_update_its_attributes
    Idea.reset_table
    attributes = {
      "title" => "The Title",
      "description" => "The Description"
    }
    new_idea = Idea.new(attributes)
    new_idea.save
    assert_equal 1, Idea.all.count
    new_idea.update_attributes("title" => "The New Title")
    assert_equal "The New Title", Idea.first.title
  end

end
