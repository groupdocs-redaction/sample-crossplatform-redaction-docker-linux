# See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

# This stage is used when running from VS in fast mode (Default for Debug configuration)
# GroupDocs.Redaction requires native dependencies on Linux.
FROM mcr.microsoft.com/dotnet/runtime:10.0 AS base
USER root
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        fontconfig \
        libfreetype6 \
        libgdiplus \
        libc6-dev \
        libx11-dev \
        software-properties-common \
    && echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | debconf-set-selections \
    && apt-add-repository multiverse \
    && apt-get update \
    && apt-get install -y ttf-mscorefonts-installer fonts-lato \
    && fc-cache -f \
    && dir="$(dirname "$(find /usr/lib /lib -name 'libdl.so.2' 2>/dev/null | head -n1)")" \
    && ln -sf "$dir/libdl.so.2" "$dir/libdl.so" \
    && rm -rf /var/lib/apt/lists/*
USER $APP_UID
WORKDIR /app


# This stage is used to build the service project
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["CrossplatformRedactionDockerLinux.csproj", "."]
RUN dotnet restore "./CrossplatformRedactionDockerLinux.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "./CrossplatformRedactionDockerLinux.csproj" -c $BUILD_CONFIGURATION -o /app/build

# This stage is used to publish the service project to be copied to the final stage
FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./CrossplatformRedactionDockerLinux.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# This stage is used in production or when running from VS in regular mode (Default when not using the Debug configuration)
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "CrossplatformRedactionDockerLinux.dll"]