---
layout: default
title: Git & Github

---

## 목차

### 🔗 [Git & GitHub](/study/basic-cs-and-programming/)

1. 📌 Git이란?
Git = 분산 버전 관리 시스템 (Distributed Version Control System)

파일의 변경 이력을 기록하고 관리

여러 명이 동시에 개발할 수 있게 지원

서버와 연결 없이도 로컬에서 버전 기록 관리 가능

✅ "코드의 타임머신" + "협업 시스템" 이라고 이해하면 쉽습니다.

2. 📌 GitHub이란?
GitHub = Git 저장소를 클라우드에서 호스팅하는 서비스

Git 저장소를 온라인에 올려 관리

팀원들과 저장소 공유 및 협업 가능

GitLab, Bitbucket 등도 같은 역할

✅ **"Git 저장소를 인터넷에서 운영하는 공간"**입니다.

3. 📌 Git 기본 구조 이해

용어	설명
Working Directory	실제 파일이 있는 작업 공간
Staging Area (Index)	커밋 준비 완료된 파일들이 모이는 곳
Local Repository	내 컴퓨터에 저장된 버전 기록 저장소
Remote Repository	GitHub 같은 원격 저장소
흐름:

plaintext
복사
편집
Working Directory → Staging Area → Local Repository → Remote Repository
4. 📌 Git 설치 및 기본 설정
bash
복사
편집
# 설치 확인
git --version

# 사용자 설정 (최초 1회)
git config --global user.name "Your Name"
git config --global user.email "your_email@example.com"
5. 📌 Git 핵심 명령어
1) 저장소 초기화
bash
복사
편집
git init
현재 폴더를 Git 저장소로 초기화 (.git 폴더 생성)

2) 상태 확인
bash
복사
편집
git status
현재 작업 디렉토리와 스테이징 상태를 확인

3) 파일 추가 (Staging)
bash
복사
편집
git add 파일명
git add .    # 전체 파일 추가
수정된 파일을 스테이징 영역에 추가

4) 커밋 생성
bash
복사
편집
git commit -m "커밋 메시지"
변경사항을 하나의 버전으로 저장

✅ 좋은 커밋 메시지 작성법

영어 기준: [Add], [Fix], [Refactor] 등 prefix 사용

메시지는 "명령문"처럼 작성 ("Add login API", "Fix typo in README")

5) 원격 저장소 연결
bash
복사
편집
git remote add origin https://github.com/username/repo.git
GitHub에 Push할 원격 저장소 연결

6) 푸시 (업로드)
bash
복사
편집
git push origin main
로컬 커밋을 원격 저장소에 업로드

7) 클론 (다운로드)
bash
복사
편집
git clone https://github.com/username/repo.git
원격 저장소를 통째로 로컬에 복제

8) 풀 (받아오기)
bash
복사
편집
git pull origin main
원격 저장소의 변경사항을 로컬에 가져옴

9) 브랜치 관리
bash
복사
편집
git branch         # 브랜치 목록 보기
git branch 브랜치명 # 새 브랜치 생성
git checkout 브랜치명 # 브랜치 이동
git checkout -b 브랜치명 # 생성과 이동 동시에
브랜치란?

독립적으로 개발하는 작업 공간 (=기능별 작업장)

10) 병합(Merge)
bash
복사
편집
git merge 브랜치명
다른 브랜치를 현재 브랜치로 병합

✅ Fast-forward vs Merge commit 구분도 필요 (조금 있다가 설명)

6. 📌 Git 실전 플로우 (혼자 작업)
plaintext
복사
편집
git init
git add .
git commit -m "First commit"
git remote add origin [깃허브 URL]
git push -u origin main
7. 📌 Git 협업 플로우 (팀 작업)
기본 원칙: "항상 pull 먼저, push 나중에"

plaintext
복사
편집
1. git clone [원격 저장소]
2. git checkout -b [본인 브랜치 생성]
3. 작업 → git add → git commit
4. git pull origin main  (혹은 dev)    # 다른 사람 작업 반영
5. git push origin [내 브랜치]
6. GitHub에서 Pull Request 생성
8. 📌 Git 심화 주제
🔥 1) Pull Request (PR)
GitHub에서 "내 브랜치를 main/dev에 합쳐주세요" 요청

