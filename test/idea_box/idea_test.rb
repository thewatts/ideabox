require './test/test_helper'
require './lib/idea_box/idea'

class IdeaTest < MiniTest::Test

  attr_reader :idea

  def setup
    attributes = {
      "id" => "1",
      "title" => "The Title",
      "description" => "The Description of this Idea",
      "rank" => 0
    }
    @idea = Idea.new(attributes)
  end

  def test_it_can_be_created_with_no_arguments
    idea = Idea.new
    assert_kind_of Idea, idea 
  end

  def test_it_can_be_created_with_the_correct_attributes
    assert_equal "1", idea.id
    assert_equal "The Title", idea.title
    assert_equal "The Description of this Idea", idea.description
    assert_equal 0, idea.rank
  end

  def test_it_can_be_liked_increasing_its_like_count_by_1
    assert_equal 0, idea.rank
    idea.like!
    assert_equal 1, idea.rank
  end

  def test_it_can_put_its_attributes_into_a_hash
    hash = {
      "title" => "The Title",
      "description" => "The Description of this Idea",
      "rank" => 0
    }
    assert_equal hash, idea.to_h
  end

  it "can take in and split tags" do
    idea = Idea.new("tags" => "cool things, chicken, cheesy potatoes & gravy")
    idea.tags.count.must_equal 3
    idea.tags.must_include "cool things"
    idea.tags.must_include "chicken"
    idea.tags.must_include "cheesy potatoes & gravy"
  end

end
