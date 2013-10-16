class Idea
  include Comparable

  attr_reader :title, :description, :rank, :id

  def initialize(attributes = {})
    @id          = attributes["id"].to_i
    @title       = attributes["title"]
    @description = attributes["description"]
    @rank        = attributes["rank"] || 0
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

  def to_h
    {
      "title"       => title,
      "description" => description,
      "rank"        => rank
    }
  end

  def like!
    @rank += 1
  end

  def <=>(other)
    other.rank <=> rank
  end

end
