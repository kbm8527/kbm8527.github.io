---
layout: default
title: Spring Security
---

## 목차

### 🔗 [Spring Security](/study/authentication-and-security/)

1. Spring Security란?
Spring 애플리케이션에서 보안(Security)을 처리하는 표준 프레임워크

주요 기능:

인증(Authentication) ➔ "누구냐?"

인가(Authorization) ➔ "권한 있냐?"

세션 관리

CSRF 방어

OAuth2, JWT, SSO 통합

특징:

필터 기반 보안 체계 (Servlet FilterChain 사용)

디폴트로 강력한 보안 제공

확장성과 커스터마이징이 뛰어남

2. 기본 구조 이해
2.1 인증(Authentication) 과정
사용자가 ID/PW 입력 → AuthenticationManager가 검증 → Authentication 객체 생성

흐름:

nginx
복사
편집
UsernamePasswordAuthenticationFilter → AuthenticationManager → AuthenticationProvider → UserDetailsService
주요 컴포넌트:

UsernamePasswordAuthenticationFilter : 로그인 요청 가로채기

AuthenticationManager : 인증 관리 총괄

AuthenticationProvider : 실제 인증 로직 담당

UserDetailsService : 사용자 정보 불러오기

UserDetails : 사용자 상세 정보 객체

2.2 인가(Authorization) 과정
인증된 사용자가 특정 자원에 접근할 수 있는지 "권한(Role)"을 체크

흐름:

nginx
복사
편집
FilterSecurityInterceptor → AccessDecisionManager → Voter
주요 컴포넌트:

FilterSecurityInterceptor: 요청 인터셉트, 권한 체크

AccessDecisionManager: 권한 평가 총괄

Voter: 권한 찬성/반대/보류 투표

3. Spring Security 필터 체인
Spring Security는 수십 개의 Filter를 FilterChainProxy로 묶어 관리합니다.

주요 Filter:


필터	역할
SecurityContextPersistenceFilter	세션에 저장된 인증 정보 복원
UsernamePasswordAuthenticationFilter	로그인 처리
BasicAuthenticationFilter	HTTP Basic 인증 처리
CsrfFilter	CSRF 토큰 검사
ExceptionTranslationFilter	예외 처리
FilterSecurityInterceptor	권한(Authorization) 검증
 순서가 매우 중요합니다. 필터 순서 잘못 건들면 보안 구멍 생김.

4. 실습 — 간단한 Spring Security 설정
java
복사
편집
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .csrf().disable() // CSRF 비활성화 (API 서버용)
            .authorizeHttpRequests(authorize -> authorize
                .requestMatchers("/admin/**").hasRole("ADMIN")
                .requestMatchers("/user/**").hasAnyRole("USER", "ADMIN")
                .anyRequest().permitAll()
            )
            .formLogin(Customizer.withDefaults()); // 기본 로그인 폼 사용
        return http.build();
    }
}
핵심:

