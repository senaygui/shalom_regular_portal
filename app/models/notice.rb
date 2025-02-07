class Notice < ApplicationRecord
  
  belongs_to :admin_user

  validates :title, presence: true
  validates :body, presence: true
  validates :admin_user_id, presence: true

  def posted_by
    admin_user.name if admin_user
  end
end
