---
layout: default
title: Oauth2 Social Login
---

## 목차

### 🔗 [OAuth2 Social Login](/study/authentication-and-security/)

1. OAuth2 기초 개념
인증(Authentication) vs 인가(Authorization)

인증: “이 사람이 누구인가?”

인가: “이 사람이 뭘 할 수 있는가?”
OAuth2는 본래 인가를 위한 프로토콜이지만, 소셜 로그인에서는 인증 수단으로도 자주 활용됩니다.

주요 역할(Roles)

Resource Owner: 최종 사용자(예: 당신의 고객)

Client: 사용자 대신 요청하는 애플리케이션(예: 내 웹 서비스)

Authorization Server (IdP): 구글·페이스북 등의 인증 서버

Resource Server: 실제 사용자 정보를 보관하고 있는 API 서버(구글 프로필 API 등)

Grant Type(인가 방식)

Authorization Code Grant: 서버사이드 애플리케이션에 권장

Implicit Grant: SPA(요즘은 잘 안 쓰임)

Password Grant: 자격 증명 직접 전달(권장 X)

Client Credentials Grant: 서버 대 서버 통신

소셜 로그인에서는 대부분 Authorization Code Grant를 사용하며, 보안을 강화한 PKCE(Public Key for Code Exchange) 를 SPA나 모바일 앱에도 적용합니다.

2. Authorization Code Grant 흐름
사용자 → 클라이언트
“소셜 로그인 버튼 클릭 → /oauth2/authorize?client_id=…&redirect_uri=…&scope=…&state=…”로 IdP에 리다이렉트

클라이언트 → IdP 로그인 화면
사용자가 구글 로그인

IdP → 클라이언트
로그인 성공 후 ?code=AUTH_CODE&state=…를 redirect_uri로 전달

클라이언트 서버 → IdP 토큰 엔드포인트
POST /oauth2/token

grant_type=authorization_code

code=AUTH_CODE

client_id·client_secret (비밀)

redirect_uri

IdP → 클라이언트 서버

access_token, (선택) refresh_token, id_token(OIDC) 등 반환

클라이언트 서버 → IdP 리소스 서버
GET /userinfo 또는 JWT 디코딩으로 사용자 프로필 취득

클라이언트 서버

내부 세션 또는 자체 JWT 발급 후 프론트엔드로 전달

이후 Stateless API 요청 시 자체 토큰으로 인증 처리

3. 소셜 로그인 적용 예시
3.1. Spring Boot + Spring Security
yaml
복사
편집
# application.yml
spring:
  security:
    oauth2:
      client:
        registration:
          google:
            client-id: <GOOGLE_CLIENT_ID>
            client-secret: <GOOGLE_CLIENT_SECRET>
            scope: openid,profile,email
            redirect-uri: "{baseUrl}/login/oauth2/code/{registrationId}"
        provider:
          google:
            authorization-uri: https://accounts.google.com/o/oauth2/v2/auth
            token-uri:         https://www.googleapis.com/oauth2/v4/token
            user-info-uri:     https://www.googleapis.com/oauth2/v3/userinfo
            user-name-attribute: sub
java
복사
편집
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {
  @Override
  protected void configure(HttpSecurity http) throws Exception {
    http
      .oauth2Login()
        .loginPage("/login")                       // 커스텀 로그인 페이지
        .userInfoEndpoint()
          .userService(customOAuth2UserService)    // 내 로직으로 사용자 프로필 가공
      .and()
      .and()
      .authorizeRequests()
        .antMatchers("/login","/css/**").permitAll()
        .anyRequest().authenticated();
  }
}
CustomOAuth2UserService 에서 DefaultOAuth2UserService 호출 후

구글이 준 속성(email, name, picture)을 꺼내

내 DB 회원 테이블과 매핑하거나 신규 회원 생성

OAuth2User → UserDetails 로 변환

