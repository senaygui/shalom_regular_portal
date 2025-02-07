# frozen_string_literal: true
ActiveAdmin.register_page "AssignSection" do
   menu parent: ["Student managment", "Section managment"], label: "Assign Section", priority: 2

  content do
    link_to "Assign Student to Section", assign_sections_path, target: "_blank"
  end
end
