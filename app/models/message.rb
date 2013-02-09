class Message < ActiveRecord::Base
  belongs_to :user
  default_scope order(:created_at)
end
