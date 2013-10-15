require './test/test_helper'
require './lib/idea_box'

class IdeaStoreTest < MiniTest::Test

  attr_reader :store

  def setup
    IdeaStore.create("id" => 1, "title" => "The Title",
                     "description" => "The Description")
  end

  def teardown
    IdeaStore.destroy_db
  end

  def test_it_has_a_database
    assert_kind_of YAML::Store, IdeaStore.database
  end

  def test_it_can_destroy_its_database
    assert_equal 1, IdeaStore.all.count
    IdeaStore.destroy_db
    assert_equal 0, IdeaStore.all.count
  end

  def test_it_can_find_all_of_the_ideas_in_the_database
    assert_equal 1, IdeaStore.all.count
    IdeaStore.create("id" => "2", "title" => "The Title",
                     "description" => "Description")
    assert_equal 2, IdeaStore.all.count
  end

  def test_it_can_find_an_idea_by_the_id
    title = "The Title"
    id = 1
    idea = IdeaStore.find(id - 1)
    assert_equal title, idea.title
  end

  def test_it_can_create_ideas_in_the_database_from_attributes
    IdeaStore.create("id" => "2", "title" => "The Title",
                     "description" => "Description")
    assert_equal 2, IdeaStore.all.count
  end

  def test_it_can_delete_ideas_from_the_database
    IdeaStore.create("id" => 2, "title" => "The Title",
                     "description" => "The Description")
    assert_equal 2, IdeaStore.all.count
    IdeaStore.delete(1)
    assert_equal 1, IdeaStore.all.count
  end

  def test_it_can_update_ideas_in_the_database
    new_title = "The New Title!"
    IdeaStore.update(0, "title" => new_title)
    assert_equal new_title, IdeaStore.find(0).title
  end


end
