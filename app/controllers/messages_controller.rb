class MessagesController < ApplicationController
  def create
    message = Message.new(:body => params[:message], :user_id => current_user.id, :user_name => current_user.first_name)
    Pusher['draft'].trigger('chat', message) if message.save
    render :nothing => true
  end
end
