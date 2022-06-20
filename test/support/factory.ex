defmodule Todo.Factory do
  use ExMachina.Ecto, repo: Todo.Repo

  def project_factory do
    %Todo.Projects.Project{
      title: sequence("Project Title"),
      color: sequence(:color, &"me-#{&1}@foo.com", start_at: 100)
    }
  end
end