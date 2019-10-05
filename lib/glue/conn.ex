defmodule Glue.Conn do #фальшивый кон

defstruct assigns: %{},
req_path: "",   #запрошенный путь"
resp_header: [{"content-type", "text/html"}], #заголовок хтмл
resp_body: "", #ответ страницы
status: 200 #статус

def put_resp_header(conn, header) do
%{conn | resp_header: header}
end

def put_resp_body(conn, body) do
%{conn | resp_body: body}
end

def put_status(conn, code) do
%{conn | status: code}  
end

def assign(%Glue.Conn{assigns: assigns} = conn, key, value) do
%{conn | assigns: Map.put(assigns, key, value)}
end

end