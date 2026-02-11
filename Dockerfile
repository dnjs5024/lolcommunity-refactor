# 1. 빌드 스테이지: Java 8 환경의 Maven
FROM maven:3.8.6-eclipse-temurin-8 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# 2. 실행 스테이지: Java 8 실행 환경
FROM eclipse-temurin:8-jre-focal
WORKDIR /app
# 빌드된 결과물 복사
COPY --from=build /app/target/*.war app.war

# 엔트리포인트 스크립트 복사 후 CRLF 제거 (Windows 환경 대응)
COPY --from=build /app/entrypoint.sh /app/entrypoint.sh
RUN sed -i 's/\r$//' /app/entrypoint.sh && chmod +x /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]
