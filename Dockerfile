FROM elixir:1.12.2

WORKDIR /app/downloads_crm

RUN apt-get update
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -&&\
  apt-get install -y nodejs

RUN mix local.hex --force && mix local.rebar --force

# setup
# docker-compose run <compose_image_name> mix phx.new . --app <app_name>
# docker-compose run <app_name> mix ecto.create
# setup db
# docker-compose run <compose_image_name> mix ecto.create --rm
# run with active shell
# docker-compose run --service-ports <compose_image_name> iex -S mix run --no-halt