/admin/** ➔ ADMIN만 접근

/user/** ➔ USER 또는 ADMIN 접근 가능

나머지 ➔ 모두 허용

5. 심화 — 커스텀 인증 구현
1. Custom UserDetailsService

java
복사
편집
@Service
public class CustomUserDetailsService implements UserDetailsService {

    private final UserRepository userRepository;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = userRepository.findByUsername(username)
                                  .orElseThrow(() -> new UsernameNotFoundException("User not found"));
        return new org.springframework.security.core.userdetails.User(
            user.getUsername(),
            user.getPassword(),
            List.of(new SimpleGrantedAuthority(user.getRole()))
        );
    }
}
2. Custom AuthenticationProvider

java
복사
편집
@Component
public class CustomAuthenticationProvider implements AuthenticationProvider {

    private final CustomUserDetailsService userDetailsService;
    private final PasswordEncoder passwordEncoder;

    @Override
    public Authentication authenticate(Authentication authentication) {
        String username = authentication.getName();
        String password = (String) authentication.getCredentials();

        UserDetails userDetails = userDetailsService.loadUserByUsername(username);

        if (!passwordEncoder.matches(password, userDetails.getPassword())) {
            throw new BadCredentialsException("Invalid credentials");
        }

        return new UsernamePasswordAuthenticationToken(userDetails, password, userDetails.getAuthorities());
    }
}
 커스텀 인증을 통해 DB 기반 로그인, LDAP 인증, API 키 인증 등 다양한 확장이 가능

6. 고급 — JWT + OAuth2 통합 보안
6.1 JWT 기반 인증
필터 흐름:

nginx
복사
편집
JwtAuthenticationFilter → UsernamePasswordAuthenticationFilter 전에 실행
JwtAuthenticationFilter 예시:

java
복사
편집
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtProvider jwtProvider;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
            throws ServletException, IOException {
        String token = jwtProvider.resolveToken(request);
        if (token != null && jwtProvider.validateToken(token)) {
            Authentication auth = jwtProvider.getAuthentication(token);
            SecurityContextHolder.getContext().setAuthentication(auth);
        }
        chain.doFilter(request, response);
    }
}
 JWT를 통해 "Stateless"한 인증 구현 가능

6.2 OAuth2 Social Login
Spring Security OAuth2 Client 기본 구성

java
복사
편집
spring:
  security:
    oauth2:
      client:
        registration:
          google:
            client-id: your-google-client-id
            client-secret: your-google-client-secret
            scope: profile, email
커스텀 OAuth2UserService 구현:

java
복사
편집
@Service
public class CustomOAuth2UserService extends DefaultOAuth2UserService {
    @Override
    public OAuth2User loadUser(OAuth2UserRequest request) {
        OAuth2User oAuth2User = super.loadUser(request);
        // 사용자 정보 매핑 및 저장
        return new CustomOAuth2User(oAuth2User.getAttributes());
    }
}
 OAuth2를 통해 카카오, 구글, 네이버 로그인 연동 가능

7. 보안 강화 실전 팁 (항상 적용해야 할 것)

항목	설명
CSRF 방어	Form 기반 서버는 꼭 활성화
HTTPS 강제	spring boot server SSL 설정
Session Fixation 방어	로그인 성공 시 세션 새로 발급
CORS 제한	신뢰할 수 있는 Origin만 허용
로그인 실패 감지	로그인 실패 시 IP 차단 또는 딜레이
패스워드 해시	bcrypt / argon2 필수 사용
🛡 마무리 요약 (정리)

구분	한 줄 요약
인증(Authentication)	로그인해서 "나 누구다" 증명
인가(Authorization)	"내가 이 기능을 써도 되나?" 확인
필터체인	다양한 보안 검사 단계 필터로 구성
커스터마이징	UserDetailsService, AuthenticationProvider 직접 구현 가능
JWT 통합	세션 없는 토큰 기반 인증 구축
OAuth2 통합	소셜 로그인 쉽게 연동 가능

📌 1. 필터 체인 완전 이해
Spring Security는 FilterChainProxy 구조로 동작합니다.
각 필터는 체인처럼 연결되어 요청을 처리하거나 거부합니다.

주요 필터 작동 흐름:

SecurityContextPersistenceFilter → 인증 정보 로딩

UsernamePasswordAuthenticationFilter → 로그인 시도 감지

BasicAuthenticationFilter → 기본 인증 처리

ExceptionTranslationFilter → 인증/인가 실패 예외 처리

FilterSecurityInterceptor → 최종 인가 결정

커스텀 필터 등록 시 위치 지정:

java
복사
편집
http.addFilterBefore(customFilter, UsernamePasswordAuthenticationFilter.class);
📌 2. JWT + Spring Security 완전 통합
🔐 JWT 기반 구조 요약
css
복사
편집
[클라이언트] -- 로그인 요청 → [서버: 인증 후 JWT 발급] → 클라이언트가 매 요청 시 JWT 헤더에 포함
📦 구성요소
JwtTokenProvider: 토큰 생성, 검증

JwtAuthenticationFilter: 요청마다 토큰 파싱 및 인증 정보 저장

SecurityConfig: 필터 체인 구성

UserDetailsService: 사용자 인증 정보 로딩

JwtAuthenticationFilter 예시
java
복사
편집
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtTokenProvider jwtProvider;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
            throws ServletException, IOException {

        String token = jwtProvider.resolveToken(request);

        if (token != null && jwtProvider.validateToken(token)) {
            Authentication auth = jwtProvider.getAuthentication(token);
            SecurityContextHolder.getContext().setAuthentication(auth);
        }

        chain.doFilter(request, response);
    }
}
📌 3. OAuth2 소셜 로그인 심화
 동작 흐름
markdown
복사
편집
1. 클라이언트가 로그인 요청 → 2. OAuth2 인증 서버 (ex. Google)로 이동 → 
3. 인증 후 콜백 → 4. accessToken + 사용자 정보 반환 → 5. 회원 정보 매핑 및 저장
🔧 주요 설정
yaml
복사
편집
spring:
  security:
    oauth2:
      client:
        registration:
          google:
            client-id: ...
            client-secret: ...
            redirect-uri: "{baseUrl}/login/oauth2/code/{registrationId}"
🔍 사용자 정보 커스터마이징
java
복사
편집
@Service
public class CustomOAuth2UserService extends DefaultOAuth2UserService {
    @Override
    public OAuth2User loadUser(OAuth2UserRequest request) throws OAuth2AuthenticationException {
        OAuth2User oAuth2User = super.loadUser(request);
        // 사용자 정보 정규화, DB 저장 등 처리
        return new CustomOAuth2User(oAuth2User.getAttributes());
    }
}
📌 4. Refresh Token 전략 심화

항목	설명
Access Token	만료 빠름 (5~15분)
Refresh Token	긴 유효기간 (2주~1달)
저장 위치	DB, Redis, HttpOnly Cookie 등
갱신 방식	AccessToken 만료 시 RefreshToken으로 재발급
보안 포인트
RefreshToken은 DB 또는 Redis에 저장하고, 블랙리스트 처리 가능해야 함

유효성 검사는 항상 서버 측에서 처리

탈취 대비 → 사용 시마다 IP/UA 체크 권장

📌 5. Role / 권한 관리 전략
@Secured / @PreAuthorize 차이
java
복사
편집
@Secured("ROLE_ADMIN") // 단순 역할 검사

@PreAuthorize("hasRole('ADMIN') and #userId == authentication.name") // SpEL 사용
도메인 객체 보안 (Method Security)
java
복사
편집
@EnableGlobalMethodSecurity(prePostEnabled = true)
사용 예시:

java
복사
편집
@PreAuthorize("hasPermission(#post, 'WRITE')")
public void editPost(Post post) { ... }
📌 6. 고급 설정 — Stateless 인증 아키텍처

항목	설명
세션 상태 없음	서버에 사용자 상태 저장 안함 (JWT 기반)
Redis 사용	RefreshToken 저장 또는 로그아웃 처리
Exception 처리	Global ExceptionHandler 또는 EntryPoint 커스터마이징
토큰 무효화	Redis 블랙리스트, DB 상태관리로 대응
📌 7. 커스텀 EntryPoint, AccessDeniedHandler
java
복사
편집
http
  .exceptionHandling()
    .authenticationEntryPoint(new CustomEntryPoint())
    .accessDeniedHandler(new CustomAccessDeniedHandler());
CustomEntryPoint
java
복사
편집
@Component
public class CustomEntryPoint implements AuthenticationEntryPoint {
    @Override
    public void commence(HttpServletRequest request, HttpServletResponse response,
                         AuthenticationException authException) throws IOException {
        response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "로그인 필요");
    }
}
AccessDeniedHandler
java
복사
편집
@Component
public class CustomAccessDeniedHandler implements AccessDeniedHandler {
    @Override
    public void handle(HttpServletRequest request, HttpServletResponse response,
                       AccessDeniedException accessDeniedException) throws IOException {
        response.sendError(HttpServletResponse.SC_FORBIDDEN, "접근 권한 없음");
    }
}
 실무에 적용할 수 있는 권장 구조 요약
text
복사
편집
1. 클라이언트 → 로그인 → JWT 발급 (access + refresh)
2. accessToken으로 API 호출 → 필터에서 인증
3. accessToken 만료 시 → refreshToken으로 재발급
4. refreshToken 저장: Redis or DB
5. 로그아웃 시 → refreshToken 폐기 (블랙리스트 등록)
6. 관리자 페이지는 RBAC 권한 체크


---
[🔙 Back to Portfolio Main](../index.md)

---


