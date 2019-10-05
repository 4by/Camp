defmodule StatWatch do

def run do    #отправится в генсервер
  fetch_stats() |> save_csv
end

def column_names do
  Enum.join ~w(DateTime Subscribers Videos Views), ","
end  

def fetch_stats do
now = DateTime.to_string(%{DateTime.utc_now | microsecond: {0,0}})
%{body: body} = HTTPoison.get! StatWatch.stats_url() #первая бади из ответа, во вторую  бади это засовывается
%{items: [%{statistics: stats}| _]} = Poison.decode! body, keys: :atoms
[now,
stats.subscriberCount,
stats.videoCount,
stats.viewCount
] |> Enum.join(", ")
end

def save_csv(row_of_stats) do
filename = "stats.csv" 
unless File.exists? "/home/poisong/Project/Phoenix/campsite/priv/static/stats/#{filename}" do
File.write! "/home/poisong/Project/Phoenix/campsite/priv/static/stats/#{filename}", column_names() <> "\n"
end
File.write!("/home/poisong/Project/Phoenix/campsite/priv/static/stats/#{filename}", row_of_stats <> "\n", [:append])
end


def stats_url do
youtube_api_v3 = "https://www.googleapis.com/youtube/v3/"
channel = "id=" <> "UCBzAeSNZVhiLDDcK4l65ydg"
key = "key=" <> "AIzaSyC_Mgvygb476YhV2xBSsp_uSXI288KyheA"
"#{youtube_api_v3}channels?#{channel}&#{key}&part=statistics"
end
end