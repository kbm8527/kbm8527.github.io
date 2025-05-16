---
layout: default
title: Jwt Authentication
---

---

## 목차

### 🔗 [JWT Authentication](/study/authentication-and-security/)

JWT (JSON Web Token) 인증은 “무상태(stateless)” 방식의 토큰 기반 인증 메커니즘으로, 서버가 사용자 정보를 메모리에 저장하지 않고도 사용자를 인증·인가할 수 있게 해 줍니다. 크게 발급(issuance), 전달(transport), **검증(verification)**의 세 단계로 동작합니다.

1. JWT 구조
JWT는 점(.)으로 구분된 세 부분으로 이루어집니다:

css
복사
편집
HEADER.PAYLOAD.SIGNATURE
Header

json
복사
편집
{
  "alg": "HS256",    // 서명 알고리즘 (HMAC SHA256 등)
  "typ": "JWT"
}
Payload (Claims)

json
복사
편집
{
  "sub": "user123",      // Subject (보통 사용자 고유 ID)
  "roles": ["USER","ADMIN"],
  "iat": 1616581123,     // 발급 시간(issued at)
  "exp": 1616584723      // 만료 시간(expiration)
}
Signature

scss
복사
편집
HMACSHA256(
  base64UrlEncode(header) + "." +
  base64UrlEncode(payload),
  secretKey
)
2. 인증 흐름
로그인 요청
사용자가 아이디/비밀번호로 /login 요청

토큰 발급
서버가 사용자 정보 확인 후, 위 구조의 JWT를 생성해 응답 바디나 쿠키에 담아 클라이언트에 보냄

json
복사
편집
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5..."
}
클라이언트 저장

브라우저: localStorage 혹은 보안을 위해 HttpOnly 쿠키

인증 필요한 요청

매 요청마다 HTTP 헤더에

makefile
복사
편집
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5...
혹은 쿠키를 통한 자동 전송

서버 검증

서버는 Authorization 헤더에서 JWT 추출

비밀키(또는 공개키)로 서명을 검증

만료시간(exp) 체크, payload의 sub, roles 등 claim을 읽어 SecurityContext 에 사용자 정보 세팅

리소스 접근 허용/거부

컨트롤러나 필터에서 roles·authorities 기반으로 인가 처리

3. Spring Boot 적용 예시
3.1. JWT 생성 (AuthenticationController)
java
복사
편집
@PostMapping("/login")
public ResponseEntity<?> login(@RequestBody LoginRequest req) {
  Authentication auth = authManager.authenticate(
    new UsernamePasswordAuthenticationToken(req.getUsername(), req.getPassword()));
  
  String token = jwtUtil.generateToken(auth);
  return ResponseEntity.ok(new JwtResponse(token));
}
3.2. JWT 검증 필터
java
복사
편집
@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {
  @Autowired private JwtUtil jwtUtil;
  @Autowired private UserDetailsService uds;

  @Override
  protected void doFilterInternal(
      HttpServletRequest req, HttpServletResponse res, FilterChain chain)
      throws ServletException, IOException {

    final String header = req.getHeader("Authorization");
    if (header != null && header.startsWith("Bearer ")) {
      String jwt = header.substring(7);
      if (jwtUtil.validateToken(jwt)) {
        String username = jwtUtil.getUsername(jwt);
        UserDetails user = uds.loadUserByUsername(username);
        UsernamePasswordAuthenticationToken auth =
            new UsernamePasswordAuthenticationToken(user, null, user.getAuthorities());
        SecurityContextHolder.getContext().setAuthentication(auth);
      }
    }
    chain.doFilter(req, res);
  }
}
3.3. Security 설정에 필터 등록
java
복사
편집
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {
  @Autowired JwtAuthenticationFilter jwtFilter;

  @Override
  protected void configure(HttpSecurity http) throws Exception {
    http
      .csrf().disable()
      .sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS)
      .and()
      .authorizeRequests()
        .antMatchers("/login", "/public/**").permitAll()
        .anyRequest().authenticated()
      .and()
      .addFilterBefore(jwtFilter, UsernamePasswordAuthenticationFilter.class);
  }
}
4. 주의사항 & 모범 사례
비밀키 관리: 절대 코드에 하드코딩하지 말고, 환경 변수나 시크릿 매니저에 보관

