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
    find(object.id)
  end

  def update(id, data)
    database.transaction do |db|
      object = db[table].select { |object| object.id == id}.first
      update_object_attributes(object, data)
    end
  end

  def delete(id)
    database.transaction do |db|
      db[table].delete_if { |object| object.id == id }
    end
  end

  def update_object_attributes(object, data)
    data = data.except("id") if data.include?("id")
    data.each do |attribute, value|
      object.send "#{attribute}=".to_sym, value
    end
  end

  def find_object_index(object)
    all.index(object)
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

  def first
    all.first
  end

  def last
    all.last
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

  def reset_table
    database.transaction do |db|
      db[table] = []
    end
  end

  def destroy_db
    @database = nil
    unless ENV['RACK_ENV'] == 'test'
      File.delete('./db/ideabox') if File.exists?('./db/ideabox')
    else
      File.delete('./test/db/ideabox') if File.exists?('./test/db/ideabox')
    end
  end

end
