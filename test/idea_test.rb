require './test/test_helper'

describe Idea do

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

  it "can be created with no arguments" do
    Idea.new.must_be_kind_of Idea
    Idea.new.must_respond_to :id
    Idea.new.must_respond_to :title
    Idea.new.must_respond_to :description
    Idea.new.must_respond_to :rank
  end

  it "can be created with the correct attributes" do
    idea.id.must_equal "1"
    idea.title.must_equal "The Title"
    idea.description.must_equal "The Description of this Idea"
    idea.rank.must_equal 0
  end

  it "can be liked, increasing its like count by 1" do
    idea.rank.must_equal 0
    idea.like!
    idea.rank.must_equal 1
  end

  it "can put its attributes into a hash" do
    hash = {
      "title" => "The Title",
      "description" => "The Description of this Idea",
      "rank" => 0
    }
    idea.to_h.must_equal hash
  end

end
