defmodule Owl.PageHandler do 


def init({:tcp, :http}, req, router) do 
#стейт это последний аргумент(атом) в маршруте 
#IO.inspect binding
{:ok, req, router}
end




#далее в хандл мы используем наш ненастоящий конн,
#добавив зависимость с настоящим, мы сможем использовать его??

def handle(req, router) do
{path, req} = :cowboy_req.path(req)#получили path из req(path это /...)
conn = %Glue.Conn{req_path: path}
conn = router.call(conn)  
#модуль роутер(и его ответвления) работают с запросом, и возвращает данные, из которых можно получить ответ
#IO.inspect conn
Tuple.append(
:cowboy_req.reply(   #выдаем ответ...
conn.status,           #200      
conn.resp_header,      #[{"content-type", "text/html"}],
conn.resp_body,        #ПОКАЗЫВАЕМЫЙ ОТВЕТ ДИНАМИЧЕСКОГО ЗАПРОСА 
req),                  #детали соединения
router)              #третий аргумент возвращает что угодно, тк нам не требуется передавать аргумент дальше

end



def terminate(_reason, _req, _router) do
:ok
end


end 