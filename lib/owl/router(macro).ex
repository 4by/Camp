defmodule Owl.Router do 
#макрос делает двойную работу: отсюда модуль router вызывает функции и здесь функции, которые как бы в нем

defmacro __using__(_opts) do
quote do
import Owl.Router #так как из router вызывается функция get ПОЧЕМУ НЕЛЬЗЯ ПОСЛЕ КОЛЛ ЕЕ ВСТАВИТЬ

def call(conn) do 
content_for(conn.req_path, conn) #обращается к функции в этом же макроссе(1)
end
end
end

defmacro get(path, controller, action) do  #вызывается функция гет из модуля роутер
quote do
defp content_for(unquote(path), var!(conn)) do 
#так как в макросе аргумент path виден с метаданными, анквотим его и создаем переменную conn
apply(unquote(controller), :call, [var!(conn), unquote(action)]) 
#паттернматч path вызвал правильный get из модуля router и выцепил оттуда данные
#если паттернматч соответствует функции get с 4-мя аргументами, то пойдет в нижнюю функцию(макросс)
end
end
end

defmacro get(path, controller, action, opts) do
quote do
defp content_for(unquote(path), var!(conn)) do 
apply(unquote(controller), :call, [var!(conn), unquote(action), unquote(opts)])
end
end
end




end

