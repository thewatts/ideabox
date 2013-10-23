require './lib/idea_box/data_store'

class Idea
  extend DataStore
  include Comparable

  class << self

    def table
      "ideas"
    end

    def klass
      Idea
    end

    def tags
      all.collect do |idea|
        idea.tags.collect do |tag|
          tag
        end
      end.flatten.uniq.sort
    end

    def find_all_by_tag(tag)
      all.find_all { |idea| idea.tags.include? tag }
    end

    def find_all_by_user_id(id)
      all.find_all { |idea| idea.user_id == id }
    end

    def group_by_tags
      tags.each_with_object({}) do |tag, group|
        group[tag] = find_all_by_tag(tag)
      end
    end

  end

  attr_accessor :id, :title, :description, :rank,
                :user_id, :created_at, :updated_at

  def initialize(attributes = {})
    @title       = attributes["title"]
    @description = attributes["description"]
    @rank        = attributes["rank"] || 0
    @user_id     = attributes["user_id"]
    @tags        = attributes["tags"]
  end

  def save
    Idea.create(self)
  end

  def update_attributes(hash)
    self.class.update(self.id, hash)
  end

  def split_tags(tags)
    if tags
      tags.gsub(', ', ',').split(',')
    else
      []
    end
  end

  def tags
    split_tags(@tags)
  end

  def raw_tags
    @tags
  end

  def like!
    @rank += 1
    update_attributes(rank: @rank)
  end

  def <=>(other)
    other.rank <=> rank
  end

  def to_h
    {
      :title       => title,
      :description => description,
      :tags        => raw_tags,
      :rank        => rank,
      :user_id     => user_id,
      :created_at  => created_at,
      :updated_at  => updated_at,
    }
  end

end
