defmodule Campsite.Web.EpisodeController do

    import Glue.Conn
use Owl.Controller

def show(conn, %{:name => name}) do
render(conn, name)
end

end