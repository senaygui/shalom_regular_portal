class Faculty < ApplicationRecord

	##validations
  	validates :faculty_name , :presence => true,:length => { :within => 2..200 }
	
	##associations
  	has_many :departments  
	has_many :admin_users
end
