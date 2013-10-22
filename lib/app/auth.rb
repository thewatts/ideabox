class IdeaBoxApp < Sinatra::Base

  use OmniAuth::Strategies::Twitter,
    'Hxa2BN3YRedsQRXCrYHFA', 'EG9wDKRsAOyXcTSlglDC8JcCq9vVINl4ScDKaG9pQ'

  get '/auth/twitter/callback' do
    auth = request.env["omniauth.auth"]
    user = User.first_or_create(
      {:uid => auth["uid"]},
      {
        :uid        => auth["uid"],
        :nickname   => auth["info"]["nickname"],
        :name       => auth["info"]["name"],
        :image      => auth["info"]["image"]
      }
    )

    session[:user_id] = user.id
    redirect '/'
  end

  ["/login/?", "/signup/?"].each do |path|
    get path do
      redirect '/auth/twitter'
    end
  end

  get '/logout' do
    session[:user_id] = nil
    redirect '/'
  end

end
