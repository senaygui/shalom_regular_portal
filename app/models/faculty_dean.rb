class FacultyDean < ApplicationRecord
  belongs_to :admin_user
  belongs_to :faculty
end
