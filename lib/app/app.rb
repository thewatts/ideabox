class IdeaBoxApp

  get '/' do
    if current_user
      redirect '/activity'
    else
      haml :home, :layout => false
    end
  end

end
