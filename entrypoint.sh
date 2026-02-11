#!/bin/bash
# .env 파일의 CRLF(\r) 문자로 인한 환경변수 오염 방지
# Windows 환경에서 .env 파일 작성 시 \r이 값 끝에 포함될 수 있음
export RIOT_API_KEY=$(echo "$RIOT_API_KEY" | tr -d '\r')
export SPRING_DATASOURCE_URL=$(echo "$SPRING_DATASOURCE_URL" | tr -d '\r')
export SPRING_DATASOURCE_USERNAME=$(echo "$SPRING_DATASOURCE_USERNAME" | tr -d '\r')
export SPRING_DATASOURCE_PASSWORD=$(echo "$SPRING_DATASOURCE_PASSWORD" | tr -d '\r')

# API 키 로드 확인 (마스킹 처리)
if [ -z "$RIOT_API_KEY" ]; then
  echo "[WARN] RIOT_API_KEY is empty!"
else
  echo "[INFO] RIOT_API_KEY loaded: ${RIOT_API_KEY:0:10}..."
fi

exec java -jar app.war
