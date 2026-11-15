#############################################
#     Stage--1-----JDK + MAVEN
#############################################

FROM maven:3.9-eclipse-temurin-25 AS build

WORKDIR /app

COPY pom.xml .
#source    destination
COPY src ./src

RUN mvn clean package -DskipTests


#############################################
#     Stage--2-----JRE
#############################################

FROM eclipse-temurin:25-jre

WORKDIR /app

# source                              destination
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

CMD ["java", "-jar", "app.jar"]