$(function () {
  // Function to populate programs in the dropdown
  const populatePrograms = (result) => {
    const $programList = $("#program-list");
    $programList.empty();
    $programList.append(`<option value="" selected>Select Program</option>`);
    const programs = [];

    result.forEach(item => {
      if (item.program && !programs.find(p => p.id === item.program.id)) {
        programs.push(item.program);
      }
    });

    programs.forEach(program => {
      $programList.append(
        $(`<option value="${program.id}">${program.program_name}</option>`)
      );
    });
  };

  // Function to populate courses and sections based on the selected program
  const populateCoursesAndSections = (result, selectedProgramId) => {
    const $courseList = $("#course-list");
    const $sectionList = $("#section");
    $courseList.empty();
    $courseList.append(`<option value="" selected>Select Courses</option>`);
    $sectionList.empty();
    $sectionList.append(`<option value="" selected>Select Section</option>`);

    result.forEach(item => {
      if (item.program && item.program.id === selectedProgramId) {
        if (item.course && item.course.id) {
          $courseList.append(
            $(`<option value="${item.course.id}" data-program="${item.program.id}">${item.course.course_title}</option>`)
          );
        }
        if (item.sections) {
          item.sections.forEach(section => {
            if (section.id) {
              $sectionList.append(
                $(`<option value="${section.id}" data-program="${item.program.id}">${section.name}</option>`)
              );
            }
          });
        }
      }
    });
  };

  // Function to handle fetching courses and sections based on year and semester
  const fetchCoursesAndSections = (year, semester, currentAdminUser) => {
    $.ajax({
      type: "GET",
      url: "/assessmens/find_course",
      dataType: "json",
      data: {
        year: year,
        semester: semester,
        current_admin_user: currentAdminUser,
      },
      success: function (result) {
        console.log("Fetched result:", result);

        populatePrograms(result);

        $("#program-list").trigger("change");

        console.log("Programs populated.");
      },
      error: function (error) {
        console.error("Error fetching programs:", error);
      }
    });
  };

  // Event listener for year and semester selection change
  $("#year, #semester").on("change", function () {
    const year = $("#year").val();
    const semester = $("#semester").val();
    const currentAdminUser = $("#current_admin_user").val();

    if (year && semester) {
      fetchCoursesAndSections(year, semester, currentAdminUser);
    }
  });

  // Event listener for program selection change
  $("#program-list").on("change", function () {
    const selectedProgram = $(this).val();

    if (selectedProgram === "") {
      const $courseList = $("#course-list");
      const $sectionList = $("#section");
      $courseList.empty();
      $courseList.append(`<option value="" selected>Select Courses</option>`);
      $sectionList.empty();
      $sectionList.append(`<option value="" selected>Select Section</option>`);
      return;
    }

    const year = $("#year").val();
    const semester = $("#semester").val();
    const currentAdminUser = $("#current_admin_user").val();

    if (year && semester && currentAdminUser) {
      $.ajax({
        type: "GET",
        url: "/assessmens/find_course",
        dataType: "json",
        data: {
          year: year,
          semester: semester,
          current_admin_user: currentAdminUser,
        },
        success: function (result) {
          console.log("Fetched result for program selection:", result);
          populateCoursesAndSections(result, selectedProgram);
        },
        error: function (error) {
          console.error("Error fetching courses and sections:", error);
        }
      });
    }
  });

  // Event listener for course and section selection change
  $("#course-list, #section").on("change", function () {
    const courseId = $("#course-list").val();
    const sectionId = $("#section").val();
    const currentAdminUser = $("#current_admin_user").val();
    const selectedYear = $("#year").val(); 
    const selectedSemester = $("#semester").val(); 


    if (courseId && sectionId && currentAdminUser) {
      $.ajax({
        url: '/assessmens',
        method: 'GET',
        data: {
          course_id: courseId,
          section: sectionId,
          current_admin_user: currentAdminUser
        },
        success: function(response) {
          try {
            console.log('Raw response:', response);

            if (!response.student || !response.assessment_plan) {
              console.error('Unexpected response structure:', response);
              return;
            }

            let students = JSON.parse(response.student);
            let assessmentPlans = JSON.parse(response.assessment_plan);

            console.log('Parsed students:', students);
            console.log('Parsed assessment plans:', assessmentPlans);

            students = students.filter(student => 
              student.year == selectedYear && student.semester == selectedSemester
            );

            assessmentPlans = assessmentPlans.filter(plan => plan.admin_user_id === currentAdminUser);
            assessmentPlans.sort((a, b) => new Date(a.created_at) - new Date(b.created_at));

            const $tbody = $("#student-list");
            const $thead = $("#thead>tr");
            $tbody.empty();
            $thead.empty();

            if (students.length > 0) {
              $thead.append(`<th>ID</th><th>Name</th><th>Year</th><th>Semester</th>`);

              assessmentPlans.forEach(plan => {
                $thead.append(`<th>${plan.assessment_title} (Max: ${plan.assessment_weight || 'N/A'})</th>`);
              });

              $thead.append('<th>Total</th>');

              students.sort((a, b) => {
                const nameA = `${a.first_name} ${a.middle_name} ${a.last_name}`.toUpperCase();
                const nameB = `${b.first_name} ${b.middle_name} ${b.last_name}`.toUpperCase();
                if (nameA < nameB) {
                  return -1;
                }
                if (nameA > nameB) {
                  return 1;
                }
                return 0;
              });

              students.forEach(student => {
                console.log('Student data:', student);
                let studentRow = `
                  <tr>
                    <td>${student.student_id}</td>
                    <td>${student.first_name} ${student.middle_name} ${student.last_name}</td>
                    <td>${student.year}</td>
                    <td>${student.semester}</td>`;

                assessmentPlans.forEach(plan => {
                  const courseRegistration = student.course_registrations.find(cr => cr.course_id == courseId);
                  const courseRegistrationId = courseRegistration ? courseRegistration.id : '';
                  console.log('Course Registration ID:', courseRegistrationId);

                  studentRow += `
                    <td>
                      <input type="number" data-cr="${courseRegistrationId}" data-student="${student.id}" data-course="${courseId}" data-admin="${currentAdminUser}" data-assessment="${plan.assessment_title}" data-max="${plan.assessment_weight || 100}" class="assessment-input" />
                    </td>`;
                });

                studentRow += `<td id="student-total-${student.id}">0</td>`;
                studentRow += `</tr>`;
                $tbody.append(studentRow);
              });

              // Load stored values from local storage
              loadStoredValues();

            } else {
              $tbody.append('<tr><td colspan="4">No students found</td></tr>');
            }

            console.log('Final results:', { students, assessmentPlans });
          } catch (error) {
            console.error('Error parsing response:', error);
          }
        },
        error: function(jqXHR, textStatus, errorThrown) {
          console.error('Error fetching data:', textStatus, errorThrown);
        }
      });
    }
  });

  // Event listener for assessment input change
  $(document).on('input', '.assessment-input', function (e) {
    const target = e.target;
    const maxValue = parseFloat(target.dataset.max);

    if (target.value > maxValue || target.value < 0) {
      alert(`Please enter a valid result between 0 and ${maxValue}.`);
      target.value = '';
      return;
    }

    // Save the current value in local storage
    saveCurrentValue(target);

    // Sum the values for the same student and display the total
    sumAssessmentValues();
  });

  // Function to sum assessment values for the same student and display the total
  function sumAssessmentValues() {
    const students = {};

    $('.assessment-input').each(function () {
      const studentId = $(this).data('student');
      const value = parseFloat($(this).val()) || 0;

      if (!students[studentId]) {
        students[studentId] = 0;
      }
      students[studentId] += value;
    });

    for (const studentId in students) {
      $(`#student-total-${studentId}`).text(students[studentId]);
    }
  }

  // Function to save the current value in local storage
  function saveCurrentValue(target) {
    const key = `${target.dataset.cr}-${target.dataset.assessment}`;
    localStorage.setItem(key, target.value);
  }

  // Function to load stored values from local storage
  function loadStoredValues() {
    $('.assessment-input').each(function () {
      const key = `${this.dataset.cr}-${this.dataset.assessment}`;
      const storedValue = localStorage.getItem(key);
      if (storedValue !== null) {
        $(this).val(storedValue);
      }
    });
    sumAssessmentValues();
  }

  // Event listener for submit assessments button
  $(document).ready(function() {
    $("#submit-assessments").on("click", function () {
      let assessmentsData = [];
      
      $(".assessment-input").each(function () {
        const target = $(this);
        const courseRegistration = target.data("cr");
        const studentId = target.data("student");
        const courseId = target.data("course");
        const adminUserId = target.data("admin");
        const assessmentTitle = target.data("assessment");
        const result = target.val();
  
        if (result !== "") {
          assessmentsData.push({
            course_id: courseId,
            result: result,
            admin_user_id: adminUserId,
            student_id: studentId,
            assessment_title: assessmentTitle,
            course_registration_id: courseRegistration,
          });
        }
      });
  
      if (assessmentsData.length > 0) {
        $.ajax({
          type: "POST",
          url: "/assessmens/bulk_create",
          dataType: "json",
          contentType: "application/json",
          data: JSON.stringify({ assessments: assessmentsData }),
          success: function (response) {
            console.log("AJAX Success Response:", response);
  
            if (response.status === "success") {
              // Show the success message
              $("#success-message").text("Assessments submitted successfully!").fadeIn().delay(1500).fadeOut();
            } else {
              console.error("Unexpected response:", response);
            }
          },
          error: function (error) {
            console.error("Error saving assessments:", error);
          }
        });
      } else {
        alert("Please enter values");
      }
    });
  });

});