만료 시간: 짧게 설정하고, 리프레시 토큰으로 갱신 전략 사용

HTTPS: 토큰 탈취 방지를 위해 HTTPS 필수

CSRF 대응: 쿠키에 담을 때는 SameSite·HttpOnly 속성 사용

페이로드 민감정보 금지: 개인정보나 비밀번호는 절대 담지 않기


1. JWT(JSON Web Token) 인증 개요
JWT 구조

Header.Payload.Signature 세 부분으로 구성

Header: 토큰 타입(JWT), 서명 알고리즘(예: HS256)

Payload: 사용자 식별자(sub), 권한(roles), 발급시간(iat), 만료시간(exp) 등 클레임(claims)

Signature: 위 둘을 비밀키로 서명한 값 → 위변조 방지

무상태(stateless) 인증

서버가 세션 상태를 저장하지 않고, 전달된 JWT만으로 사용자 신원을 검증

확장성(scale-out)에 유리

2. 액세스 토큰 vs. 리프레시 토큰
액세스 토큰 (Access Token)
목적: API 호출 시 사용자 인증·인가 정보를 담아 요청

만료 시간: 짧게(보통 수분~수십 분)

저장 장소: 클라이언트 localStorage 또는 HttpOnly 쿠키

리프레시 토큰 (Refresh Token)
목적: 액세스 토큰이 만료됐을 때, 사용자 재로그인 없이 새로운 액세스 토큰을 발급받기 위함

만료 시간: 액세스 토큰보다 훨씬 길게(보통 며칠~수개월)

저장 장소: 보안상 HttpOnly 쿠키에 저장하는 것이 일반적

3. 만료 관리(Expiration Management)
액세스 토큰 만료 (exp)

짧은 만료 시간을 설정해 탈취당했을 때 피해를 최소화

클라이언트는 만료 직전 또는 만료 시점에 “리프레시 토큰”을 사용해 새로운 액세스 토큰 요청

리프레시 토큰 만료 관리

더 긴 유효기간을 주지만 무제한으로 두면 도난 시 위험

만료 검증: 리프레시 요청 시 DB나 인메모리 저장소(redis 등)에서 토큰의 유효 여부(만료, 취소 여부)를 확인

회전형 토큰(Rotation): 리프레시할 때마다 새로운 리프레시 토큰을 발급하고, 이전 토큰은 무효화(단 한 번만 사용 가능)

블랙리스트 방식: 탈취된 리프레시 토큰을 블랙리스트에 등록해 차단

리프레시 엔드포인트 보호

/auth/refresh 엔드포인트에 대한 Rate Limiting

IP 검증, 기기 식별 등을 추가로 적용

4. 토큰 갱신 흐름 예시
클라이언트가 로그인 → 액세스 토큰 + 리프레시 토큰 발급

클라이언트가 API에 Authorization: Bearer <accessToken> 헤더로 요청

서버가 액세스 토큰 검증 → 정상 응답

액세스 토큰 만료 시(401 Unauthorized)

클라이언트가 /auth/refresh 호출, 리프레시 토큰 포함(쿠키 자동 전송 or 요청 본문)

서버가 리프레시 토큰 검증(DB 조회, 블랙리스트 체크 등)

새 액세스 토큰(그리고 회전형인 경우 새 리프레시 토큰) 발급

클라이언트가 새 액세스 토큰으로 재요청

5. 보안 모범 사례
HTTPS: 토큰 탈취 방지

HttpOnly + Secure 쿠키: XSS로부터 리프레시 토큰 보호

SameSite=strict/lax: CSRF 위험 완화

짧은 액세스 토큰 + 회전형 리프레시 토큰: 탈취 피해 최소화

토큰 클레임 최소화: 민감 정보 배제

요약
JWT 인증은 “무상태” 방식으로 액세스 토큰만으로 사용자 권한을 처리

리프레시 토큰을 통해 액세스 토큰 만료 뒤 재로그인 없이 갱신

만료 관리(짧은 액세스, 긴 리프레시) + 회전형/블랙리스트 등으로 보안을 강화


