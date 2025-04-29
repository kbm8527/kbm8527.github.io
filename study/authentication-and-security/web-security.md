---
layout: default
title: Web Security

---

## 목차

### 🔗 [Web Security](/study/authentication-and-security/)

  📍 1. Web Security 기본 개념
Web Security란,
"웹 어플리케이션이 해킹, 데이터 유출, 불법 접근, 악성 공격 등에 노출되지 않도록 보호하는 기술과 정책"을 말합니다.

왜 필요한가?

해커들은 웹 서버, API, 프론트엔드 등을 공격해 민감 정보를 노립니다.

사용자가 안전하게 서비스 이용할 수 있어야 합니다.

📍 2. 웹 보안 위협의 종류 (기초)

공격 기법	설명	대응 방법
XSS (Cross Site Scripting)	사용자 입력값에 스크립트 삽입 공격	입력값 검증, 출력 시 이스케이프 처리
CSRF (Cross Site Request Forgery)	사용자의 인증된 세션을 악용하여 요청 전송	CSRF 토큰 사용
SQL Injection	DB 쿼리 조작을 통한 데이터 탈취	PreparedStatement 사용, ORM 사용
Clickjacking	보이지 않는 프레임 위에 버튼을 올려 클릭 유도	X-Frame-Options 설정
Session Hijacking	세션 ID를 탈취해 사용자 행세	HTTPS 사용, Secure 쿠키 설정
Directory Traversal	파일 경로를 조작해 서버 파일 접근	입력값 검증 및 정규화
📍 3. Web Security 핵심 방어 기술
✋ 1. HTTPS 적용
모든 트래픽을 암호화

통신 중 민감 정보(쿠키, 로그인 정보 등) 보호

설정: SSL 인증서 적용, HTTP → HTTPS 리다이렉트

✋ 2. 인증(Authentication)과 인가(Authorization)
Authentication (인증): "너 누구야?" → 로그인

Authorization (인가): "너 이거 해도 돼?" → 권한 부여

Spring Security, OAuth2, JWT 등을 통해 처리

✋ 3. 입력값 검증(Input Validation)
서버로 들어오는 모든 데이터는 항상 의심해야 한다.

숫자, 문자열, 이메일 등은 패턴 검증해야 한다.

java
복사
편집
@Pattern(regexp = "^[a-zA-Z0-9]{8,20}$")
private String username;
✋ 4. 쿠키와 세션 보안

항목	설명
Secure	HTTPS에서만 쿠키 전송
HttpOnly	JavaScript 접근 불가
SameSite=Strict	다른 사이트 요청 시 쿠키 전송 차단 (CSRF 방어)
✋ 5. CORS (Cross-Origin Resource Sharing)
다른 도메인 간 요청을 허용할지 서버가 통제하는 정책

필요하지 않은 모든 origin 차단하기

Spring에서 CORS 설정 예시:

java
복사
편집
@Bean
public WebMvcConfigurer corsConfigurer() {
    return new WebMvcConfigurer() {
        @Override
        public void addCorsMappings(CorsRegistry registry) {
            registry.addMapping("/api/**")
                    .allowedOrigins("https://yourfrontend.com")
                    .allowedMethods("GET", "POST");
        }
    };
}
📍 4. Web Security 심화 주제
🔥 1. CSRF 완전 이해
CSRF란?

사용자가 사이트에 로그인한 상태에서,

해커가 악성 사이트를 통해 의도치 않은 요청을 보내게 만드는 공격.

방어 방법

CSRF 토큰을 매 요청마다 발급해서 검증

Spring Security에서는 기본으로 제공

java
복사
편집
http.csrf().csrfTokenRepository(CookieCsrfTokenRepository.withHttpOnlyFalse());
🔥 2. XSS 대응 심화
XSS란?

공격자가 스크립트 코드를 삽입해 사용자 브라우저에서 실행시키는 공격

방어 방법

입력값 필터링

출력 시 HTML Escape 처리

프론트엔드에서 dangerouslySetInnerHTML 같은 위험 기능 금지

Spring Thymeleaf에서 자동 Escape 예시:

