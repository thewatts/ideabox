require './lib/idea_box/idea'
require 'yaml/store'

class UserStore

  def self.create(attributes)
    id = next_id
    database.transaction do
      database['users'] << {"id" => id}.merge(attributes)
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
    raw_users.collect { |data| User.new(data) }
  end

  def self.raw_users
    database.transaction do |db|
      db['users'] || []
    end
  end

  def self.database
    return @database if @database

    @database = YAML::Store.new "db/ideabox"      if ENV["RACK_ENV"] != "test"
    @database = YAML::Store.new "test/db/ideabox" if ENV["RACK_ENV"] == "test"
    @database.transaction do
      @database['users'] ||= []
    end
    @database
  end

  def self.delete(id)
    database.transaction do
      database['users'].delete_at(id - 1)
    end
  end

  def self.find(id)
    raw_idea = find_raw_idea(id)
    User.new(raw_idea)
  end

  def self.find_raw_idea(id)
    database.transaction do
      database['users'].at(id - 1)
    end
  end

  def self.update(id, data)
    database.transaction do
      database['users'][id - 1] = data
    end
  end

  def database
    UserStore.database
  end

end
