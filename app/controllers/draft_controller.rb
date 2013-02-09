class DraftController < ApplicationController
  def index
    @messages = Message.all
    render :layout => false
  end
end
