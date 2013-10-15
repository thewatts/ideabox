require './test/test_helper'
require './lib/idea_box'

describe IdeaStore do

  attr_reader :store

  def setup
    IdeaStore.create("id" => 1, "title" => "The Title", 
                     "description" => "The Description")
  end

  def teardown
    IdeaStore.destroy_db
  end

  it "has a database" do
    IdeaStore.database.must_be_kind_of YAML::Store
  end

  it "can destroy that database" do
    IdeaStore.all.count.must_equal 1
    IdeaStore.destroy_db
    IdeaStore.all.count.must_equal 0
  end

  it "can find all of the ideas in the database" do
    IdeaStore.all.count.must_equal 1
    IdeaStore.create("id" => "2", "title" => "The Title", 
                     "description" => "Description")
    IdeaStore.all.count.must_equal 2
  end

  it "can find an idea by its ID" do
    title = "The Title"
    id = 1
    idea = IdeaStore.find(id - 1)
    idea.title.must_equal title
  end

  it "can create ideas in the database from attributes" do
    IdeaStore.create("id" => "2", "title" => "The Title", 
                     "description" => "Description")
    IdeaStore.all.count.must_equal 2
  end

  it "can delete ideas in the database" do
    IdeaStore.create("id" => 2, "title" => "The Title", 
                     "description" => "The Description")
    IdeaStore.all.count.must_equal 2
    IdeaStore.delete(1)
    IdeaStore.all.count.must_equal 1
  end

  it "can update ideas in the database" do
    new_title = "The New Title!"
    IdeaStore.update(0, "title" => new_title)
    IdeaStore.find(0).title.must_equal new_title
  end


end