html
복사
편집
<p th:text="${userInput}"></p> <!-- 자동 HTML Escape -->
🔥 3. 세션 고정(Session Fixation) 공격 대응
세션 고정이란?

공격자가 사전에 발급된 세션 ID를 사용자에게 심어준 뒤, 세션을 탈취하는 공격.

방어 방법

로그인 성공 시 새 세션 ID로 갱신해야 한다.

Spring Security는 기본적으로 세션 고정 방어 설정이 되어 있음:

java
복사
편집
http.sessionManagement().sessionFixation().migrateSession();
🔥 4. HTTP Security Headers

헤더	설명	예시
Content-Security-Policy	스크립트/이미지 로딩 제어	default-src 'self'
X-Content-Type-Options	잘못된 MIME 타입 실행 차단	nosniff
X-Frame-Options	클릭재킹 공격 방어	DENY
Strict-Transport-Security	HTTPS 강제 사용	max-age=31536000; includeSubDomains
Spring Security에서 기본 적용 가능:

java
복사
편집
http.headers()
    .contentSecurityPolicy("default-src 'self'")
    .frameOptions().deny()
    .xssProtection().block(true);
📍 5. 실전: Spring Security Web Security 예제
Spring Security 전체 구성 예시

java
복사
편집
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .csrf()
                .and()
            .authorizeHttpRequests()
                .requestMatchers("/api/admin/**").hasRole("ADMIN")
                .anyRequest().authenticated()
                .and()
            .formLogin()
                .and()
            .sessionManagement()
                .sessionFixation().migrateSession()
                .and()
            .headers()
                .frameOptions().deny()
                .contentSecurityPolicy("default-src 'self'");

        return http.build();
    }
}
 요약 핵심

핵심 항목	필수 액션
HTTPS 사용	무조건 적용
XSS 방어	출력시 Escape
CSRF 방어	CSRF Token 적용
인증/인가 분리	Spring Security 체계적 사용
세션 보호	로그인 시 세션 재발급
쿠키 보안 설정	Secure, HttpOnly, SameSite 적용
HTTP 헤더 설정	보안 헤더 적극 적용

✅ Web Security 심화 주제 완전 정복
1. OAuth2 + Web Security 통합
📌 목표
소셜 로그인(OAuth2 Provider)을 통한 인증

추가로 자체 JWT 토큰 발급하여 세션리스(stateless)로 전환

기본 흐름
plaintext
복사
편집
사용자 → /oauth2/authorization/google → Google 로그인 → 서버로 인증 결과 → 서버에서 JWT 발급 → 클라이언트에 전달
기본 설정 (Spring Boot 3.x 기준)
application.yml

yaml
복사
편집
spring:
  security:
    oauth2:
      client:
        registration:
          google:
            client-id: {구글 클라이언트 ID}
            client-secret: {구글 클라이언트 시크릿}
            scope: profile, email
        provider:
          google:
            authorization-uri: https://accounts.google.com/o/oauth2/v2/auth
            token-uri: https://oauth2.googleapis.com/token
            user-info-uri: https://openidconnect.googleapis.com/v1/userinfo
            user-name-attribute: sub
SecurityConfig.java

java
복사
편집
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .csrf().disable()
            .oauth2Login()
                .userInfoEndpoint()
                    .userService(customOAuth2UserService)
                .and()
            .successHandler(jwtAuthenticationSuccessHandler); // JWT 발급

        return http.build();
    }
}
CustomOAuth2UserService.java

java
복사
편집
@Service
public class CustomOAuth2UserService extends DefaultOAuth2UserService {
    @Override
    public OAuth2User loadUser(OAuth2UserRequest request) {
        OAuth2User oAuth2User = super.loadUser(request);
        // 필요 시 DB에 유저 정보 저장
        return oAuth2User;
    }
}
JWT 발급 SuccessHandler

java
복사
편집
@Component
public class JwtAuthenticationSuccessHandler extends SimpleUrlAuthenticationSuccessHandler {

