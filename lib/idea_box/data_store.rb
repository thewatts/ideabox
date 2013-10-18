require 'yaml/store'

module DataStore

  def create(data)
    object            = parse(data)
    object.id         = next_id
    object.created_at = time_now
    object.updated_at = time_now

    database.transaction do |db|
      db[table] << object
    end
  end

  def parse(data)
    if data.class == Hash
      data = klass.new(data)
    end
    data
  end

  def time_now
    Time.now.utc
  end

  def next_id
    unless all.empty?
      all.map(&:id).max + 1
    else
      1 # return 1 as the starting id if first item
    end
  end

  def all
    database.transaction do |db|
      db[table]
    end
  end

  def database
    return @database if @database

    set_database
    load_database

    @database
  end

  def set_database
    unless ENV['RACK_ENV'] == 'test'
      @database = YAML::Store.new 'db/ideabox'
    else
      @database = YAML::Store.new 'test/db/ideabox'
    end
  end

  def load_database
    database.transaction do |db|
      db[table] ||= []
    end
  end

  def find(id)
    database.transaction do |db|
      db[table].find { |item| item.id == id }
    end
  end


end