1. Spring Security 예제
1.1. JwtUtil (토큰 생성/검증)
java
복사
편집
@Component
public class JwtUtil {
    @Value("${jwt.secret}") private String secret;
    @Value("${jwt.access.expiration}") private long accessMs;
    @Value("${jwt.refresh.expiration}") private long refreshMs;

    public String generateAccessToken(Authentication auth) {
        return Jwts.builder()
            .setSubject(auth.getName())
            .claim("roles", auth.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority).toList())
            .setIssuedAt(new Date())
            .setExpiration(new Date(System.currentTimeMillis() + accessMs))
            .signWith(SignatureAlgorithm.HS256, secret)
            .compact();
    }

    public String generateRefreshToken(Authentication auth) {
        return Jwts.builder()
            .setSubject(auth.getName())
            .setIssuedAt(new Date())
            .setExpiration(new Date(System.currentTimeMillis() + refreshMs))
            .signWith(SignatureAlgorithm.HS256, secret)
            .compact();
    }

    public boolean validateToken(String token) {
        try {
            Jwts.parser().setSigningKey(secret).parseClaimsJws(token);
            return true;
        } catch (JwtException e) {
            return false;
        }
    }

    public String getUsername(String token) {
        return Jwts.parser()
            .setSigningKey(secret)
            .parseClaimsJws(token)
            .getBody()
            .getSubject();
    }
}
1.2. JwtAuthenticationFilter
java
복사
편집
public class JwtAuthenticationFilter extends OncePerRequestFilter {
    @Autowired private JwtUtil jwtUtil;
    @Autowired private UserDetailsService uds;

    @Override
    protected void doFilterInternal(HttpServletRequest req, HttpServletResponse res, FilterChain chain)
            throws ServletException, IOException {
        String header = req.getHeader("Authorization");
        if (header != null && header.startsWith("Bearer ")) {
            String token = header.substring(7);
            if (jwtUtil.validateToken(token)) {
                String username = jwtUtil.getUsername(token);
                UserDetails user = uds.loadUserByUsername(username);
                Authentication auth = new UsernamePasswordAuthenticationToken(
                    user, null, user.getAuthorities());
                SecurityContextHolder.getContext().setAuthentication(auth);
            }
        }
        chain.doFilter(req, res);
    }
}
1.3. SecurityConfig
java
복사
편집
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {
    @Autowired JwtAuthenticationFilter jwtFilter;

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
          .csrf().disable()
          .sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS)
          .and()
          .authorizeRequests()
            .antMatchers("/auth/**").permitAll()
            .anyRequest().authenticated()
          .and()
          .addFilterBefore(jwtFilter, UsernamePasswordAuthenticationFilter.class);
    }
}
1.4. AuthController (로그인 · 토큰 갱신)
java
복사
편집
@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
public class AuthController {
    private final AuthenticationManager am;
    private final JwtUtil jwtUtil;
    private final UserDetailsService uds;

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginDto dto, HttpServletResponse res) {
        Authentication auth = am.authenticate(
            new UsernamePasswordAuthenticationToken(dto.getUsername(), dto.getPassword()));
        String access = jwtUtil.generateAccessToken(auth);
        String refresh = jwtUtil.generateRefreshToken(auth);

        // 리프레시 토큰을 HttpOnly 쿠키로 설정
        ResponseCookie cookie = ResponseCookie.from("refreshToken", refresh)
            .httpOnly(true).path("/auth/refresh").maxAge(jwtUtil.getRefreshMs() / 1000).build();
        res.addHeader(HttpHeaders.SET_COOKIE, cookie.toString());

        return ResponseEntity.ok(Map.of("accessToken", access));
    }

    @PostMapping("/refresh")
    public ResponseEntity<?> refresh(@CookieValue("refreshToken") String refreshToken) {
        if (!jwtUtil.validateToken(refreshToken)) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        String username = jwtUtil.getUsername(refreshToken);
        UserDetails user = uds.loadUserByUsername(username);
        Authentication auth = new UsernamePasswordAuthenticationToken(
            user, null, user.getAuthorities());

        String newAccess = jwtUtil.generateAccessToken(auth);
        String newRefresh = jwtUtil.generateRefreshToken(auth);
        // 새 리프레시 쿠키
        ResponseCookie cookie = ResponseCookie.from("refreshToken", newRefresh)
            .httpOnly(true).path("/auth/refresh").maxAge(jwtUtil.getRefreshMs() / 1000).build();

        return ResponseEntity.ok()
            .header(HttpHeaders.SET_COOKIE, cookie.toString())
            .body(Map.of("accessToken", newAccess));
    }
}
2. Express.js 예제
2.1. server.js
js
복사
편집
import express from 'express';
import jwt from 'jsonwebtoken';
import cookieParser from 'cookie-parser';

