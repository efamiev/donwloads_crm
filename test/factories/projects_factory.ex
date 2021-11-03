defmodule DownloadsCrm.ProjectsFactory do
  defmacro __using__(_opts) do
    quote do
      alias DownloadsCrm.Storage.Pg.Schema.Project

      def project_factory(attrs) do
        project = %Project{
          name: sequence("projectname"),
          price: 5000
        }

        merge_attributes(project, attrs)
      end
    end
  end
end
