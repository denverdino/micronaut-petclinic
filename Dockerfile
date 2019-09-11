FROM maven:3.6.1-jdk-8 as build
COPY ./ /micronaut-petclinic/
WORKDIR /micronaut-petclinic
RUN mvn package

FROM oracle/graalvm-ce:19.2.0 as graalvm
RUN gu install native-image
#FROM bufferings/build-graalvm-docker as graalvm
WORKDIR /work
COPY --from=build /micronaut-petclinic/target/micronaut-petclinic-*.jar .
RUN native-image --no-server -cp micronaut-petclinic-*.jar

FROM frolvlad/alpine-glibc
EXPOSE 8080
WORKDIR /app
COPY --from=graalvm /work/petclinic .
CMD ["/app/petclinic"]