3.2. Express.js + Passport
bash
복사
편집
npm install passport passport-google-oauth20 express-session
js
복사
편집
// app.js
import express from 'express';
import passport from 'passport';
import { Strategy as GoogleStrategy } from 'passport-google-oauth20';
import session from 'express-session';

passport.use(new GoogleStrategy({
    clientID:     process.env.GOOGLE_ID,
    clientSecret: process.env.GOOGLE_SECRET,
    callbackURL:  "/auth/google/callback"
  },
  (accessToken, refreshToken, profile, done) => {
    // profile.id, profile.emails[0].value, profile.photos[0].value 등
    // DB 매핑 또는 신규 유저 생성 로직
    done(null, profile);
  }
));

passport.serializeUser((user, done) => done(null, user));
passport.deserializeUser((obj, done) => done(null, obj));

const app = express();
app.use(session({ secret: 'secret', resave: false, saveUninitialized: true }));
app.use(passport.initialize());
app.use(passport.session());

app.get('/auth/google',
  passport.authenticate('google', { scope: ['profile','email'] }));

app.get('/auth/google/callback', 
  passport.authenticate('google', { failureRedirect: '/login' }),
  (req, res) => res.redirect('/'));
3.3. Django REST Framework + Social Auth
bash
복사
편집
pip install djangorestframework-simplejwt django-allauth dj-rest-auth
python
복사
편집
# settings.py
INSTALLED_APPS = [
    ...,
    'rest_framework',
    'rest_framework_simplejwt',
    'dj_rest_auth',
    'allauth',
    'allauth.account',
    'allauth.socialaccount',
    'allauth.socialaccount.providers.google',
    'dj_rest_auth.registration',
]
REST_USE_JWT = True
python
복사
편집
# urls.py
from django.urls import path, include

urlpatterns = [
    path('auth/', include('dj_rest_auth.urls')),
    path('auth/registration/', include('dj_rest_auth.registration.urls')),
    path('auth/social/', include('dj_rest_auth.social_urls')),  # 구글 등
]
/auth/social/google/ 에 POST로 access_token 보내면

DRF가 구글 API 호출 → 사용자 정보 확인

JWT 액세스·리프레시 토큰 발급

4. 심화: OpenID Connect(OIDC)와 보안 고려 사항
OIDC vs OAuth2

OIDC: OAuth2 위에 “ID 토큰(id_token)” 스펙을 추가한 인증 레이어

ID 토큰(JWT) 안에 sub, email_verified, azp 등 사용자 인증 정보 포함

PKCE (Proof Key for Code Exchange)

Public 클라이언트(모바일·SPA) 용 안전장치

code_verifier → 해시한 code_challenge 전달 → 토큰 교환 시 원본 검증

State 파라미터

CSRF 방어용, 로그인 시 랜덤 문자열 → 리다이렉트 시 검증

쿠키 vs 로컬 스토리지

액세스 토큰: 보통 메모리/로컬 스토리지

리프레시 토큰: HttpOnly Secure 쿠키

Dynamic Client Registration

OIDC Discovery(.well-known/openid-configuration) 활용

런타임에 IdP 정보(엔드포인트, 공개키) 자동 로드

5. OAuth2 “State” 파라미터
목적: CSRF(Cross-Site Request Forgery) 방어

흐름

클라이언트가 /oauth2/authorize?...&state=XYZ123 로 요청

IdP(예: 구글)가 인증 후 redirect_uri?code=…&state=XYZ123 로 리다이렉트

클라이언트가 응답 state 값이 애플리케이션이 보낸 값(XYZ123)과 동일한지 검증

구현 (Java 예시)

java
복사
편집
String state = UUID.randomUUID().toString();
request.getSession().setAttribute("oauth2_state", state);
String redirect = UriComponentsBuilder
    .fromUriString(AUTH_URL)
    .queryParam("client_id", clientId)
    .queryParam("redirect_uri", redirectUri)
    .queryParam("scope", "openid profile email")
    .queryParam("state", state)
    .toUriString();
