defmodule Owl.View do

defmacro __using__(opts) do
path = Keyword.fetch!(opts, :path) 

#все что от дефмакро до квот это контекст макросса
#если в контексте обьявлены переменные - они анквотятся
# если нет (но они есть в модуле) то они обьявляются через var!


quote do

def render(var!(name), var!(assigns)) do  
try do 
EEx.eval_file"#{unquote(path)}/#{var!(name)}.eex", var!(assigns) 
#отображает содержимое шаблона, передает внутрь шаблона переменную conn.assign
rescue #если переменная assign из conn, которую мы передаем в шаблон не та, которую он готов принять(не adj)
#или же возникает иная ошибка
e in CompileError ->
details = Enum.reduce(Map.from_struct(e), "", #тут мы очень интересно отображаем ошибку на человеческий язык
fn{k,v}, acc -> acc <> "<strong>#{k}:</strong> #{v}<br>" end) #функция от двух переменных, так как это мапа
#а не от одной, как в листе
#значит это автоматом ключ и значение

end
end
end
end
end