    defmodule Owl.Controller do 
    # это макросс. откуда бы он не был вызван, функции вызываемые из того модуля, будут вызваны отсюда
    defmacro __using__(_args) do
    quote do

    def call(conn, action) do
    apply(__MODULE__, action, [conn, "Controller here"]) 
    #вызывает функцию(2) из модуля(1) и передает туда(3)
    #модуль(1) тут модуль, функция которого тут представлена, а не модуль макросса
    end

    def call(conn, action, params) do
    apply(__MODULE__, action, [conn, params])
    end

    defoverridable [call: 2, call: 3] 
    #если мы пропишем эти функции в самом модуле, откуда вызываем макросс, то выполнятся те

    def render(conn, template, assigns) do 
    #берет инфу из кона, смотрит на контроллер, и отправляет ее рендериться в соответствующий вью
    view_name = __MODULE__
    |> Atom.to_string
    |> String.replace(~r/Controller$/, "View") #заменяем Owl.Controller на Owl.View
    view_module = Module.concat(Elixir, view_name) #превращает строку в название модуля. интересно, что сначала эликсир
    body = view_module.render(template, assigns) #выполняется рендер из модуля вью...
    Glue.Conn.put_resp_body(conn, body) #...и возвращает результат в тело кона

    end


    def render(conn, template) do
    render(conn, template, Enum.to_list conn.assigns) 
    #передали функцию с двумя аргументами под управление той же функции, но с двумя аргументами 
    #все работает и без превращения в лист
    end

    end
    end
    end