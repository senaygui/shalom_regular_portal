class SectionsController < ApplicationController
  before_action { @disable_nav = true }
  before_action :set_section, only: [:download_pdf]

  #def index
  #  @programs = Program.select(:id, :program_name)
  #  unless params[:program].nil?
  #    @students = Student.no_assigned.where(program_id: params[:program][:name], year: params[:year], semester: params[:semester], batch: params[:student][:batch]).includes(:program)
  #    @sections = Section.empty.or(Section.partial).where(program_id: params[:program][:name], year: params[:year], semester: params[:semester], batch: params[:student][:batch]).includes(:students)
  #  end
  #end

  def index
    @programs = Program.select(:id, :program_name)
    
    unless params[:program].nil?
      puts "Params: #{params.inspect}" # Debugging parameters
      
      @students = Student.no_assigned.where(
        program_id: params[:program][:name], 
        year: params[:year], 
        semester: params[:semester], 
        batch: params[:student][:batch].strip
      ).includes(:program)
      
      @sections = Section.empty.or(Section.partial)
                           .where(
                             program_id: params[:program][:name], # Match program_id with params[:program][:name]
                             year: params[:year], 
                             semester: params[:semester], 
                             batch: params[:student][:batch].strip # Ensure no trailing spaces
                           )
                           .includes(:students)
  
      puts "Sections: #{@sections.inspect}" # Debugging query result
  
      if @sections.empty?
        puts "No sections found matching the criteria."
      end
    end
  end
  
  
  

  def download_pdf
    pdf = SectionPdfGenerator.new(@section).render
    send_data pdf, filename: "section_#{@section.id}.pdf", type: 'application/pdf', disposition: 'inline'
  end

  def new
  end

  def create
    section_id = params[:section_id]
    student_ids = params[:student_ids]
  
    if section_id.blank? || student_ids.blank?
      redirect_to assign_sections_path, alert: "Please select a section and at least one student."
      return
    end
  
    section = Section.find(section_id)
    selected_students = Student.where(id: student_ids)
  
    if section.students.count + selected_students.count <= section.total_capacity
      # Assign each student to the section
      selected_students.each do |student|
        student.update(section_id: section.id, section_status: 1)
      end
  
      # Update section status
      section.full! if section.students.count >= section.total_capacity
  
      redirect_to assign_sections_path, notice: "#{selected_students.count} students assigned to #{section.section_full_name}"
    else
      redirect_to assign_sections_path, alert: "Cannot assign students. Section capacity exceeded."
    end
  end
  

  #def create
  #  section_id = params[:section_id]
  #  section = Section.find(section_id)
  #
  #  if section.students.count < section.total_capacity
  #    unassigned_students = Student.no_assigned.where(program_id: section.program_id, year: section.year, semester: section.semester, batch: section.batch)
  #    students_to_assign = unassigned_students.sample([section.total_capacity - section.students.count, unassigned_students.count].min)
  #
  #    students_to_assign.each do |student|
  #      student.update(section_id: section.id, section_status: 1)
  #    end
  #
  #    if section.students.count < section.total_capacity
  #      section.partial!
  #    else
  #      section.full!
  #    end
  #
  #    redirect_to assign_sections_path, notice: "#{students_to_assign.count} students assigned to #{section.section_full_name}"
  #  else
  #    redirect_to assign_sections_path, alert: "Section is already full."
  #  end
  #end
  

 private

  def set_section
    @section = Section.find(params[:id])
  end
end






#class SectionsController < ApplicationController
#  before_action { @disable_nav = true }
#
#  def index
#      @programs = Program.select(:id, :program_name)
#       @students  = Student.no_assigned.where(program_id: params[:program][:name], year: params[:year], semester: params[:semester], batch: params[:student][:batch]).includes(:program) unless params[:program].nil?
#       @sections = Section.empty.or(Section.partial).where(program_id: params[:program][:name], year: params[:year], semester: params[:semester], batch: params[:student][:batch]).includes(:students) unless params[:program].nil?
#     end
#
#  def new
#  end
#
#  def create
#     section_id = params[:section]
#     section = Section.find(section_id)
#     capacity = section.total_capacity - section.students.count
#     @students = Student.no_assigned.where(program: section.program, year: section.year, semester: section.semester, batch: section.batch).includes(:program).limit(capacity)
#     if @students.update(section_id: section.id, section_status: 1)
#      if section.students.count < section.total_capacity
#        section.partial!
#      else
#        section.full!
#      end
#      redirect_to assign_sections_path, notice: "#{section.students.count} students got assigned to #{section.section_full_name}"
#     else
#      redirect_to assign_sections_path, alert: "Something went wrong, please try again later"
#     end
#
#  end
#end
#