---
layout: default
title: Security Best Practies

---

---

## 목차

### 🔗 [Security Best Practices](/study/authentication-and-security/)

1. 왜 Security Best Practices가 필요한가?
보안은 설계 초기에 고려되어야 한다
(나중에 붙이면 치명적 취약점 발생 가능)

90% 이상의 보안 사고는 기본을 지키지 않아 발생
(OWASP Top 10 참고)

개발, 배포, 운영 전체 생명주기(Lifecycle)에 보안을 녹여야 한다

2. 기본 원칙 (Fundamental Principles)

항목	설명
최소 권한 원칙 (Principle of Least Privilege)	필요한 만큼만 권한 부여
보안은 기본값(Default Secure Settings)	기본 설정이 항상 안전하도록
방어적 프로그래밍(Defensive Programming)	입력 검증, 예외 방어 철저
fail-safe defaults	실패 시에도 시스템은 안전 상태로
지속적 모니터링 및 패치	취약점 발견 즉시 대응
3. 분야별 Security Best Practices
📦 인증(Authentication)
비밀번호 해시 저장 (bcrypt/argon2 사용)

JWT/OAuth2 등 표준 인증 프로토콜 사용

비밀번호 최소 길이/복잡성 정책 적용

2FA (Two-Factor Authentication) 활성화 권장

로그인 시도 횟수 제한 (Brute Force 방지)

🔐 권한 부여(Authorization)
권한 분리 (User, Admin 등 Role 기반 권한 관리)

최소 권한 원칙 적용 (RBAC, ABAC)

수직/수평 권한 상승 방어 (Authorization Bypass 방지)

🌐 API 보안
CORS 설정 명확히 지정 (Access-Control-Allow-Origin 제한)

API 요청은 반드시 인증 + 인가 처리

모든 API에 Rate Limiting 적용

Error 응답 시 내부 시스템 정보 노출 금지 (에러 메시지 최소화)

🗂 데이터 보안
암호화 저장(Encrypt at Rest)
➔ 중요한 데이터는 데이터베이스에서 암호화 저장 (AES-256 등)

전송 암호화(Encrypt in Transit)
➔ 모든 데이터 전송은 HTTPS 사용

민감정보 (PII) 최소 수집, 최소 보관

로그에 개인정보 저장 금지

🏛 인프라 보안
보안 그룹, 방화벽 설정 필수 (AWS Security Group 등)

서버 인바운드 포트 최소화 (22, 80, 443만 허용 등)

시스템 및 라이브러리 최신 패치 적용

DB 접근 제어 (IP 제한, SSL 연결)

🔎 로깅 및 모니터링
로그 감시 및 알림 설정 (ELK Stack, Grafana Alerts)

모든 보안 이벤트 (로그인 실패, 권한 변경 등) 기록

Audit Trail(감사 로그) 유지

4. 추가 심화: OWASP Top 10 체크리스트 (2021)

항목	설명
A01: Broken Access Control	권한 검사 실패 방어 필수
A02: Cryptographic Failures	암호화 실수 방지
A03: Injection	SQL Injection 방어 (PreparedStatement 등)
A04: Insecure Design	설계 단계부터 보안 반영
A05: Security Misconfiguration	잘못된 설정 금지 (ex. 디폴트 계정 제거)
A06: Vulnerable Components	오래된 라이브러리 주의
A07: Identification and Authentication Failures	인증 실패 방어 (2FA 도입)
A08: Software and Data Integrity Failures	배포 시 무결성 검증 (코드 서명)
A09: Security Logging and Monitoring Failures	침해 탐지 및 대응 시스템 필수
A10: Server-Side Request Forgery (SSRF)	서버 내부 요청 방어
5. 프레임워크별 Security 적용 예시
5.1 Spring Security (Java)
CSRF 보호 기본 활성화

JWT + OAuth2 인증

PasswordEncoder 필수 적용

Method-level Security (@PreAuthorize 등)

5.2 Express.js (Node.js)
helmet 미들웨어로 보안 헤더 설정

cors 패키지로 CORS 정책 제한

express-rate-limit으로 API 요청 제한

bcrypt로 비밀번호 해시 저장

5.3 Django (Python)
CSRF 보호 기본 활성화

Django REST Framework 인증 모듈 사용

SECRET_KEY 보호

https 세션 쿠키 강제 설정 (SECURE_SSL_REDIRECT = True)

6. 실무 시스템 설계에 반영하는 방법
프로젝트 초기 설계 문서에 보안 고려사항 명시
(ex: API 인증방식, 비밀번호 저장정책)

CI/CD 파이프라인에 취약점 스캐너 자동화 도입
(ex: Snyk, SonarQube, Trivy)

운영 시스템은 주기적 펜테스트(Penetration Test) 수행

모든 신규 기능은 Threat Modeling을 통해 위협 분석

🛡 최종 요약

카테고리	요약 키워드
인증(Authentication)	비밀번호 해시 저장, 2FA 적용
인가(Authorization)	최소 권한 원칙, 권한 상승 방지
데이터(Data)	저장/전송 모두 암호화
인프라(Infrastructure)	포트 제한, 방화벽 적용
모니터링(Logging)	보안 로그 필수, 침해 대응

