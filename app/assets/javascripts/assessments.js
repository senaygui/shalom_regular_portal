document.addEventListener("DOMContentLoaded", function() {
  var filterButton = document.getElementById("filter-button");
  var filterPanel = document.getElementById("filter-panel");

  if (filterButton && filterPanel) {
    filterButton.addEventListener("click", function(event) {
      event.preventDefault();
      if (filterPanel.style.display === "none" || filterPanel.style.display === "") {
        filterPanel.style.display = "block";
      } else {
        filterPanel.style.display = "none";
      }
    });
  }
});
