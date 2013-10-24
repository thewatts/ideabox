require './lib/idea_box/sms_converter'

class IdeaBoxApp < Sinatra::Base

  get '/sms' do
    sender = User.find_by_phone(params["From"])

    return send_sms_response(sms_error) unless sender

    if create_idea_from_sms(params["Body"], sender)
      message = idea_success(sender)
    else
      message = idea_fail(sender)
    end

    send_sms_response(message)
  end

  def create_idea_from_sms(sms_body, sender)
    idea = SMSToIdeaConverter.convert(sms_body).idea
    idea.user_id = sender.id
    idea.save
    data = {
      :idea => idea.to_h,
      :user => {
        :name  => sender.name,
        :image => sender.image
      }
    }
    Pusher['activity_channel'].trigger('new_idea', :data => data)
    idea
  end

  def sms_error
    "Sorry, looks like you're not able to post via text. " +
    "Try adding your phone in your account settings."
  end

  def idea_success(sender)
    "Thanks, #{sender.name}! '#{sender.ideas.last.title}' was created!"
  end

  def idea_fail(sender)
    "OOPS, sorry #{sender.name}, looks like something went awry. " +
    "Maybe try again in a little bit?"
  end

  def send_sms_response(message)
    twiml = Twilio::TwiML::Response.new { |r| r.Message message }
    twiml.text
  end

end
