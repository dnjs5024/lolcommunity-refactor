# 1. 빌드 스테이지 (Maven 이용)
FROM maven:3.8.4-openjdk-17 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# 2. 실행 스테이지
FROM openjdk:17-jdk-slim
WORKDIR /app
# 빌드 스테이지에서 생성된 war 파일을 복사 (파일명은 프로젝트에 맞게 확인 필요)
COPY --from build /app/target/*.war app.war

# 환경 변수 기본값 설정 (Riot API Key 등)
ENV RIOT_API_KEY=""

# 실행 명령
ENTRYPOINT ["java", "-jar", "app.war"]