response.sendRedirect(redirect);
검증

java
복사
편집
String original = (String) request.getSession().getAttribute("oauth2_state");
if (!original.equals(request.getParameter("state"))) {
  throw new IllegalStateException("Invalid state");
}
6. PKCE (Proof Key for Code Exchange)
SPA나 모바일 앱 같은 Public Client 에서 client_secret 노출 위험을 막기 위해 사용합니다.

code_verifier: 클라이언트에서 랜덤 생성 (43~128자 URL-safe 문자열)

code_challenge:

S256 방식: BASE64URL-ENCODE(SHA256(code_verifier))

혹은 plain 방식

인가 요청

bash
복사
편집
GET /authorize?response_type=code
  &client_id=…
  &redirect_uri=…
  &code_challenge=xyz123
  &code_challenge_method=S256
토큰 요청

bash
복사
편집
POST /token
  grant_type=authorization_code
  code=AUTH_CODE
  redirect_uri=…
  client_id=…
  code_verifier=xyz123
서버가 code_challenge=S256(code_verifier) 와 일치하면 토큰 발급

7. Scope(범위) 설계
표준 OpenID Connect 스코프

openid (ID 토큰 발급)

profile (이름, 프로필 사진 등)

email

커스텀 스코프

예: read:orders, write:profile

요청 예시

perl
복사
편집
GET /authorize?
  client_id=…
  &scope=openid%20profile%20email%20read:orders
8. 토큰 검증 심화
JWT 서명 검증

대칭키 (HS256): 서버 secret 으로 검증

비대칭키 (RS256): IdP 공개키(jwks_uri 에서 다운로드) 로 검증

JWKs Fetch & 캐싱

java
복사
편집
NimbusJwtDecoder jwtDecoder = NimbusJwtDecoder
  .withJwkSetUri("https://accounts.google.com/.well-known/jwks.json")
  .build();
클레임 검증

iss (issuer)

aud (audience)

exp, iat

9. 리프레시 토큰 회전 & 블랙리스트
회전(Rotation)

/auth/refresh 호출 시 매번 새로운 리프레시 토큰 발급

이전 토큰은 무효화 → 재사용 공격 방지

블랙리스트

Redis 등에 {refreshToken: 만료시간} 형태로 저장

사용 후 삭제하거나, 도난된 토큰은 블랙리스트에 추가

10. 다중 소셜 로그인 처리
Spring Security

yaml
복사
편집
spring:
  security:
    oauth2:
      client:
        registration:
          google: { … }
          facebook:
            client-id: …
            client-secret: …
            scope: email,public_profile
CustomOAuth2UserService 에서 registrationId 로 분기 처리

Express.js / Passport

js
복사
편집
passport.use(new FacebookStrategy({ … }, verify));
passport.use(new GoogleStrategy({ … }, verify));
verify(accessToken, refreshToken, profile, done) 에서 profile.provider로 구분

11. 오류 처리 & 디버깅
로그 확인

Spring: logging.level.org.springframework.security.oauth2=DEBUG

Express: passport.authenticate('google', { failureRedirect: '/login?error' })

Common Errors

redirect_uri mismatch

invalid_client

invalid_scope

state 불일치

12. 로그아웃 & 세션 무효화
애플리케이션 로그아웃

Spring: SecurityContextHolder.clearContext()

Passport: req.logout()

IdP 로그아웃 (Single Logout)

구글: 직접 지원 안 함

Azure AD/OIDC: end_session_endpoint?post_logout_redirect_uri=…

13. 테스트 전략
통합 테스트

Spring: @WebMvcTest + MockMvc 로 /oauth2/authorize → /login/oauth2/code/google 시나리오

단위 테스트

JwtUtil 메서드별 검증

PKCE code_challenge 생성 및 검증





---
[🔙 Back to Portfolio Main](../index.md)

---
