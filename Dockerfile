FROM maven:3.9.9-eclipse-temurin-23 AS build_step
RUN mkdir /app
COPY . /app
WORKDIR /app
RUN mvn clean package -DskipTests

FROM eclipse-temurin:23-jre-alpine
RUN mkdir /application
COPY --from=build_step /app/target/aws-terraform-1.0.jar /application
RUN addgroup --system juser \
&& adduser -S -s /bin/false -G juser juser \
&& chown -R juser:juser /application
USER juser
WORKDIR /application
CMD ["java", "-Xms128m", "-Xmx256m", "-jar", "aws-terraform-1.0.jar"]