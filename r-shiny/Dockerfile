FROM rocker/shiny:latest

RUN apt-get update && apt-get install -y libssl-dev && rm -rf /var/lib/apt/lists/*
RUN R -e "install.packages(c('shiny','httr','jsonlite','ggplot2','shinyjs'), repos='https://cloud.r-project.org')"

RUN mkdir -p /srv/shiny-server/emoji
WORKDIR /srv/shiny-server/emoji

COPY app.R /srv/shiny-server/emoji

EXPOSE 3838
