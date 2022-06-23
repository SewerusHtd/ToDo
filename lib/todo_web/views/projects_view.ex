defmodule TodoWeb.ProjectsView do
  use TodoWeb, :view

  def error_message({attr, {message, _}}) do
    "#{attr}: #{message}"
  end
end
