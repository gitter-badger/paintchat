FROM 1science/sbt:0.13.8-oracle-jre-8
MAINTAINER Kevin Chabreck

# Builds an image containing PaintChat v0

# get required sbt version
COPY project/build.properties project/build.properties
RUN sbt update

# build compiler-interface for scala 11.7
RUN echo 'scalaVersion := "2.11.7"' > build.sbt && \
    mkdir -p src/main/scala && \
    touch src/main/scala/tmp.scala && \
    sbt compile && \
    rm -rf src build.sbt

# download dependencies
COPY build.sbt build.sbt
RUN sbt compile

# build project once without config file
COPY src/main/scala/ src/main/scala/
COPY src/main/resources/www/ src/main/resources/www/
RUN sbt compile

# rebuild with config
COPY src/main/resources/application.conf src/main/resources/application.conf
RUN sbt compile