    private final JwtTokenProvider jwtTokenProvider;

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
                                         Authentication authentication) throws IOException {

        String token = jwtTokenProvider.generateToken(authentication);
        response.addHeader("Authorization", "Bearer " + token);
        response.getWriter().write("Login Success, JWT Issued");
    }
}
 요약:
OAuth2 로그인 후 JWT를 추가 발급하여, 세션 없이 관리하는 구조가 실무 Best Practice입니다.

2. JWT 기반 인증 + CORS 보안 심화
📌 목표
JWT 인증 시스템에 CORS 보안 규칙까지 엄격하게 통합

"허용된 Origin"만 API 접근 허용

SecurityConfig.java (CORS + JWT Filter 적용)

java
복사
편집
@Bean
public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
    http
        .csrf().disable()
        .cors()
            .configurationSource(corsConfigurationSource())
            .and()
        .sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS)
            .and()
        .authorizeHttpRequests()
            .requestMatchers("/api/public/**").permitAll()
            .anyRequest().authenticated()
            .and()
        .addFilterBefore(jwtAuthenticationFilter(), UsernamePasswordAuthenticationFilter.class);

    return http.build();
}

@Bean
public CorsConfigurationSource corsConfigurationSource() {
    CorsConfiguration configuration = new CorsConfiguration();
    configuration.setAllowedOrigins(List.of("https://yourfrontend.com"));
    configuration.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE"));
    configuration.setAllowCredentials(true);
    configuration.setAllowedHeaders(List.of("Authorization", "Content-Type"));

    UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
    source.registerCorsConfiguration("/**", configuration);

    return source;
}
 요약:
CORS와 JWT를 함께 관리하는 것이 API 보안의 기본입니다.

3. Spring Security와 API Gateway 통합 보안
📌 목표
API Gateway가 인증/인가를 담당하고,

내부 마이크로서비스는 Trust된 요청만 받도록 한다.

구성 예시

plaintext
복사
편집
[Client] → [API Gateway(Spring Cloud Gateway)] → [Internal Service]
Gateway 필터에서 JWT 검증

java
복사
편집
@Component
public class JwtAuthenticationFilter implements GlobalFilter {

    private final JwtTokenProvider jwtProvider;

    @Override
    public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
        String token = resolveToken(exchange.getRequest());

        if (token != null && jwtProvider.validateToken(token)) {
            Authentication auth = jwtProvider.getAuthentication(token);
            SecurityContextHolder.getContext().setAuthentication(auth);
        }

        return chain.filter(exchange);
    }

    private String resolveToken(ServerHttpRequest request) {
        List<String> authHeaders = request.getHeaders().getOrEmpty("Authorization");
        if (!authHeaders.isEmpty()) {
            return authHeaders.get(0).replace("Bearer ", "");
        }
        return null;
    }
}
 요약:
Gateway에서 토큰을 인증하면, 뒤의 모든 서비스는 "인증 신뢰"만 하면 됩니다.
→ 성능 개선 + 구조 명확화

4. Multi-Factor Authentication (MFA, 2FA)
📌 목표
2단계 인증 (비밀번호 + 추가 인증코드) 적용

실제 동작 흐름

plaintext
복사
편집
1. 사용자가 ID/PW 로그인 → 2. 추가 인증코드 발송 (Email, SMS, App)
3. 인증코드 입력 → 4. 최종 로그인 완료
MFA 기본 로직 예시

java
복사
편집
@PostMapping("/login")
public ResponseEntity<?> login(@RequestBody LoginRequest loginRequest) {
    boolean authenticated = authenticationService.authenticate(loginRequest);

    if (authenticated) {
        mfaService.sendVerificationCode(loginRequest.getUserId());
        return ResponseEntity.ok("2FA code sent");
    } else {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
    }
}

@PostMapping("/verify")
public ResponseEntity<?> verifyMfa(@RequestBody MfaVerificationRequest request) {
    boolean verified = mfaService.verifyCode(request.getUserId(), request.getCode());

    if (verified) {
        String token = jwtProvider.generateToken(request.getUserId());
        return ResponseEntity.ok(token);
    } else {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
    }
}
 요약:
