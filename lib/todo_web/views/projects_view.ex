defmodule TodoWeb.ProjectsView do
  use TodoWeb, :view

  def error_message({attr, {message, _}}) do
    "#{attr}: #{message}"
  end

  def prepare_styles(project) do
    "animation-duration: #{Enum.random(0..30) + 15}s, #{Enum.random(0..30) + 15}s; box-shadow: 0 0 15px #{project.color};"
  end
end
