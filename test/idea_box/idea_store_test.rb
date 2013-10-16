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
    IdeaStore.create("title" => "The Title",
                     "description" => "Description")
    assert_equal 2, IdeaStore.all.count
  end

  def test_it_can_find_an_idea_by_the_id
    title = "The Title"
    id = 1
    idea = IdeaStore.find(id)
    assert_equal title, idea.title
  end

  def test_it_can_create_ideas_in_the_database_from_attributes
    IdeaStore.create("title" => "The Title",
                     "description" => "Description")
    assert_equal 2, IdeaStore.all.count
  end

  def test_it_can_delete_ideas_from_the_database
    IdeaStore.create("title" => "The Title",
                     "description" => "The Description")
    assert_equal 2, IdeaStore.all.count
    IdeaStore.delete(1)
    assert_equal 1, IdeaStore.all.count
  end

  def test_it_can_update_ideas_in_the_database
    new_title = "The New Title!"
    IdeaStore.update(1, "title" => new_title)
    assert_equal new_title, IdeaStore.find(1).title
  end

  def test_it_can_find_the_next_id
    IdeaStore.create("title" => "The Title",
                     "description" => "The Description")
    assert_equal 3, IdeaStore.next_id
  end

  def test_it_can_get_all_the_tags_from_items
    IdeaStore.create("title" => "The Title",
                     "description" => "The Description",
                     "tags" => "home, life, chicken, cheese, food")
    IdeaStore.create("title" => "The Title",
                     "description" => "The Description",
                     "tags" => "curry, chicken, cheese, food, weema")
    tags = ["curry", "chicken", "cheese", "food", "weema", "home", "life"]
    assert_equal tags.count, IdeaStore.tags.count
    assert_equal tags.sort,  IdeaStore.tags
  end

  def test_it_can_find_an_idea_from_the_store_by_tag
    IdeaStore.create("title" => "The First Idea",
                     "description" => "The First Description",
                     "tags" => "home, life, chicken, cheese, food")
    IdeaStore.create("title" => "The Second Title",
                     "description" => "The Second Description",
                     "tags" => "curry, chicken, cheese, food, weema")
    assert_equal "The First Idea", IdeaStore.find_all_by_tag("home")[0].title
    assert_equal 1, IdeaStore.find_all_by_tag("home").count
    assert_equal 2, IdeaStore.find_all_by_tag("chicken").count
    assert_equal 1, IdeaStore.find_all_by_tag("weema").count
  end

  def test_it_can_find_an_idea_from_the_store_by_tag
    IdeaStore.create("title" => "The First Idea",
                     "description" => "The First Description",
                     "tags" => "home, life")
    IdeaStore.create("title" => "The Second Title",
                     "description" => "The Second Description",
                     "tags" => "curry, life")
    idea1 = IdeaStore.find(2)
    idea2 = IdeaStore.find(3)
    group = {
      "curry" => [idea1],
      "home"  => [idea2],
      "life"  => [idea1, idea2]
    }
    assert_equal group, IdeaStore.group_by_tags
  end

end
