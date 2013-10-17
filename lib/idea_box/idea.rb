class Idea
  include Comparable

  attr_reader :id, :title, :description, :rank, :user_id

  def initialize(attributes = {})
    @id          = attributes["id"].to_i
    @title       = attributes["title"]
    @description = attributes["description"]
    @rank        = attributes["rank"] || 0
    @user_id     = attributes["user_id"].to_i
    @tags        = attributes["tags"]
  end

  def split_tags(tags)
    if tags
      tags.gsub(', ', ',').split(',')
    else
      []
    end
  end

  def save
    IdeaStore.create(to_h)
  end

  def tags
    split_tags(@tags)
  end

  def tags_original
    @tags
  end

  def to_h
    {
      "title"       => title,
      "description" => description,
      "rank"        => rank,
      "tags"        => tags_original,
      "user_id"     => user_id
    }
  end

  def like!
    @rank += 1
  end

  def <=>(other)
    other.rank <=> rank
  end

end