const app = express();
app.use(express.json());
app.use(cookieParser());

const ACCESS_SECRET = process.env.ACCESS_SECRET;
const REFRESH_SECRET = process.env.REFRESH_SECRET;
const refreshTokens = new Set(); // 간단 예제용, 실제론 DB/Redis 사용

// 로그인 → 토큰 발급
app.post('/auth/login', (req, res) => {
  const { username, password } = req.body;
  // TODO: 사용자 인증 로직
  const user = { username };
  const accessToken = jwt.sign(user, ACCESS_SECRET, { expiresIn: '15m' });
  const refreshToken = jwt.sign(user, REFRESH_SECRET, { expiresIn: '7d' });
  refreshTokens.add(refreshToken);

  res.cookie('refreshToken', refreshToken, {
    httpOnly: true, secure: true, path: '/auth/refresh'
  });
  res.json({ accessToken });
});

// 액세스 토큰 검증 미들웨어
function authenticateAccessToken(req, res, next) {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];
  if (!token) return res.sendStatus(401);
  jwt.verify(token, ACCESS_SECRET, (err, user) => {
    if (err) return res.sendStatus(403);
    req.user = user;
    next();
  });
}

// 리프레시 토큰으로 액세스 토큰 갱신
app.post('/auth/refresh', (req, res) => {
  const refreshToken = req.cookies.refreshToken;
  if (!refreshToken || !refreshTokens.has(refreshToken)) return res.sendStatus(401);

  jwt.verify(refreshToken, REFRESH_SECRET, (err, user) => {
    if (err) return res.sendStatus(403);
    // 토큰 회전(Rotation)
    refreshTokens.delete(refreshToken);
    const newRefresh = jwt.sign({ username: user.username }, REFRESH_SECRET, { expiresIn: '7d' });
    refreshTokens.add(newRefresh);

    const accessToken = jwt.sign({ username: user.username }, ACCESS_SECRET, { expiresIn: '15m' });
    res.cookie('refreshToken', newRefresh, {
      httpOnly: true, secure: true, path: '/auth/refresh'
    });
    res.json({ accessToken });
  });
});

// 보호된 라우트
app.get('/protected', authenticateAccessToken, (req, res) => {
  res.json({ message: `Hello ${req.user.username}` });
});

app.listen(3000, () => console.log('Server running on 3000'));
3. Django + DRF(Simple JWT) 예제
3.1. settings.py
python
복사
편집
INSTALLED_APPS = [
    ...,
    'rest_framework',
    'rest_framework_simplejwt',
]

REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': (
        'rest_framework_simplejwt.authentication.JWTAuthentication',
    ),
}

from datetime import timedelta
SIMPLE_JWT = {
    'ACCESS_TOKEN_LIFETIME': timedelta(minutes=15),
    'REFRESH_TOKEN_LIFETIME': timedelta(days=7),
    'ROTATE_REFRESH_TOKENS': True,
    'BLACKLIST_AFTER_ROTATION': True,
}
3.2. urls.py
python
복사
편집
from django.urls import path
from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView,
)

urlpatterns = [
    path('auth/login/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('auth/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    # 다른 라우트...
]
3.3. 보호된 뷰 예시
python
복사
편집
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated

class ProtectedView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        user = request.user
        return Response({'message': f'Hello {user.username}'})
이 세 가지 예제를 통해 액세스 토큰/리프레시 토큰 발급 · 검증 · 회전 과정을 프레임워크별로 직접 구현

  
---
[🔙 Back to Portfolio Main](../index.md)

---
