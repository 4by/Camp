defmodule Campsite.Application do
# See https://hexdocs.pm/elixir/Application.html
# for more information on OTP Applications
@moduledoc false

use Application

def start(_type, _args) do  
start_cowboy()
children = [ 

]

# See https://hexdocs.pm/elixir/Supervisor.html
# for other strategies and supported options
opts = [strategy: :one_for_one, name: Campsite.Supervisor]
Supervisor.start_link(children, opts)
end

def start_cowboy() do
routes =  [
{"/", :cowboy_static, {:priv_file, :campsite, "static/index.html"}},
{"/images/[...]", :cowboy_static, {:priv_dir, :campsite, "static/images"}}, #последний аргумент это папка со статич. файлами
{:_, Owl.PageHandler, Campsite.Web.Router} #все что не статическое(еще не готово) отправилось в pagehandler
]
#в стейте отправили модуль роутер со всеми маршрутами



case :cowboy.start_http(
:http,
1, 
[port: 8080], 
[env: [dispatch: :cowboy_router.compile([{:_, routes}])]]
) do 
# Отправляет в page handler старт для ковбоя
#то есть запускает там функцию инит
#c закомпиленными маршрутами
{:ok, _pid} -> IO.puts("Cowboy is now running. Go to http://localhost:8080")
_ ->  IO.puts("There was an error starting Cowboy web server.")
end
end
end