**MFA(2FA)**는 해커가 비밀번호만 탈취해도 로그인할 수 없게 막는 최고의 추가 방어선입니다.
(특히 관리자(Admin) 계정은 무조건 MFA 적용!)

✍️ 최종 요약 체크리스트

심화 주제	핵심 요약
OAuth2 + JWT 통합	소셜 로그인 후 JWT 발급해 세션리스
JWT + CORS 보안	엄격한 Origin 제한, JWT 필터 적용
Gateway 통합 보안	API Gateway에서 인증 일괄 처리
Multi-Factor Authentication (MFA)	추가 인증코드로 보안 레벨 강화

✅ MFA (Multi-Factor Authentication) + Redis 연동 심화
📌 왜 Redis를 쓰는가?
**2차 인증 코드(Verification Code)**는 짧은 시간만 살아야 함 (예: 3분)

DB에 저장하면 느리고 부담 큼 → 메모리 기반 Redis로 임시 저장 최적

Redis TTL(Time to Live) 기능을 이용해 자동 만료 가능

🔹 Redis에 MFA 인증 코드 저장 흐름
scss
복사
편집
1. 로그인 성공
 → 2. Redis에 (userId, 인증코드) 저장 (TTL 3분)
 → 3. 사용자에게 인증코드 전송 (SMS, Email 등)
 → 4. 사용자가 인증코드 입력
 → 5. Redis에서 인증코드 조회 및 검증
 → 6. 통과하면 최종 JWT 발급
🔹 코드 예시 (Spring Boot)
1. Redis 설정
java
복사
편집
@Configuration
public class RedisConfig {

    @Bean
    public RedisTemplate<String, String> redisTemplate(RedisConnectionFactory factory) {
        RedisTemplate<String, String> template = new RedisTemplate<>();
        template.setConnectionFactory(factory);
        return template;
    }
}
2. MFAService (코드 저장, 검증)
java
복사
편집
@Service
@RequiredArgsConstructor
public class MfaService {

    private final RedisTemplate<String, String> redisTemplate;
    private final Random random = new Random();

    public String generateAndSaveCode(String userId) {
        String code = String.format("%06d", random.nextInt(999999));
        redisTemplate.opsForValue().set("MFA:" + userId, code, Duration.ofMinutes(3));
        return code;
    }

    public boolean verifyCode(String userId, String inputCode) {
        String savedCode = redisTemplate.opsForValue().get("MFA:" + userId);
        return savedCode != null && savedCode.equals(inputCode);
    }
}
3. Controller 예시
java
복사
편집
@PostMapping("/login")
public ResponseEntity<?> login(@RequestBody LoginRequest request) {
    authenticationService.authenticate(request);

    String code = mfaService.generateAndSaveCode(request.getUsername());
    smsService.sendVerificationCode(request.getPhoneNumber(), code);

    return ResponseEntity.ok("2FA code sent");
}

@PostMapping("/verify-mfa")
public ResponseEntity<?> verifyMfa(@RequestBody MfaVerificationRequest request) {
    if (mfaService.verifyCode(request.getUsername(), request.getCode())) {
        String jwt = jwtProvider.generateToken(request.getUsername());
        return ResponseEntity.ok(jwt);
    } else {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid MFA code");
    }
}
 요약:
MFA 코드는 Redis에 저장 → TTL로 자동 삭제 → 빠르고 안전한 임시 저장

 OAuth2 로그인 이후 Role 기반 권한 처리 심화
📌 기본 흐름
사용자가 소셜 로그인 성공

서버가 OAuth2 사용자 정보를 읽고

DB에서 Role(권한) 조회 또는 등록

Role을 Security Context에 저장

이후 요청마다 Role 기반 인가 처리

🔹 OAuth2User에 Role 추가 방법
1. CustomOAuth2UserService 수정
java
복사
편집
@Service
@RequiredArgsConstructor
public class CustomOAuth2UserService extends DefaultOAuth2UserService {

    private final UserRepository userRepository;

