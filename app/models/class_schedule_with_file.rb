class ClassScheduleWithFile < ApplicationRecord
    has_one_attached :file_attachment
    validates :name, presence: true
end
