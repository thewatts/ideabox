require './lib/idea_box/idea'

module SMSToIdeaConverter

  class << self
    attr_reader :raw, :title, :description, :tags, :idea
  end

  def self.convert(sms_body)
    reset_values
    @raw = sms_body
    parse_sms_body
    self
  end

  def self.reset_values
    @title, @description, @tags = ""
  end

  def self.parse_sms_body
    check_for_description
    check_for_tags
    create_new_idea
  end

  def self.create_new_idea
    attributes = {
      "title"       => @title,
      "description" => @description,
      "tags"        => @tags
    }
    @idea = Idea.new(attributes)
  end

  def self.check_for_description
    if raw.include?("::")
      parts = raw.split("::")
      @title = parts[0].strip
      @description = parts[1].split(" # ").first.strip
    else
      @title = raw
      @description = ""
    end
  end

  def self.check_for_tags
    if raw.include?(" # ")
      @tags = raw.split(" # ").last
    else
      @tags = ""
    end
  end


end
