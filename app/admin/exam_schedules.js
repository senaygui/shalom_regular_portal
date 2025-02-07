// app/assets/javascripts/exam_schedules.js

document.addEventListener("DOMContentLoaded", function() {
  $('#exam_schedule_program_id').on('change', function() {
    let programId = $(this).val();

    // Fetch and populate courses based on selected program
    $.ajax({
      url: '/admin/courses',
      data: { q: { program_id_eq: programId } },
      success: function(data) {
        let options = '<option value="">Select Course</option>';
        data.forEach(function(course) {
          options += `<option value="${course.id}">${course.name}</option>`;
        });
        $('#exam_schedule_course_id').html(options);
        $('#exam_schedule_section_id').html('<option value="">Select Section</option>'); // Reset sections
      }
    });
  });

  $('#exam_schedule_course_id').on('change', function() {
    let courseId = $(this).val();

    // Fetch and populate sections based on selected course
    $.ajax({
      url: '/admin/sections',
      data: { q: { course_id_eq: courseId } },
      success: function(data) {
        let options = '<option value="">Select Section</option>';
        data.forEach(function(section) {
          options += `<option value="${section.id}">${section.name}</option>`;
        });
        $('#exam_schedule_section_id').html(options);
      }
    });
  });
});