    @Override
    public OAuth2User loadUser(OAuth2UserRequest request) {
        OAuth2User oAuth2User = super.loadUser(request);

        String email = oAuth2User.getAttribute("email");
        User user = userRepository.findByEmail(email)
                      .orElseGet(() -> registerNewUser(email));

        Map<String, Object> attributes = new HashMap<>(oAuth2User.getAttributes());
        attributes.put("role", user.getRole());

        return new DefaultOAuth2User(
            List.of(new SimpleGrantedAuthority("ROLE_" + user.getRole())),
            attributes,
            "email"
        );
    }

    private User registerNewUser(String email) {
        User user = User.builder()
                        .email(email)
                        .role("USER") // 기본 권한
                        .build();
        return userRepository.save(user);
    }
}
2. SecurityConfig - Role 별 접근 제한
java
복사
편집
@Bean
public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
    http
        .authorizeHttpRequests()
            .requestMatchers("/admin/**").hasRole("ADMIN")
            .requestMatchers("/user/**").hasAnyRole("USER", "ADMIN")
            .anyRequest().permitAll()
            .and()
        .oauth2Login()
            .userInfoEndpoint()
                .userService(customOAuth2UserService);

    return http.build();
}
 요약:
OAuth2 인증 → 사용자 DB 조회 → Role 부여 → Role 기반 인가(Authorization) 처리

✍️ 최종 요약 비교

항목	핵심 요약
MFA + Redis	인증코드를 Redis에 저장해 빠른 처리와 자동 만료 관리
OAuth2 이후 Role 관리	소셜 로그인 후 사용자 Role 저장하고, Role 기반 API 접근 제어

✅ Redis를 활용한 Refresh Token 관리 심화
1. 📌 왜 Refresh Token을 Redis로 관리할까?

기존 방식 (DB 저장)	Redis 저장 방식
느리다 (DB Connection 필요)	빠르다 (In-Memory 처리)
부하 크다 (많은 읽기/쓰기)	부하 적다 (RAM 기반)
세션처럼 빠른 만료 관리 어려움	TTL(Time to Live)로 자동 만료
✅ 결론:
→ Refresh Token은 "가벼운 임시 데이터"이므로 Redis가 가장 이상적입니다.

2. 📌 Refresh Token 관리 흐름
plaintext
복사
편집
1. 로그인 성공 시:
   - Access Token (5~30분) + Refresh Token (7~14일) 발급
   - Refresh Token을 Redis에 저장 (userId -> token)
2. Access Token 만료 시:
   - Refresh Token으로 재발급 요청
   - Redis에서 Refresh Token 유효성 검증
   - 성공 시 Access Token 새로 발급
3. 로그아웃 시:
   - Redis에서 Refresh Token 삭제
3. 📌 Redis에 Refresh Token 저장 구조
Key: RT:{userId}

Value: Refresh Token 문자열

TTL: Refresh Token 유효기간만큼 (예: 7일)

예시


Redis Key	Redis Value	TTL
RT:123e4567-e89b-12d3-a456-426614174000	eyJhbGciOiJIUzI1NiIsIn...	7일
4. 🔥 실전 코드 (Spring Boot 예시)
1) RedisTemplate 설정
java
복사
편집
@Configuration
public class RedisConfig {

    @Bean
    public RedisTemplate<String, String> redisTemplate(RedisConnectionFactory connectionFactory) {
        RedisTemplate<String, String> template = new RedisTemplate<>();
        template.setConnectionFactory(connectionFactory);
        return template;
    }
}
2) RefreshTokenService 구현
java
복사
편집
@Service
@RequiredArgsConstructor
public class RefreshTokenService {

    private final RedisTemplate<String, String> redisTemplate;

    private static final String REFRESH_TOKEN_PREFIX = "RT:";

    public void saveRefreshToken(UUID userId, String refreshToken, long expirationSeconds) {
        redisTemplate.opsForValue().set(REFRESH_TOKEN_PREFIX + userId.toString(), refreshToken, Duration.ofSeconds(expirationSeconds));
    }

    public String getRefreshToken(UUID userId) {
        return redisTemplate.opsForValue().get(REFRESH_TOKEN_PREFIX + userId.toString());
    }

