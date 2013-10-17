require './test/test_helper'
require './lib/user'

class UserStoreTest < MiniTest::Test

  attr_reader :store

  def setup
    UserStore.create("id" => 1, "title" => "The Title",
                     "description" => "The Description")
  end

  def teardown
    UserStore.destroy_db
  end

  def test_it_exists
    assert UserStore
  end

  def test_it_has_a_database
    assert_kind_of YAML::Store, UserStore.database
  end

  def test_it_can_destroy_its_database
    assert_equal 1, UserStore.all.count
    UserStore.destroy_db
    assert_equal 0, UserStore.all.count
  end

  def test_it_can_find_all_of_the_ideas_in_the_database
    assert_equal 1, UserStore.all.count
    UserStore.create("title" => "The Title",
                     "description" => "Description")
    assert_equal 2, UserStore.all.count
  end

  def test_it_can_find_an_idea_by_the_id
    title = "The Title"
    id = 1
    idea = UserStore.find(id)
    assert_equal title, idea.title
  end

  def test_it_can_create_ideas_in_the_database_from_attributes
    UserStore.create("title" => "The Title",
                     "description" => "Description")
    assert_equal 2, UserStore.all.count
  end

  def test_it_can_delete_ideas_from_the_database
    UserStore.create("title" => "The Title",
                     "description" => "The Description")
    assert_equal 2, UserStore.all.count
    UserStore.delete(1)
    assert_equal 1, UserStore.all.count
  end

  def test_it_can_update_ideas_in_the_database
    new_title = "The New Title!"
    UserStore.update(1, "title" => new_title)
    assert_equal new_title, UserStore.find(1).title
  end

  def test_it_can_find_the_next_id
    UserStore.create("title" => "The Title",
                     "description" => "The Description")
    assert_equal 3, UserStore.next_id
  end

  def test_it_can_get_all_the_tags_from_items
    UserStore.create("title" => "The Title",
                     "description" => "The Description",
                     "tags" => "home, life, chicken, cheese, food")
    UserStore.create("title" => "The Title",
                     "description" => "The Description",
                     "tags" => "curry, chicken, cheese, food, weema")
    tags = ["curry", "chicken", "cheese", "food", "weema", "home", "life"]
    assert_equal tags.count, UserStore.tags.count
    assert_equal tags.sort,  UserStore.tags
  end

  def test_it_can_find_an_idea_from_the_store_by_tag
    UserStore.create("title" => "The First Idea",
                     "description" => "The First Description",
                     "tags" => "home, life, chicken, cheese, food")
    UserStore.create("title" => "The Second Title",
                     "description" => "The Second Description",
                     "tags" => "curry, chicken, cheese, food, weema")
    assert_equal "The First Idea", UserStore.find_all_by_tag("home")[0].title
    assert_equal 1, UserStore.find_all_by_tag("home").count
    assert_equal 2, UserStore.find_all_by_tag("chicken").count
    assert_equal 1, UserStore.find_all_by_tag("weema").count
  end

  def test_it_can_find_an_idea_from_the_store_by_tag
    UserStore.create("title" => "The First Idea",
                     "description" => "The First Description",
                     "tags" => "home, life")
    UserStore.create("title" => "The Second Title",
                     "description" => "The Second Description",
                     "tags" => "curry, life")
    idea1 = UserStore.find(2)
    idea2 = UserStore.find(3)
    group = {
      "curry" => [idea1],
      "home"  => [idea2],
      "life"  => [idea1, idea2]
    }
    assert_equal group, UserStore.group_by_tags
  end

end
