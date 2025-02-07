class Dropcourse < ApplicationRecord
  belongs_to :student
  belongs_to :course
  belongs_to :department

  enum status: {
    pending: 0,
    approved: 1,
    archived: 2,
    applied: 3
  }, _prefix: 'drop_course'
end
