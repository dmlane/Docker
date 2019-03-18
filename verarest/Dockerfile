from alpine:latest as veraBase
WORKDIR /opt/veraPDF
RUN apk update && apk add openjdk8 
RUN apk add git maven
ENV BUILD_DATE 20190318
RUN git clone git://github.com/~git/veraPDF/veraPDF-rest.git
WORKDIR /opt/veraPDF/veraPDF-rest
RUN git checkout integration
RUN mvn clean package

from alpine:latest
WORKDIR /opt/verapdf
RUN apk update && apk add openjdk8
COPY --from=veraBase /opt/veraPDF/veraPDF-rest/target .
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "verapdf-rest-0.1.0-SNAPSHOT.jar"]
CMD ["help"]