코드 리뷰 프로세스의 핵심

PR → 코드 리뷰 → Approve → Merge

🔥 2) Merge vs Rebase

구분	Merge	Rebase
기록	히스토리 유지	히스토리 정리
커밋로그	여러 커밋들이 남음	깔끔한 직선형 커밋
추천 상황	팀 협업, 이력 추적	본인 개인 브랜치 깔끔히 정리
bash
복사
편집
# Merge
git checkout main
git merge feature/login

# Rebase
git checkout feature/login
git rebase main
🔥 3) Fast-Forward vs Merge Commit

방식	설명
Fast-forward	중간에 브랜치가 없는 경우, 직선으로 이어붙임
Merge Commit	중간에 브랜치 작업이 있을 경우, 새로운 커밋 생성
bash
복사
편집
git merge --no-ff feature/login
--no-ff 옵션은 무조건 병합 커밋을 남긴다 (히스토리 추적에 유리)

🔥 4) Git stash (임시 저장)
bash
복사
편집
git stash
작업하던 내용을 임시 저장 (브랜치 이동할 때 유용)

bash
복사
편집
git stash pop
임시 저장한 작업 복구

🔥 5) Git reset / revert (실수 복구)

명령어	설명
git reset	과거 커밋으로 이동 (로컬 이력 자체 변경)
git revert	과거 커밋을 "취소하는" 새 커밋 생성 (로컬/원격 안전)
주의:
reset은 협업시 쓰면 대참사 가능 → revert 추천

bash
복사
편집
# 잘못 푸시한 커밋 되돌리기
git revert 커밋ID
9. 📌 GitHub 추가 심화 기능

기능	설명
GitHub Issues	버그, 작업할 일(Task)을 이슈로 관리
GitHub Projects	칸반보드 형식으로 일 관리 (Trello 비슷)
GitHub Actions	CI/CD 자동화 (테스트, 빌드 자동화)
GitHub Wiki	프로젝트 공식 문서 관리
✨ 최종 요약 체크리스트
 Git은 버전 관리 시스템이다.
 GitHub는 Git 저장소를 온라인으로 관리하는 플랫폼이다.
 "작업 → add → commit → push" 흐름이 기본이다.
 PR(Pull Request) 기반으로 협업한다.
 reset과 revert의 차이를 반드시 이해한다.
 GitHub Actions를 통한 자동화까지 확장 가능하다.


1. Git Flow 전략 (feature/hotfix/release 브랜치 전략)
📌 Git Flow란?
소프트웨어 릴리즈(배포)를 관리하기 위한 브랜치 전략

복잡한 프로젝트에서도 명확한 흐름과 역할로 브랜치들을 관리합니다.

 "개발 속도"와 "품질 안정성"을 동시에 잡기 위한 구조

📌 기본 브랜치 5개