    public void deleteRefreshToken(UUID userId) {
        redisTemplate.delete(REFRESH_TOKEN_PREFIX + userId.toString());
    }
}
3) 로그인 시 RefreshToken 저장
java
복사
편집
@PostMapping("/login")
public ResponseEntity<?> login(@RequestBody LoginRequest request) {
    // 인증 처리...

    String accessToken = jwtProvider.generateAccessToken(user);
    String refreshToken = jwtProvider.generateRefreshToken(user);

    refreshTokenService.saveRefreshToken(user.getId(), refreshToken, 7 * 24 * 60 * 60); // 7일

    return ResponseEntity.ok(new TokenResponse(accessToken, refreshToken));
}
4) 토큰 재발급 API
java
복사
편집
@PostMapping("/reissue")
public ResponseEntity<?> reissue(@RequestBody TokenRequest tokenRequest) {
    UUID userId = jwtProvider.extractUserId(tokenRequest.getRefreshToken());

    String savedRefreshToken = refreshTokenService.getRefreshToken(userId);

    if (savedRefreshToken == null || !savedRefreshToken.equals(tokenRequest.getRefreshToken())) {
        throw new BaseException(INVALID_REFRESH_TOKEN);
    }

    String newAccessToken = jwtProvider.generateAccessToken(userId);

    return ResponseEntity.ok(new TokenResponse(newAccessToken, tokenRequest.getRefreshToken()));
}
5) 로그아웃 API (Refresh Token 삭제)
java
복사
편집
@PostMapping("/logout")
public ResponseEntity<?> logout(@AuthenticationPrincipal UserPrincipal user) {
    refreshTokenService.deleteRefreshToken(user.getUserId());
    return ResponseEntity.ok("Logged out successfully.");
}
5. 📌 보안 심화 포인트

항목	보안 고려사항
Redis TTL 관리	Refresh Token 수명과 TTL 일치
탈취 대응	로그인 시마다 Refresh Token 갱신 (Rotate 방식) 고려
Access Token 재발급 시	Refresh Token도 새로 발급하는 구조 추천
Refresh Token 탈취 탐지	IP, User-Agent 등 추가 검증 추천
로그아웃 시	Redis Refresh Token 반드시 삭제
6. ✨ 추가 심화: Refresh Token Rotate 전략
Rotate 전략:
매번 Access Token 재발급할 때 Refresh Token도 새로 발급하고, Redis를 업데이트하는 방법입니다.

장점:

탈취된 이전 Refresh Token은 무효화

세션처럼 최신 상태 유지 가능

구조 흐름:

plaintext
복사
편집
1. 사용자가 Refresh Token으로 Access Token 재발급 요청
2. 서버가 새로운 Refresh Token 발급
3. Redis의 기존 Refresh Token 삭제 → 새로 저장
🧠 최종 요약

주제	요약
Redis로 Refresh Token 관리	가볍고 빠른 관리, TTL 자동 만료
실전 코드 흐름	저장 → 검증 → 삭제 → Rotate 관리
실무 보안 포인트	TTL, Rotate, 탈취 대응, IP/User-Agent 검증


 OAuth2 로그인 이후 추가 정보 입력 처리 심화
1. 📌 왜 추가 정보 입력이 필요한가?
소셜 로그인(OAuth2 로그인)만으로는 사용자 정보가 불완전합니다.


소셜에서 제공	우리가 추가로 필요한 것
이메일, 이름, 프로필 사진	닉네임, 성별, 생년월일, 약관 동의, 마케팅 동의 등
 따라서 최초 로그인 이후 추가 입력(회원가입 확장)을 필수로 처리합니다.

2. 📌 전체 흐름 구조
plaintext
복사
편집
1. 소셜 로그인 성공 (OAuth2 인증 완료)
 ↓
2. 우리 서버가 소셜 사용자 정보 수신
 ↓
3. 내부 DB에 회원 존재 여부 확인
   - 존재 O → 로그인 성공 (JWT 발급)
   - 존재 X → "회원가입 추가 정보 입력" 상태로 분기
 ↓
4. 추가 정보 입력 화면 노출
 ↓
5. 추가 정보 입력 완료 → DB 저장 → 최종 JWT 발급
3. 📌 DB 구조 예시 (확장)

