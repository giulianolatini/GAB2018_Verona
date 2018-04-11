docker run -it \
-v $(pwd):/home/ \
-p 5000:5000 \
microsoft/dotnet:2-sdk \
dotnet new web --project /home

docker run -it \
-v $(pwd):/home/ \
-p 5000:5000 \
microsoft/dotnet:2-sdk

docker run -it \
-v $(pwd):/home/ \
-p 5000:5000 \
microsoft/dotnet:2-sdk \
dotnet restore --packages /home

docker run -it \
-v $(pwd):/home/ \
-p 5000:6000 \
-e ASPNETCORE_URLS="http://*:6000/" \
microsoft/dotnet:2-sdk \
dotnet run --project /home

docker run -it \
-v $(pwd):/home/ \
-p 5000:4000 \
microsoft/dotnet:2-sdk \
dotnet run --project /home --server.urls="http://*:4000/"

docker run -it \
-v $(pwd):/home/ \
-p 5000:7000 \
microsoft/dotnet:2-sdk \
dotnet run --project /home --port=7000


