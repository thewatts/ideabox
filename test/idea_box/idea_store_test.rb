require './test/test_helper'
require './lib/idea_box/idea'

class IdeaStoreTest < MiniTest::Test

  attr_reader :store

  def setup
    Idea.create("id" => 1, "title" => "The Title",
                "description" => "The Description", "user_id" => 1)
  end

  def teardown
    Idea.reset_table
  end

  def test_it_has_a_database
    assert_kind_of YAML::Store, Idea.database
  end

  def test_it_can_destroy_its_database
    assert_equal 1, Idea.all.count
    Idea.destroy_db
    assert_equal 0, Idea.all.count
  end

  def test_it_can_find_all_of_the_ideas_in_the_database
    assert_equal 1, Idea.all.count
    Idea.create("title" => "The Title",
                     "description" => "Description")
    assert_equal 2, Idea.all.count
  end

  def test_it_can_find_an_idea_by_the_id
    title = "The Title"
    id = 1
    idea = Idea.find(id)
    assert_equal title, idea.title
  end

  def test_it_can_create_ideas_in_the_database_from_attributes
    Idea.create("title" => "The Title",
                     "description" => "Description")
    assert_equal 2, Idea.all.count
  end

  def test_it_can_delete_ideas_from_the_database
    Idea.create("title" => "The Title",
                     "description" => "The Description")
    assert_equal 2, Idea.all.count
    Idea.delete(1)
    assert_equal 1, Idea.all.count
  end

  def test_it_can_update_ideas_in_the_database
    new_title = "The New Title!"
    Idea.update(1, "title" => new_title)

    assert_equal new_title, Idea.find(1).title
  end

  def test_it_can_find_the_next_id
    Idea.create("title" => "The Title",
                "description" => "The Description")

    assert_equal 3, Idea.next_id
  end

  def test_it_can_get_all_the_tags_from_items
    Idea.create("title" => "The Title",
                     "description" => "The Description",
                     "tags" => "home, life, chicken, cheese, food")
    Idea.create("title" => "The Title",
                     "description" => "The Description",
                     "tags" => "curry, chicken, cheese, food, weema")
    tags = ["curry", "chicken", "cheese", "food", "weema", "home", "life"]

    assert_equal tags.count, Idea.tags.count
    assert_equal tags.sort,  Idea.tags
  end

  def test_it_can_find_an_idea_from_the_store_by_tag
    Idea.create("title" => "The First Idea",
                     "description" => "The First Description",
                     "tags" => "home, life, chicken, cheese, food")
    Idea.create("title" => "The Second Title",
                     "description" => "The Second Description",
                     "tags" => "curry, chicken, cheese, food, weema")

    assert_equal "The First Idea", Idea.find_all_by_tag("home")[0].title
    assert_equal 1, Idea.find_all_by_tag("home").count
    assert_equal 2, Idea.find_all_by_tag("chicken").count
    assert_equal 1, Idea.find_all_by_tag("weema").count
  end

  def test_it_can_find_an_idea_from_the_store_by_tag
    Idea.create("title" => "The First Idea",
                     "description" => "The First Description",
                     "tags" => "home, life")
    Idea.create("title" => "The Second Title",
                     "description" => "The Second Description",
                     "tags" => "curry, life")
    idea1 = Idea.find(2)
    idea2 = Idea.find(3)
    group = {
      "curry" => [idea1],
      "home"  => [idea2],
      "life"  => [idea1, idea2]
    }

    assert_equal group, Idea.group_by_tags
  end

end
