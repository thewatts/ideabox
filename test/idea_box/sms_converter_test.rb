require './test/test_helper'
require './lib/idea_box/sms_converter'

class SMSToIdeaConverterTest < MiniTest::Test

  def test_it_exists
    assert SMSToIdeaConverter
  end

  def test_it_takes_in_a_raw_message
    converter = SMSToIdeaConverter.convert("message")
    assert_equal "message", SMSToIdeaConverter.raw
  end

  def test_it_splits_an_sms_body_by_double_colon
    message = "title :: description"
    SMSToIdeaConverter.convert(message)
    assert_equal "title", SMSToIdeaConverter.idea.title
    assert_equal "description", SMSToIdeaConverter.idea.description
  end

  def test_it_splits_an_sms_into_title_description_and_tags
    message = "title :: description # cheese, steak, chicken"
    SMSToIdeaConverter.convert(message)
    assert_equal "title", SMSToIdeaConverter.idea.title
    assert_equal "description", SMSToIdeaConverter.idea.description
    assert_equal "cheese, steak, chicken", SMSToIdeaConverter.idea.raw_tags
  end

end
