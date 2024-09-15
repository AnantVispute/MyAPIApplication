FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["MyAPIApplication.csproj", "."]
RUN dotnet restore "MyAPIApplication.csproj"
COPY . .
RUN dotnet build "MyAPIApplication.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "MyAPIApplication.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "MyAPIApplication.dll"]
