defmodule Campsite.Web.Router do
import Glue.Conn
use Owl.Router
alias Campsite.Web.{EpisodeController, PageController}

get "/too", PageController, :too
get "/contact", PageController, :contact
get "/upupdowndownleftrightleftrightba", PageController, :upupdowndownleftrightleftrightba
get << "/stats/", name::binary >> , PageController, :stats, %{name: name}
get << "/episode/", name::binary >> , EpisodeController, :show, %{name: name}
get other , PageController, :other, %{path: other}


end