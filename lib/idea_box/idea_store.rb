require './lib/idea_box/idea'
require 'yaml/store'

class IdeaStore

  def self.create(attributes)
    id = next_id
    database.transaction do
      database['ideas'] << {"id" => id}.merge(attributes)
    end
  end

  def self.next_id
    unless all.empty?
      all.map(&:id).max + 1
    else
      1 # starting ID is 1
    end
  end

  def self.destroy_db
    @database = nil
    File.delete('./test/db/ideabox') if ENV["RACK_ENV"] == "test"
    File.delete('./db/ideabox') if ENV["RACK_ENV"]      != "test"
  end

  def self.all
    raw_ideas.collect { |data| Idea.new(data) }
  end

  def self.tags
    all.collect do |idea|
      idea.tags.collect do |tag|
        tag
      end
    end.flatten.uniq.sort
  end

  def self.find_all_by_tag(tag)
    all.find_all { |idea| idea.tags.include? tag }
  end

  def self.group_by_tags
    tags.each_with_object({}) do |tag, group|
      group[tag] = find_all_by_tag(tag)
    end
  end

  def self.raw_ideas
    database.transaction do |db|
      db['ideas'] || []
    end
  end

  def self.database
    return @database if @database

    @database = YAML::Store.new "db/ideabox"      if ENV["RACK_ENV"] != "test"
    @database = YAML::Store.new "test/db/ideabox" if ENV["RACK_ENV"] == "test"
    @database.transaction do
      @database['ideas'] ||= []
    end
    @database
  end

  def self.delete(position)
    database.transaction do
      database['ideas'].delete_at(position)
    end
  end

  def self.find(id)
    raw_idea = find_raw_idea(id)
    Idea.new(raw_idea)
  end

  def self.find_raw_idea(id)
    database.transaction do
      database['ideas'].at(id - 1)
    end
  end

  def self.update(id, data)
    database.transaction do
      database['ideas'][id - 1] = data
    end
  end

  def database
    IdeaStore.database
  end

end
