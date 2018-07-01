FROM microsoft/aspnetcore-build AS build-env
# Copy csproj and restore as distinct layers
RUN git clone https://github.com/smokja/M901.git 
WORKDIR /M901
RUN dotnet restore

# Copy everything else and build
RUN dotnet publish -c Release -o out

# Build runtime image, has to be aspnetcore-build because we need node-js
FROM microsoft/aspnetcore-build 
WORKDIR /M901
COPY --from=build-env /M901/out .

ENTRYPOINT ["dotnet", "lb1-project.dll"]
EXPOSE 8888