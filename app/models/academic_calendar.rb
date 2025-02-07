class AcademicCalendar < ApplicationRecord
	##validations
    validates :calender_year_in_gc, :presence => true
    validates :calender_year_in_ec, :presence => true
	  validates :calender_year, :presence => true
		validates :starting_date, :presence => true
		validates :ending_date, :presence => true
		validates :admission_type, :presence => true
		validates :study_level, :presence => true

	##scope
  	scope :recently_added, lambda { where('created_at >= ?', 1.week.ago)}
  	scope :undergraduate, lambda { where(study_level: "undergraduate")}
  	scope :graduate, lambda { where(study_level: "graduate")}
  	scope :online, lambda { where(admission_type: "online")}
  	scope :regular, lambda { where(admission_type: "regular")}
  	scope :extention, lambda { where(admission_type: "extention")}
  	scope :distance, lambda { where(admission_type: "distance")}

  	
	##associations
    has_many :students
  	has_many :activities, dependent: :destroy
    accepts_nested_attributes_for :activities, reject_if: :all_blank, allow_destroy: true
    has_many :semesters, dependent: :destroy
    accepts_nested_attributes_for :semesters, reject_if: :all_blank, allow_destroy: true
    has_many :semester_registrations
    has_many :course_registrations
    has_many :invoices
    has_many :attendances
    has_many :course_instructors
    has_many :grade_reports
    has_many :grade_changes
    has_many :sessions
    has_many :withdrawals
    has_many :recurring_payments
    has_many :add_and_drops
    has_many :makeup_exams

    def to_ethiopian_date(gregorian_date)
      # Ensure gregorian_date is a Date object
      gregorian_date = Date.parse(gregorian_date.to_s) unless gregorian_date.is_a?(Date)
    
      # Determine if the Gregorian year is a leap year
      is_gregorian_leap = Date.leap?(gregorian_date.year)
      new_year_offset = is_gregorian_leap ? 11 : 12
    
      # Ethiopian New Year starts around September 11/12
      ethiopian_new_year = Date.new(gregorian_date.year, 9, new_year_offset)
      ethiopian_year = gregorian_date.year - 8
    
      # Adjust the Ethiopian year if the Gregorian date is before the Ethiopian New Year
      if gregorian_date < ethiopian_new_year
        ethiopian_year -= 1
        ethiopian_new_year = Date.new(gregorian_date.year - 1, 9, new_year_offset)
      end
    
      # Calculate the days difference from the Ethiopian New Year
      days_difference = (gregorian_date - ethiopian_new_year).to_i
    
      # Calculate the Ethiopian month and day
      if days_difference >= 0
        ethiopian_month = 1 + (days_difference / 30)      # Integer division to get the month
        ethiopian_day = 1 + (days_difference % 30)        # Modulo to get the day within the month
    
        # Adjust for Pagumē (13th month with 5 or 6 days)
        if ethiopian_month > 13
          ethiopian_month = 13
          ethiopian_day = days_difference - 360 + 1       # Reset day count within Pagumē
        end
      else
        # Handle case for Pagumē directly
        ethiopian_month = 13
        ethiopian_day = 1 + days_difference + 30
      end
    
      # Ensure day count doesn't exceed Pagumē's maximum days
      if ethiopian_month == 13
        max_days_in_pagume = is_gregorian_leap ? 6 : 5
        ethiopian_day = max_days_in_pagume if ethiopian_day > max_days_in_pagume
      end
    
      # Format as Ethiopian calendar date
      "#{ethiopian_day}/#{ethiopian_month}/#{ethiopian_year}"
    end
    
    
end
