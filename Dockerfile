FROM microsoft/aspnetcore-build AS build-env
WORKDIR /lb1-project

# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out

# Build runtime image, has to be aspnetcore-build because we need node-js
FROM microsoft/aspnetcore-build 
WORKDIR /lb1-project
COPY --from=build-env /lb1-project/out .
ENTRYPOINT ["dotnet", "lb1-project.dll"]