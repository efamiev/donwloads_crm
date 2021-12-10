FROM elixir:1.12.2

WORKDIR /app/downloads_crm

RUN apt-get update
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -&&\
  apt-get install -y nodejs

RUN mix local.hex --force && mix local.rebar --force

# setup
# docker-compose run <compose_service_name> mix phx.new . --app <app_name>
# docker-compose run <app_name> mix ecto.create

# setup db
# docker-compose run <compose_service_name> mix ecto.create --rm

# start with active shell
# создать новый контейнер для каждого запуска и удалить после завершения
# docker-compose run --rm  --service-ports <compose_service_name> iex -S mix run --no-halt
# or
# перейти в запущенный контейнер и выполнить команду запуска сервиса
# docker-compose up -d
# docker-compose exec <compose_service_name> iex -S mix run --no-halt

# run tests
# создать новый контейнер для запуска тестов и удалить после завершения
# docker-compose run --rm -e MIX_ENV=test <compose_service_name> mix test
# or
# перейти в запущенный контейнер и запустить тесты
# docker-compose exec -e MIX_ENV=test <compose_service_name> mix test