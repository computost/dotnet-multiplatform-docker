# linux-specific base
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base-linux

# windows-specific base
FROM mcr.microsoft.com/dotnet/aspnet:8.0-nanoserver-ltsc2022 AS base-windows

#platform dynamic base
FROM base-${TARGETOS} AS base
USER $APP_UID
EXPOSE 8080
EXPOSE 8081

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

# final
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "dotnet-multiplatform-docker.dll"]
