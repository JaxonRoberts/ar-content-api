#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
#EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["ARProject-API/ARProject-API.csproj", "ARProject-API/"]
RUN dotnet restore "ARProject-API/ARProject-API.csproj"
COPY . .
WORKDIR "/src/ARProject-API"
RUN dotnet build "ARProject-API.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ARProject-API.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ARProject-API.dll"]
