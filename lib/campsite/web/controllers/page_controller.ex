defmodule Campsite.Web.PageController do
import Glue.Conn
use Owl.Controller

@stats_path "priv/static/stats"


def too(conn, _) do
    render(conn, "too", [msg: "the wonderful world of templating"])
end


def stats(conn, %{:name => name}) do #такой синтаксис, name идет после stats
IO.inspect name
path = "#{@stats_path}/#{name}"
cond do    #после "->" показывает что делать с первым встретившимся верным выражением
name =~ ~r/\.csv$/ and File.exists?(path) -> send_csv(conn, path)
#если в имени файла(указанном в запросе) есть ".csv" и он существует в папке "priv/static/stats" , то скачаем
File.exists? "#{path}.csv" -> render_csv(conn, path)
#Если файл существует, но в запросе не было "csv", то отрендерим его из "lib/campsite/web/templates"
true -> not_found(conn, "stats/" <> name)  
end
end


def send_csv(conn, path) do
case File.read(path) do
{:ok, data} -> conn
|> put_resp_header([{"content-type", "text/csv"}])
|> put_resp_body(data)
_ -> not_found(conn, path)
end
end


def render_csv(conn, path) do
#эта функция запихивает в мапу кона assigns данные о рендируемой таблице
#(разделяет заголовки с данными для удобного отображения)
case File.read path <> ".csv" do
{:ok, data} -> 
[header | lines] = String.split(data, ~r{(\r\n|\r|\n)}) #разобраться, как он раделяет строчки
title = String.split(header, ",")
conn = conn
|> assign(:titles, title)
|> assign(:lines, lines)
|> assign(:path, path)
|> render("stats")  #универсиализировать
_ -> not_found(conn, path)
end   
end

def other(conn, %{:path => path}) do
name = Path.basename(path)    
if Enum.member? get_templates(), name do
render(conn, name)
else
not_found(conn, name)
end
end

defp get_templates() do
for t <- Path.wildcard("#{@template_path}/*.eex"),  #берет пути всех файлов в темплейтс
do: Path.basename(t, ".eex")  #отображает имя каждого файла
end


defp not_found(conn, route) do    
conn
|> put_status(404)    
|> put_resp_body("<h1> Sorry, we dont have a page at #{route}</h1>")
end







end