7. OWASP Top 10 심화 — 실제 예제와 대응 전략
A01. Broken Access Control (접근 제어 실패)
문제: 로그인했어도 내 정보가 아닌 다른 사람 데이터에 접근 가능

Spring Boot 대응:

java
복사
편집
@PreAuthorize("hasRole('USER') and #userId == authentication.principal.id")
public UserProfile getProfile(UUID userId) {
    return userService.getProfile(userId);
}
Express 대응:

javascript
복사
편집
app.get('/user/:id', (req, res) => {
    if (req.user.id !== req.params.id) {
        return res.status(403).send('Forbidden');
    }
    // 본인 데이터만 접근 허용
});
 핵심: 컨트롤러 레벨에서 ID 체크 철저하게

A02. Cryptographic Failures (암호화 실패)
문제: 비밀번호를 평문으로 저장하거나 암호화 안 함

Django 기본 대응:

python
복사
편집
from django.contrib.auth.hashers import make_password

hashed_pw = make_password('plain_password')
 핵심: 암호화 저장은 기본 중 기본! (bcrypt, argon2)

A03. Injection (SQL Injection 등)
문제: 쿼리에 사용자 입력값을 직접 넣으면 위험

Spring Boot 대응 (JPA 사용):

java
복사
편집
@Query("SELECT u FROM User u WHERE u.username = :username")
User findByUsername(@Param("username") String username);
Express 대응 (MySQL):

javascript
복사
편집
db.query('SELECT * FROM users WHERE username = ?', [username], callback);
 핵심: PreparedStatement/바인딩 쿼리 사용!

A04. Insecure Design (보안성 없는 설계)
문제: 설계 자체에 인증/권한 없는 API 존재

대응:

모든 API 요청에 인증/인가 필수

민감 API는 별도 인증 추가 (ex: 비밀번호 변경)

A05. Security Misconfiguration (잘못된 설정)
문제: 디폴트 설정 유지 (ex: 디폴트 Admin 계정 존재)

Spring Boot 대응:

yaml
복사
편집
management:
  endpoints:
    web:
      exposure:
        exclude: '*'
 핵심: 서버, DB, API 기본 보안 설정 커스터마이징 필수

(※ 나머지 A06~A10도 원하면 추가 상세히 이어갈 수 있습니다!)

8. Spring, Express, Django 보안 적용 심화
🛡 Spring Security 심화 적용
CSRF Token + SameSite 쿠키 조합

OAuth2 인증 + JWT 토큰 조합

Method-level Security 활성화 (@PreAuthorize, @Secured)

SecurityContextHolder 통한 세션 상태 관리

🛡 Express.js 보안 강화
helmet → HTTP 보안 헤더 강화

express-rate-limit → API 공격 방지

express-validator → 입력 검증

jwt + refresh 토큰 관리 (서버 사이드 검증)

🛡 Django 보안 최적화
SECURE_SSL_REDIRECT = True (HTTPS 강제)

X_FRAME_OPTIONS = 'DENY' (Clickjacking 방지)

CSRF_COOKIE_SECURE = True (HTTPS 쿠키 강제)

django-axes 설치 → 로그인 실패 감지/차단

9. 아키텍처 레벨 보안 설계 전략
📦 레이어별 보안

레이어	적용 보안 방법
Client	JWT 토큰 관리, HTTPS 강제, 입력 검증
API Gateway	Rate Limit, IP 차단, 인증 토큰 검증
Backend API	RBAC, Input Validation, 암호화 저장
DB	접근 제어 (IP Whitelist), 데이터 암호화
Logging System	민감정보 로그 저장 금지
🔥 OAuth2 아키텍처 흐름 예시
Client ➔ Authorization Server (로그인 요청)

Authorization Server ➔ Access Token 발급

Client ➔ Resource Server(API) 요청 시 Access Token 첨부

Resource Server ➔ 토큰 검증 후 데이터 반환

10. 실무 체크리스트 (진짜 중요한 것만)
 모든 API는 인증 + 인가 반드시 적용
 비밀번호는 bcrypt/argon2로 해시 저장
 입력값은 1차 (프론트) + 2차 (서버) 검증
 서버, DB는 기본값으로 돌리지 말고 Harden 적용
 정기 취약점 점검 (보안 업데이트 자동화 포함)
 이상 행위(로그인 실패 등) 감지 시스템 구축

📚 요약 정리

구분	핵심 키워드
기본	인증/인가 철저, 비밀번호 해시, CSRF/XSS 방어
API	Rate Limiting, IP 필터링, CORS 제한
인프라	최소 포트 오픈, 서버 보안그룹 설정
모니터링	보안 로그 기록, 이상 탐지 알람
시스템 설계	보안은 설계 초기부터 반영, OAuth2 + JWT 구조

✍️ 다음 단계 추천
OWASP Top 10 나머지 상세 예시 (A06~A10)

Token 관리 (Refresh Token Rotation 전략)

서버 간 통신 보안 (mTLS 적용 방법)

CI/CD 파이프라인 보안 (Secrets 관리 전략)


---

[🔙 Back to Portfolio Main](../index.md)

---



