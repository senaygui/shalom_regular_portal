$(function () {
    $("#first_name").on("input", (e) => {
        validation(e.target, "First Name")
    });

    $("#last_name").on("input", (e) => {
        validation(e.target, "Last Name")
    });

    $("#middle_name").on("input", (e) => {
        validation(e.target, "Middle Name")
    });

    

    const validation = (target, attribute) => {
        patternMatch = target.value.match(/[^a-zA-Z]/);
        if (patternMatch) {
            alert(`${attribute} accept only letter from a-zA-Z`)
            target.value = target.value.replace(/[^a-zA-Z]/g, '');
        }
    }
});
