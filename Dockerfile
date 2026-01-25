# S? d?ng .NET 8.0 SDK ?? build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy các file csproj và restore dependencies
COPY ["src/WikiChatbotBackends.API/WikiChatbotBackends.API.csproj", "WikiChatbotBackends.API/"]
COPY ["src/WikiChatbotBackends.Application/WikiChatbotBackends.Application.csproj", "WikiChatbotBackends.Application/"]
COPY ["src/WikiChatbotBackends.Domain/WikiChatbotBackends.Domain.csproj", "WikiChatbotBackends.Domain/"]
COPY ["src/WikiChatbotBackends.Infrastructure/WikiChatbotBackends.Infrastructure.csproj", "WikiChatbotBackends.Infrastructure/"]

RUN dotnet restore "WikiChatbotBackends.API/WikiChatbotBackends.API.csproj"

# Copy toàn b? source code
COPY src/ .

# Build và publish application
WORKDIR "/src/WikiChatbotBackends.API"
RUN dotnet build "WikiChatbotBackends.API.csproj" -c Release -o /app/build
RUN dotnet publish "WikiChatbotBackends.API.csproj" -c Release -o /app/publish /p:UseAppHost=false

# S? d?ng runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app

# Copy ?ng d?ng ?ã build
COPY --from=build /app/publish .

# Expose ports
EXPOSE 80
EXPOSE 443

# Set environment variable
ENV ASPNETCORE_ENVIRONMENT=Docker

# Ch?y ?ng d?ng
ENTRYPOINT ["dotnet", "WikiChatbotBackends.API.dll"]
