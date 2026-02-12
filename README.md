# LOL Community

League of Legends 유저 전적 검색 및 커뮤니티 플랫폼

![ndbisg](https://user-images.githubusercontent.com/66933008/111584726-9620aa00-8801-11eb-93d6-22e05a358199.png)
![커뮤니티메인](https://user-images.githubusercontent.com/66933008/111584742-9a4cc780-8801-11eb-9f62-b6db76388c32.png)
![유저정보](https://user-images.githubusercontent.com/66933008/111584749-9caf2180-8801-11eb-8bb6-5e5894c7c630.png)

---

## 주요 기능

- **소환사 전적 검색** — Riot API를 활용한 소환사 정보, 매치 히스토리, 랭크 정보 조회
- **챔피언 정보** — 챔피언 목록, 스펠, 룬 정보 제공 및 로테이션 챔피언 자동 갱신
- **커뮤니티** — 자유게시판 / 공략게시판 CRUD, 댓글, 좋아요 기능
- **회원 시스템** — 회원가입 / 로그인 / 닉네임 설정 / 활동 기반 레벨 시스템

---

## 기술 스택

| 구분 | 기술 |
|------|------|
| **Backend** | Java 8, Spring Boot 2.3, MyBatis, Lombok |
| **Frontend** | JSP (JSTL), JavaScript (jQuery), Ajax, HTML/CSS, Bootstrap |
| **Database** | PostgreSQL 15, HikariCP |
| **Build** | Maven, WAR 패키징 |
| **Infra** | Docker, Docker Compose, GitHub Actions, GCP Compute Engine |
| **API** | Riot API, Naver API |

---

## 프로젝트 아키텍처

### 모놀리식 3계층 구조

Spring Boot 기반의 단일 WAR로 패키징되는 모놀리식 아키텍처이며, 내부적으로 **Presentation - Business - Data Access** 3계층을 분리하여 관심사를 구분합니다.

```
┌─────────────────────────────────────────────────────┐
│                  Presentation Layer                  │
│                                                     │
│   JSP (JSTL)  +  JavaScript (jQuery/Ajax)           │
│   views/riot/    views/community/    views/user/    │
│                                                     │
│   - 서버 사이드 렌더링 (JSP + JSTL)                  │
│   - 클라이언트 비동기 통신 (Ajax/jQuery)              │
│   - Bootstrap 기반 반응형 UI                         │
├─────────────────────────────────────────────────────┤
│                  Business Layer                      │
│                                                     │
│   Controller → Service → ServiceImpl                │
│                                                     │
│   riot/                                             │
│   ├── controller/   API 요청 핸들링                  │
│   ├── service/      비즈니스 인터페이스               │
│   ├── component/    Riot API 데이터 파싱             │
│   └── schedule/     로테이션·버전 체크 스케줄러       │
│                                                     │
│   community/                                        │
│   ├── controller/   게시판·유저 요청 핸들링           │
│   ├── service/      커뮤니티 비즈니스 로직            │
│   └── config/       웹 설정 (인터셉터 등)            │
├─────────────────────────────────────────────────────┤
│                  Data Access Layer                   │
│                                                     │
│   MyBatis Mapper Interface + XML SQL                │
│   mapper/riot/*.xml    mapper/community/*.xml        │
│                                                     │
│   - VO(Value Object) 기반 데이터 전달                │
│   - PostgreSQL + HikariCP 커넥션 풀                  │
│   - schema.sql 자동 초기화                           │
└─────────────────────────────────────────────────────┘
```

### 패키지 구조

```
src/main/java/com/example/demo/
├── riot/                          # Riot 전적 검색 도메인
│   ├── controller/                # SummonerController, RiotController, ChampParseController, RankController
│   ├── service/                   # 인터페이스 정의
│   ├── service/impl/              # 비즈니스 로직 구현
│   ├── mapper/                    # MyBatis Mapper 인터페이스
│   ├── vo/                        # Value Objects
│   ├── component/                 # Riot API 데이터 파싱 컴포넌트
│   └── schedule/                  # 스케줄링 (로테이션, 버전 체크)
│
├── community/                     # 커뮤니티 도메인
│   ├── controller/                # FreeBoardController, GuideBoardController, UserController 등
│   ├── service/                   # 커뮤니티 서비스
│   ├── mapper/                    # MyBatis Mapper 인터페이스
│   ├── vo/                        # Value Objects
│   ├── config/                    # 웹 설정
│   └── util/                      # 유틸리티
│
src/main/webapp/WEB-INF/views/
├── riot/                          # 전적 검색 관련 뷰 (main, summoner, champion, game-info)
├── community/                     # 게시판 뷰 (freeBoard, guideBoard, 글쓰기, 수정)
└── user/                          # 유저 뷰 (login, join, update)
```

---

## CI/CD 파이프라인

GitHub Actions를 통해 `main` 브랜치에 push 시 **빌드 → 컨테이너화 → 배포**가 자동으로 수행됩니다.

```
 ┌──────────┐     ┌──────────────┐     ┌────────────┐     ┌────────────┐
 │  GitHub   │────▶│ GitHub       │────▶│ Docker Hub │────▶│  GCP VM    │
 │  Push     │     │ Actions      │     │            │     │  Deploy    │
 │  (main)   │     │ Build & Test │     │ Image Push │     │            │
 └──────────┘     └──────────────┘     └────────────┘     └────────────┘
```

### 1단계: Build (GitHub Actions)

```yaml
# .github/workflows/maven.yml
- actions/checkout@v4           # 소스 코드 체크아웃
- actions/setup-java@v4         # JDK 17 설정 (빌드용)
- mvn -B package -DskipTests    # Maven 빌드 (WAR 패키징)
```

- `ubuntu-latest` 러너에서 실행
- Maven 캐시 활용으로 빌드 속도 최적화

### 2단계: Docker Image Build & Push

```yaml
- docker/login-action@v2        # Docker Hub 인증
- docker/build-push-action@v4   # 이미지 빌드 및 Push
```

**Dockerfile (Multi-stage Build)**

```dockerfile
# Stage 1: Maven + JDK 8 환경에서 빌드
FROM maven:3.8.6-eclipse-temurin-8 AS build
COPY . .
RUN mvn clean package -DskipTests

# Stage 2: JRE 8 환경에서 실행 (경량 이미지)
FROM eclipse-temurin:8-jre-focal
COPY --from=build /app/target/*.war app.war
ENTRYPOINT ["/app/entrypoint.sh"]
```

- Multi-stage 빌드로 최종 이미지 크기 최소화
- `entrypoint.sh`에서 환경변수 CRLF 제거 및 Riot API Key 로드 검증

### 3단계: Deploy (GCP Compute Engine)

```yaml
- appleboy/ssh-action@master    # SSH로 GCP VM 접속
  script:
    - git fetch & reset          # 최신 소스 동기화 (docker-compose.yml, .env 등)
    - .env 파일 생성              # GitHub Secrets → 환경변수 주입
    - docker-compose pull         # Docker Hub에서 최신 이미지 Pull
    - docker-compose up -d        # 컨테이너 기동
```

### 인프라 구성 (Docker Compose)

```
┌─────────────── GCP Compute Engine VM ───────────────┐
│                                                      │
│   ┌────────────────────┐    ┌─────────────────────┐  │
│   │   spring_app       │    │   postgres_db       │  │
│   │                    │    │                     │  │
│   │   Spring Boot WAR  │───▶│   PostgreSQL 15     │  │
│   │   (Port 8080)      │    │   (Port 5432)       │  │
│   │                    │    │                     │  │
│   │   - Riot API 연동  │    │   - lolcommunity DB │  │
│   │   - JSP 렌더링     │    │   - Volume 영속화   │  │
│   └────────────────────┘    └─────────────────────┘  │
│          ▲                                           │
│          │ :8080                                     │
└──────────┼───────────────────────────────────────────┘
           │
        외부 접속
```

| 컨테이너 | 이미지 | 역할 |
|----------|--------|------|
| `spring_app` | Docker Hub (커스텀 이미지) | Spring Boot 애플리케이션 서버 |
| `postgres_db` | `postgres:15` | 데이터베이스 서버, healthcheck 기반 기동 순서 보장 |

- `depends_on` + `healthcheck`로 DB 준비 완료 후 앱 기동
- `.env` 파일로 민감 정보(DB 계정, Riot API Key) 외부 주입
- `postgres_data` 볼륨 마운트로 데이터 영속화

---

## 환경변수

| 변수 | 설명 |
|------|------|
| `RIOT_API_KEY` | Riot Developer API Key |
| `DB_USERNAME` | PostgreSQL 사용자명 |
| `DB_PASSWORD` | PostgreSQL 비밀번호 |
| `DOCKERHUB_USERNAME` | Docker Hub 계정명 |
| `DOCKERHUB_REPO` | Docker Hub 저장소명 |

GitHub Secrets에 등록하여 CI/CD 파이프라인에서 자동 주입됩니다.

---

## 로컬 실행

```bash
# 1. 환경변수 설정
cp .env.example .env
# .env 파일에 RIOT_API_KEY, DB_USERNAME, DB_PASSWORD 등 설정

# 2. Docker Compose로 실행
docker-compose up -d

# 3. 접속
# http://localhost:8080
```

---

## DB 스키마

`schema.sql`이 애플리케이션 기동 시 자동 실행되며, 주요 테이블 구성은 다음과 같습니다.

**Riot 도메인**: `champion_info`, `champion_rotation`, `champion_spell`, `summoner_info`, `summoner_spell`, `rune_info`, `rune_page`, `match_info`, `match_game_info`, `match_item_slot`

**Community 도메인**: `user_info`, `free_board`, `guide_board`, `tag_table`, `guide_tag_table`, `like_table`, `guide_like_table`