브랜치명	역할
main (혹은 master)	제품의 최종 배포 버전 (배포 전용)
develop	개발 중인 통합 버전 (최신 개발 반영)
feature/*	기능 개발용 임시 브랜치
release/*	배포 준비용 브랜치 (버그 수정, QA)
hotfix/*	운영 중 긴급 수정 브랜치
📌 Git Flow 개발 흐름
plaintext
복사
편집
1. main 브랜치 존재
2. develop 브랜치를 main에서 분기
3. feature 브랜치들을 develop에서 분기 → 작업 → develop로 병합
4. 배포 준비 시 develop → release 분기 → QA → main 병합
5. 배포 후 hotfix 발생 시 main에서 hotfix 분기 → 수정 → main+develop로 병합
📌 명령어 흐름 예시
bash
복사
편집
# feature 생성
git checkout develop
git checkout -b feature/login-api

# 작업 후
git add .
git commit -m "Add login API"

# develop로 병합
git checkout develop
git merge feature/login-api

# release 준비
git checkout develop
git checkout -b release/v1.0.0

# QA 수정 반영 후
git checkout main
git merge release/v1.0.0
git tag v1.0.0
git push origin main --tags

# hotfix 발생
git checkout main
git checkout -b hotfix/login-bugfix
📌 Git Flow 장점
브랜치 역할이 명확해 팀 협업 최적화

배포 중에도 새로운 기능 개발 가능

긴급 패치(hotfix)도 안전하게 대응

 2. GitHub Actions로 CI/CD 구축 (Spring Boot/Node.js 예제)
📌 GitHub Actions란?
GitHub에서 제공하는 자동화 플랫폼

코드 push → 테스트 → 빌드 → 배포까지 자동 처리 가능

YML 파일만 작성하면 워크플로우를 자유롭게 설정

 "코드만 푸시하면 서버에 자동 배포되게 만드는 것"

📌 기본 개념

용어	설명
Workflow	전체 자동화 과정 (YAML 파일)
Job	하나의 작업 단위 (ex. 빌드, 테스트)
Step	Job 안의 세부 명령어 (ex. npm install)
Action	미리 만들어진 자동화 스크립트 (ex. checkout, setup-java)
📌 Spring Boot 예제
yaml
복사
편집
# .github/workflows/deploy.yml

name: Spring Boot CI/CD

on:
  push:
    branches: [ "main" ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Set up JDK 17
        uses: actions/setup-java@v3
        with:
          java-version: '17'
          distribution: 'temurin'

      - name: Build with Gradle
        run: ./gradlew build

      - name: Deploy to Server (예시)
        run: |
          ssh user@yourserver "docker pull yourimage && docker restart app"
 주요 포인트:

push 이벤트 발생 → 빌드 → 서버에 배포 명령 실행

📌 Node.js(Express) 예제
yaml
복사
편집
name: Node.js CI/CD

on:
  push:
    branches: [ "main" ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'

      - name: Install dependencies
        run: npm install

      - name: Run tests
        run: npm run test

      - name: Deploy
        run: |
          ssh user@yourserver "pm2 reload ecosystem.config.js"
 3. Git Submodule (다른 저장소를 하위 모듈로 연결)
📌 Git Submodule이란?
하나의 저장소 안에 다른 Git 저장소를 종속시키는 방법

공통 라이브러리, 공용 코드베이스를 하위 모듈로 관리

예: Frontend + Backend를 하나의 Repo로 통합할 때 사용

📌 Submodule 추가하기
bash
복사
편집
git submodule add https://github.com/username/other-repo.git 경로
현재 프로젝트에 다른 Git 프로젝트를 삽입

bash
복사
편집
git commit -m "Add submodule"
git push origin main
📌 Submodule Clone
bash
복사
편집
# 기본 clone
git clone https://github.com/yourrepo/main-project.git

# 서브모듈까지 초기화
git submodule init
git submodule update
 한 번에 전체 clone하는 방법

bash
복사
편집
git clone --recurse-submodules https://github.com/yourrepo/main-project.git
📌 Submodule 업데이트
bash
복사
편집
git submodule update --remote --merge
하위 모듈의 최신 버전 가져오기

📌 주의사항

주의 포인트	설명
서브모듈 커밋 필요	상위 프로젝트에도 서브모듈 포인터 커밋 필요
버전 동기화 관리 필요	하위 모듈 버전이 상위와 호환되어야 안정적
관리 복잡성 주의	서브모듈은 설정이 복잡하므로 명확한 관리 규칙 필요
✨ 최종 요약
 Git Flow는 협업을 위한 브랜치 관리 전략이다.
 GitHub Actions로 CI/CD 자동화를 구현할 수 있다.
 Git Submodule로 하위 Git 프로젝트를 연결해 복합 프로젝트 관리가 가능하다.

GitLab CI/CD vs GitHub Actions 비교 (심화)
📌 둘 다 무엇인가?

항목	설명
GitLab CI/CD	GitLab에 내장된 빌드·테스트·배포 자동화 도구
GitHub Actions	GitHub에서 제공하는 워크플로우 기반 자동화 도구
둘 다 "코드 변경 → 자동 빌드 → 테스트 → 배포"를 목표로 합니다.

📌 구조 비교

항목	GitLab CI/CD	GitHub Actions
구성 방식	.gitlab-ci.yml 파일	.github/workflows/*.yml 파일
빌드 실행	GitLab Runner 필요 (직접 구축 or Shared 사용)	GitHub가 Runner 제공
유연성	고도로 자유로움, 모든 Job/Stage를 구성 가능	Workflow → Job → Step 순서로 구조화
통합성	GitLab 내부의 Issue/PR/Deploy 기능과 강하게 연결	GitHub PR/Issue와 밀접하게 연결
권한 관리	매우 세밀한 권한 설정 지원 (Role, Runner Scope)	권한 관리는 간단하지만 덜 세밀함
무료 사용	GitLab.com: 400 CI minutes/월 (그 이상 유료)	GitHub: 2000 minutes/월 (무료 Tier)
시장 점유율	주로 DevOps 특화 기업 (GitLab 기반 회사)	오픈소스 프로젝트, SaaS 스타트업에 강세
📌 사용성 요약

상황	추천
회사 내부 서버에서 자체 구축 필요	GitLab CI/CD
퍼블릭 프로젝트 / 오픈소스 / SaaS 빠른 개발	GitHub Actions
복잡한 멀티 서비스 빌드 파이프라인 필요	GitLab CI/CD
단순하고 빠른 배포 자동화	GitHub Actions
 GitHub Actions 고급 스크립트 작성법 (심화)
📌 고급 키워드

키워드	설명
matrix 전략	다양한 환경/버전별로 병렬 테스트
artifact 저장	빌드 결과물을 저장하고 다른 Job과 공유
secrets 관리	API 키나 인증정보를 암호화하여 저장
condition (if:)	특정 조건에 따라 Step 실행 여부 결정
📌 예시 1: Matrix 빌드
Node.js 16, 18 버전 모두 테스트하는 경우

yaml
복사
편집
jobs:
  build:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: [16, 18]

    steps:
      - uses: actions/checkout@v4
      - name: Use Node.js ${{ matrix.node-version }}
        uses: actions/setup-node@v3
        with:
          node-version: ${{ matrix.node-version }}
      - run: npm install
      - run: npm run test
 장점: Node.js 16과 18을 동시에 병렬 테스트.

📌 예시 2: 빌드 Artifact 저장
yaml
복사
편집
jobs:
  build:
    steps:
      - run: npm run build

      - name: Upload build
        uses: actions/upload-artifact@v4
        with:
          name: build-result
          path: dist/
 다른 Job이 다운로드해서 사용할 수 있음

📌 예시 3: Secrets 활용
yaml
복사
편집
jobs:
  deploy:
    steps:
      - name: Deploy to server
        run: ssh user@host "deploy.sh"
        env:
          DEPLOY_KEY: ${{ secrets.DEPLOY_KEY }}
 secrets에 저장된 민감 정보를 안전하게 사용

 Git Monorepo 전략 (TurboRepo 등) 심화
📌 Monorepo란?
여러 프로젝트를 하나의 저장소(Repository)로 통합하는 방식.

 Backend + Frontend + Common Library까지 한 곳에서 관리
 대형 기업(Facebook, Google) 대부분 Monorepo 운영

📌 Monorepo 장점

장점	설명
일관된 버전 관리	한 번에 버전, 패키지 관리 가능
코드 공유 용이	여러 앱에서 공통 모듈 쉽게 사용
원자적 변경 가능	하나의 커밋으로 여러 앱 업데이트 가능
통합 테스트 편리	모든 프로젝트를 한 번에 빌드/테스트 가능
📌 TurboRepo란?
Vercel이 만든 Monorepo 관리 도구 (Next.js 친화적)

 빠른 캐시 기반 빌드
 의존성 그래프 자동 생성
 병렬 빌드 / 디플로이 지원

📌 TurboRepo 기본 구조
markdown
복사
편집
apps/
  - frontend/
  - backend/
packages/
  - ui/
  - utils/
turbo.json

디렉토리	설명
apps	실제 실행할 애플리케이션 (ex. FE, BE)
packages	공통 라이브러리 (UI 컴포넌트, 유틸리티)
turbo.json	TurboRepo 설정 파일 (pipeline 관리)
📌 Turbo.json 예시
json
복사
편집
{
  "pipeline": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": ["dist/**"]
    },
    "lint": {},
    "test": {
      "dependsOn": ["build"]
    }
  }
}
 설명:

build는 상위 의존성까지 빌드 후 실행

test는 build가 완료되어야 실행

dist/** 결과물만 저장

📌 Monorepo 주의점

주의 포인트	설명
Build 시간	대규모 프로젝트는 빌드 시간이 오래 걸릴 수 있음
권한 관리	각각의 앱/패키지 별로 권한 분리 어렵다
CI/CD 최적화	불필요한 전체 빌드를 방지하는 설정 필요 (TurboRepo solve)
✨ 여기까지 요약
 GitLab CI/CD vs GitHub Actions 비교로 실무 선택 기준 이해 완료
 GitHub Actions로 Matrix, Artifact, Secrets 고급 작성법 습득
 Monorepo 전략 이해하고 TurboRepo로 최적화하는 법 학습

TurboRepo 고급 캐시 최적화 기법
📌 TurboRepo 캐시 기본 원리
Turbo는 각 작업(Job)의 **입력(Input)**과 **출력(Output)**을 기억합니다.

동일한 입력이 들어오면 → 기존 캐시 결과 재사용.

로컬 디스크(Local Cache) 또는 Remote Cache(클라우드) 사용 가능.

📌 고급 최적화 테크닉

기술	설명
Remote Cache 사용	팀원 간 결과 공유 (Vercel/Turborepo Cloud 지원)
outputs 명시	turbo.json에 outputs를 명시해서 캐시 대상 정확히 설정
onlyChanged	변경된 패키지만 빌드하도록 설정 (turbo run build --filter)
--cache-dir	로컬 캐시 디렉토리 경로 지정해서 디스크 최적화
📌 turbo.json 고급 설정 예시
json
복사
편집
{
  "pipeline": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": ["dist/**", "build/**"],
      "inputs": ["src/**", "package.json", "tsconfig.json"]
    }
  },
  "globalDependencies": ["package-lock.json"],
  "remoteCache": {
    "enabled": true,
    "url": "https://your-remote-cache-server.com"
  }
}
 포인트:

outputs, inputs 명시 → 정확한 캐시 제어

remoteCache로 팀 전체 속도 향상

📌 Remote Cache 간단 구축 방법
bash
복사
편집
npx @turbo/codemod@latest init-remote-cache
OR
Vercel 연결 시 바로 사용 가능 (터보 로그인 후 자동 연결)

 GitHub Actions + Monorepo 조합 실전 구축 예제
📌 목표
apps/frontend, apps/backend 각각 빌드

packages/ 수정되면 관련 apps만 재빌드

캐시 활용

📌 GitHub Actions Workflow 예시
yaml
복사
편집
name: Monorepo Build

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: 18

      - name: Install TurboRepo
        run: npm install turbo

      - name: Install Dependencies
        run: npm ci

      - name: Turbo Build (Changed only)
        run: npx turbo run build --filter=...[HEAD^1] # 변경된 것만!

      - name: Upload Artifacts
        uses: actions/upload-artifact@v4
        with:
          name: dist-files
          path: apps/**/dist/
 turbo run --filter를 통해 변경된 앱만 빌드해서 속도 극대화!
 캐시 자동 적용!

 Nx(또 다른 Monorepo 툴)와 TurboRepo 비교

항목	TurboRepo	Nx
소유	Vercel	Nrwl (Angular 창시자 출신)
주 사용자	React/Next.js 기반 프로젝트	Angular/Nest.js + 풀스택 환경
캐시 전략	파일 기반 + Remote Cache	Task Graph 기반 (더 세밀)
러닝 커브	매우 쉬움 (초기 셋업 빠름)	약간 어려움 (Workspace 설정 많음)
특징	변경된 패키지만 자동 캐시	변경된 의존성 분석까지 가능
설정 파일	turbo.json	nx.json, project.json (복잡)
자동화 기능	빌드/테스트/디플로이만	린팅, 포맷팅, 데모 생성 등 올인원 가능
📌 요약 정리

선택 기준	추천 툴
단순한 빌드 최적화 위주	TurboRepo
대규모 풀스택 프로젝트 관리 필요	Nx
Next.js 기반 프론트 개발에 최적	TurboRepo
Angular, Nest.js 기반 시스템 구축	Nx


---

[🔙 Back to Portfolio Main](../index.md)

---

