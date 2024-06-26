﻿# linux-specific base
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base-linux
USER $APP_UID

# windows-specific base
FROM mcr.microsoft.com/dotnet/aspnet:8.0-nanoserver-ltsc2022 AS base-windows
# system PATH mysteriously doesn't work in nanoserver after publishing
# so we add dotnet to the user path as a workaround
ENV PATH="%PATH%;C:\\Program Files\\dotnet"

# linux only build and publish
FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["dotnet-multiplatform-docker/dotnet-multiplatform-docker.csproj", "dotnet-multiplatform-docker/"]
RUN dotnet restore "dotnet-multiplatform-docker/dotnet-multiplatform-docker.csproj"
COPY . .
WORKDIR "/src/dotnet-multiplatform-docker"
RUN dotnet build "dotnet-multiplatform-docker.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "dotnet-multiplatform-docker.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# platform-dynamic final
FROM base-${TARGETOS} AS final
EXPOSE 8080
EXPOSE 8081
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "dotnet-multiplatform-docker.dll"]