필드명	설명
id	UUID 또는 PK
email	소셜 제공 이메일
provider	kakao, google 등
providerId	소셜 고유 ID
nickname	사용자 입력 닉네임
gender	사용자 입력 성별
birthday	사용자 입력 생년월일
agreeTerms	약관 동의 여부
agreeMarketing	마케팅 수신 동의 여부
→ 소셜 로그인 정보 + 추가 입력 정보를 함께 관리해야 합니다.

4. 🔥 실전 코드 (Spring Boot)
1) OAuth2UserService 수정: 회원 존재 여부 체크
java
복사
편집
@Service
@RequiredArgsConstructor
public class CustomOAuth2UserService extends DefaultOAuth2UserService {

    private final UserRepository userRepository;
    private final OAuth2AuthenticationSuccessHandler successHandler;

    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest) {
        OAuth2User oAuth2User = super.loadUser(userRequest);
        String provider = userRequest.getClientRegistration().getRegistrationId(); // kakao, google
        String providerId = oAuth2User.getAttribute("sub"); // Google 예시
        
        Optional<User> userOptional = userRepository.findByProviderAndProviderId(provider, providerId);
        
        if (userOptional.isEmpty()) {
            throw new OAuth2AuthenticationProcessingException("NEED_ADDITIONAL_INFO", provider, providerId);
        }
        
        return new DefaultOAuth2User(
            List.of(new SimpleGrantedAuthority("ROLE_USER")),
            oAuth2User.getAttributes(),
            "email"
        );
    }
}
2) 예외 처리 - 추가 정보 입력 유도
java
복사
편집
public class OAuth2AuthenticationProcessingException extends AuthenticationException {
    private final String provider;
    private final String providerId;

    public OAuth2AuthenticationProcessingException(String msg, String provider, String providerId) {
        super(msg);
        this.provider = provider;
        this.providerId = providerId;
    }
}
3) 추가 정보 입력 API
java
복사
편집
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/join")
public class JoinController {

    private final UserService userService;

    @PostMapping("/additional-info")
    public ResponseEntity<?> completeSignup(@RequestBody AdditionalInfoRequestDto request) {
        userService.completeSignup(request);
        return ResponseEntity.ok("회원가입 완료");
    }
}
AdditionalInfoRequestDto

java
복사
편집
@Getter
public class AdditionalInfoRequestDto {
    private String provider;
    private String providerId;
    private String nickname;
    private String gender;
    private String birthday;
    private boolean agreeTerms;
    private boolean agreeMarketing;
}
4) UserService - 회원 저장
java
복사
편집
@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;

    @Transactional
    public void completeSignup(AdditionalInfoRequestDto request) {
        User user = User.builder()
                .provider(request.getProvider())
                .providerId(request.getProviderId())
                .nickname(request.getNickname())
                .gender(request.getGender())
                .birthday(request.getBirthday())
                .agreeTerms(request.isAgreeTerms())
                .agreeMarketing(request.isAgreeMarketing())
                .build();
        userRepository.save(user);
    }
}
5. 📌 추가 심화: 보안 + UX 고려사항

항목	주의사항
이메일 중복 체크	소셜 제공 이메일이 기존 회원 이메일과 겹치면 예외 처리
provider + providerId로 식별	email이 아닌 providerId로 소셜 사용자 고유 식별
추가 입력 완료 여부 플래그	User 테이블에 "signupCompleted(boolean)" 추가 관리 가능
동시 요청 방어	추가 입력 중 중복 요청 방어 필요
리프레시 토큰 발급 시점	추가 정보 입력 완료 후 최초 발급 처리
✨ 최종 요약

주제	요약
소셜 로그인 이후 추가 입력	이메일만으로 부족 → 닉네임/생년월일/약관 추가 수집
DB 설계	provider, providerId, nickname, gender, birthday 필드 확장
코드 흐름	소셜 로그인 → 미가입이면 추가 입력 → 가입 완료 후 JWT 발급
보안 고려사항	이메일 중복, providerId 관리, 완료 여부 체크


---
[🔙 Back to Portfolio Main](../index.md)

---


