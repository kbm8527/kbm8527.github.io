---
layout: default
title: Http & Web
---

## 목차

### 🔗 [HTTP & Web Structure](/study/basic-cs-and-programming/)

1. HTTP란 무엇인가?
 기본 개념
HTTP (HyperText Transfer Protocol)
: 인터넷에서 클라이언트(브라우저)와 서버 간 데이터를 주고받기 위한 약속(프로토콜)

클라이언트 ➔ 요청(Request)
서버 ➔ 응답(Response)

 특징
비연결성 (Connectionless): 요청-응답 후 연결 끊음

무상태성 (Stateless): 이전 요청 상태를 기억하지 않음

텍스트 기반 프로토콜

2. HTTP 동작 흐름 (Request - Response Cycle)
scss
복사
편집
[사용자]
    ↓
[브라우저] (Request 생성)
    ↓
[인터넷 네트워크]
    ↓
[서버] (Request 수신 → 처리 → Response 생성)
    ↓
[브라우저] (Response 수신 → 화면 렌더링)
 요청 → 처리 → 응답까지 1회성 트랜잭션

3. 기본 HTTP 메시지 구조
 Request

항목	예시
Request Line	GET /index.html HTTP/1.1
Headers	Host, User-Agent, Accept, Authorization 등
Body (선택)	POST 데이터, JSON 등
 Response

항목	예시
Status Line	HTTP/1.1 200 OK
Headers	Content-Type, Set-Cookie, Cache-Control 등
Body (선택)	HTML, JSON, 파일 데이터 등
4. HTTP 주요 메서드

메서드	설명
GET	데이터 조회
POST	리소스 생성
PUT	리소스 전체 수정
PATCH	리소스 일부 수정
DELETE	리소스 삭제
 CRUD 작업(생성-조회-수정-삭제)을 HTTP 메서드로 표현합니다.

5. HTTP 상태 코드(Status Code)

상태 코드	의미	설명
200 OK	성공	요청이 성공적으로 처리됨
201 Created	생성 성공	POST 결과로 리소스 생성됨
400 Bad Request	잘못된 요청	클라이언트 오류
401 Unauthorized	인증 필요	로그인 필요
403 Forbidden	금지	권한 없음
404 Not Found	없음	리소스 존재하지 않음
500 Internal Server Error	서버 오류	서버 내부 문제 발생
📚 심화 1: HTTP의 발전 과정
 HTTP/1.0 → HTTP/1.1
HTTP/1.0: 요청-응답마다 새 연결 생성

HTTP/1.1: Connection: keep-alive로 연결 재사용 가능 (성능 개선)

 HTTP/2
멀티플렉싱(Multiplexing) 지원: 한 커넥션에서 여러 요청 동시 처리

헤더 압축(Header Compression): 불필요한 데이터 줄임

서버 푸시(Server Push): 서버가 클라이언트 요청 전에 미리 데이터 전송 가능

 HTTP/3
TCP 대신 QUIC 프로토콜 기반

지연(Latency) 극복 (초기 핸드셰이크 최소화)

패킷 손실 시 성능 하락 최소화

📚 심화 2: Web 구조 (Web Architecture)
 클라이언트-서버 모델 (기본 구조)
css
복사
편집
[Client (Browser)] ↔ [Server (Backend)]
클라이언트: HTML 렌더링, 사용자 인터페이스

서버: 비즈니스 로직 처리, 데이터베이스 연동

 3-Tier 아키텍처 (3계층 구조)
scss
복사
편집
[Presentation Layer] (Frontend)
    ↕
[Application Layer] (Backend / API 서버)
    ↕
[Data Layer] (DB 서버)
 유지보수성과 확장성 향상을 위해 3단계로 분리

 웹 통신 기술

기술	설명
HTTP/HTTPS	기본 통신 프로토콜
WebSocket	양방향 실시간 통신 (ex: 채팅)
SSE (Server-Sent Events)	서버 → 클라이언트 단방향 스트리밍
gRPC	고성능 RPC(Remote Procedure Call) 통신
📚 심화 3: HTTPS (HTTP Secure)
 HTTPS란?
HTTP + SSL/TLS 암호화

데이터 송수신을 암호화해서 도청, 변조 방지

동작 과정
클라이언트가 서버에 연결 시도

SSL/TLS 핸드셰이크

암호화된 데이터 통신 시작

 SSL/TLS 동작 흐름

단계	설명
1	클라이언트 Hello (지원하는 암호화 방식 전달)
2	서버 Hello + 인증서(공개키) 전달
3	클라이언트가 대칭키 생성 후 서버에 전달
4	이후 통신은 대칭키로 암호화
 공개키-개인키 + 대칭키 혼합 방식으로 성능과 보안을 동시에 확보

📚 심화 4: HTTP 최적화 전략
 성능 최적화 기술

기술	설명
Keep-Alive 연결	커넥션 재사용
Gzip 압축	응답 데이터 크기 감소
CDN(Content Delivery Network)	지리적 거리에 따른 최적 서버 응답
Caching (Etag, Cache-Control)	변경 없는 리소스 재사용
Lazy Loading	필요한 순간에만 데이터 로딩
 웹 보안 강화

위험	방어 방법
중간자 공격(MITM)	HTTPS 사용
쿠키 탈취(CSRF/XSS)	SameSite 속성, Content-Security-Policy
세션 하이재킹	세션 토큰 안전 관리, HttpOnly 설정
✨ 여기까지 요약
 HTTP 기본 개념부터 상태코드, 메서드 흐름 정리
 HTTP/1.1 ➔ HTTP/2 ➔ HTTP/3 발전
 HTTPS 보안 흐름과 SSL/TLS 이해
 Web 구조 3-Tier 아키텍처 심화
 최적화 & 보안 실전 전략 학습

1. HTTP Header 심화 분석
📌 요청(Request) 헤더 주요 항목

Header	의미	예시
Host	요청하는 서버의 도메인	Host: www.example.com
User-Agent	클라이언트 정보 (브라우저/OS)	User-Agent: Mozilla/5.0
Accept	클라이언트가 처리할 수 있는 미디어 타입	Accept: text/html, application/json
Authorization	인증 정보 (Token, Basic)	Authorization: Bearer <JWT>
Content-Type	요청 본문 데이터 타입	Content-Type: application/json
📌 응답(Response) 헤더 주요 항목

Header	의미	예시
Content-Type	응답 데이터 타입	Content-Type: application/json
Set-Cookie	쿠키 설정	Set-Cookie: SESSIONID=abcd; HttpOnly
Cache-Control	캐시 설정	Cache-Control: no-cache
ETag	리소스 버전 식별자	ETag: "xyz123"
Location	리다이렉트 URL	Location: /newpage
 2. HTTP Caching 심화
📌 캐싱 전략 종류

전략	설명	특징
Cache-Control	강력한 캐시 제어	max-age, no-store, private 등
ETag & If-None-Match	리소스 버전 비교	변경 없으면 304 Not Modified 반환
Last-Modified & If-Modified-Since	마지막 수정 시간 비교	
Expires	절대 만료일 설정 (구식 방법)	현대는 Cache-Control 선호
📌 Cache-Control 주요 설정

디렉티브	설명
no-cache	매 요청마다 서버 확인 필요
no-store	저장 금지 (민감정보)
max-age=N	N초 동안 캐시 허용
public	모든 캐시 서버에 저장 허용
private	개인 캐시에만 저장 (ex: 브라우저)
 3. HTTP/2 고급 기능
📌 Multiplexing
하나의 TCP 커넥션으로 여러 요청과 응답을 동시에 주고받는다.

HTTP/1.1에서는 요청-응답 순서가 꼬이면 HOL Blocking 발생했음.

HTTP/2는 스트림 ID로 요청-응답을 구분 ➔ 병렬 처리

📌 Server Push
서버가 클라이언트 요청 없이 필요한 리소스를 미리 전송한다.

http
복사
편집
:authority: example.com
:path: /index.html
:method: GET
:scheme: https

(Server Push)
=> style.css, script.js 파일 같이 전송
 리소스 로딩 속도 향상!

 4. HTTPS 인증서 심화
📌 SSL/TLS 인증서 종류

종류	특징	사용 예시
DV (Domain Validation)	도메인 소유자만 인증	개인/개발용 사이트
OV (Organization Validation)	기업 실체까지 인증	기업 웹사이트
EV (Extended Validation)	심층 검증 (주소창에 회사명 표시)	은행/결제 시스템
📌 무료 인증서 발급 (Let's Encrypt)
Let's Encrypt는 무료 SSL 인증서를 제공

자동 갱신 스크립트도 지원 (Certbot)

bash
복사
편집
sudo apt install certbot
sudo certbot --nginx
🔒 HTTPS는 기본 필수입니다!

📚 추가 심화 5: 실전 최적화 전략
📌 Lazy Loading (지연 로딩)
스크롤할 때마다 필요한 이미지나 데이터를 그때그때 로딩하는 기법

html
복사
편집
<img src="thumbnail.jpg" loading="lazy">
 페이지 로딩 속도 대폭 개선

📌 Content Delivery Network (CDN)
전 세계에 퍼져 있는 서버를 통해 사용자가 가장 가까운 서버로부터 리소스 다운로드

대표적인 CDN:

AWS CloudFront

Cloudflare

Akamai

📌 Brotli 압축
Gzip보다 더 좋은 압축률 제공

HTTP Header에 Accept-Encoding: br 지원하면 사용 가능

서버 설정 예시(Nginx):

nginx
복사
편집
brotli on;
brotli_types text/plain text/css application/json application/javascript text/xml application/xml applica

 6. WebSocket – 실시간 양방향 통신 프로토콜
🔍 WebSocket이란?
HTTP는 요청-응답 기반이라 실시간성이 떨어짐 → WebSocket은 서버와 클라이언트 간 지속적인 연결을 유지하여 양방향 통신 가능.

초기 연결은 HTTP → 이후 Upgrade 헤더로 WebSocket으로 전환됨

이후엔 TCP 위에서 지속적으로 데이터 프레임을 주고받음

📌 구조 및 특징

항목	내용
프로토콜	ws:// 또는 wss://
포트	기본 80, TLS는 443
연결 방식	Handshake 후 지속 연결
주요 용도	채팅, 실시간 알림, 주식/환율 시세, 게임 등
📘 간단한 예시
JavaScript 클라이언트
javascript
복사
편집
const socket = new WebSocket('ws://localhost:8080/ws');

socket.onopen = () => socket.send('Hello!');
socket.onmessage = (event) => console.log(event.data);
Spring 서버
java
복사
편집
@Configuration
@EnableWebSocket
public class WebSocketConfig implements WebSocketConfigurer {
    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        registry.addHandler(new MyHandler(), "/ws").setAllowedOrigins("*");
    }
}
 7. HTTP/3 + QUIC – 미래형 프로토콜
🔍 QUIC이란?
QUIC = UDP 기반의 새로운 전송 계층 프로토콜
Google에서 개발하여 HTTP/3 표준의 기반이 되었음

📌 HTTP/3 vs HTTP/2

항목	HTTP/2	HTTP/3
전송 프로토콜	TCP	UDP
연결 설정	느림 (3-way handshake)	빠름 (0-RTT 가능)
헤더 압축	HPACK	QPACK
HOL Blocking	있음 (TCP 기반)	없음 (스트림 독립)
성능	개선됨	더 빠름, 모바일 최적화
🌐 실무 적용
Cloudflare, Google, Amazon CloudFront 등에서 HTTP/3 지원 시작

사용자는 브라우저에서 자동으로 지원 (Chrome, Firefox, Edge 등)

📘 HTTP/3 통신 흐름
plaintext
복사
편집
1. 클라이언트가 UDP 기반 QUIC 연결 시도
2. 0-RTT 핸드셰이크 → 서버 확인 없이 빠른 연결
3. QPACK으로 헤더 압축
4. 스트림 별로 데이터 독립 송수신
 실시간 + 고속 + 저지연 환경에 적합 (모바일 환경 극대화)

 8. SSE (Server-Sent Events) vs WebSocket

항목	SSE	WebSocket
프로토콜	HTTP	전용 프로토콜 (ws/wss)
방향성	단방향 (서버 ➞ 클라이언트)	양방향
브라우저 지원	대부분 지원	대부분 지원
설정 난이도	간단	복잡
실시간	가능 (event stream)	강력
SSE는?
HTML5 표준으로 정의된 서버에서 클라이언트로 실시간 데이터 push 방식

javascript
복사
편집
const source = new EventSource('/sse-endpoint');
source.onmessage = function(event) {
  console.log('New event:', event.data);
};
 9. 정리 및 실전 적용 기준

실시간 처리 기술	적용 기준
WebSocket	채팅, 실시간 게임, 알림
SSE	뉴스, 실시간 공지 등 단방향
HTTP/3 + QUIC	고성능 웹사이트, 모바일 최적화
Long Polling	SSE, WebSocket이 안 될 경우 대체 방식

실시간 통신 아키텍처 – WebSocket + Redis Pub/Sub
📌 왜 Redis Pub/Sub인가?
WebSocket은 기본적으로 서버 한 대 기준에서만 실시간 통신 가능

그러나 실무에서는 서버가 여러 대(다중 인스턴스) → 사용자 간 메시지 공유 필요

따라서 WebSocket 서버 간 메시지 브로드캐스트를 위해 Redis의 Pub/Sub 기능 사용

📘 구조 예시
plaintext
복사
편집
[User A] — WS —> [Spring 서버 A]
                            │
        Redis Pub/Sub <────┼────> [Spring 서버 B] <— WS — [User B]
                            │
                            └────> [Spring 서버 C]
Spring 서버 A에서 메시지 전송 시 → Redis 채널로 publish

다른 서버(B, C)는 Redis 채널을 subscribe → 사용자에게 메시지 push

🧩 Spring Boot + Redis WebSocket 코드 흐름
1. RedisSubscriber 구성
java
복사
편집
@Component
@RequiredArgsConstructor
public class RedisSubscriber implements MessageListener {
    private final SimpMessagingTemplate messagingTemplate;

    @Override
    public void onMessage(Message message, byte[] pattern) {
        String payload = new String(message.getBody());
        ChatMessage chatMessage = objectMapper.readValue(payload, ChatMessage.class);
        messagingTemplate.convertAndSend("/topic/chat/" + chatMessage.getRoomId(), chatMessage);
    }
}
2. WebSocket 메시지 송신 → Redis Publish
java
복사
편집
@Service
@RequiredArgsConstructor
public class ChatService {
    private final RedisTemplate<String, Object> redisTemplate;

    public void sendMessage(ChatMessage message) {
        redisTemplate.convertAndSend("chatRoom:" + message.getRoomId(), message);
    }
}
 HTTP/2 + WebSocket 병행 구조
📌 HTTP/2와 WebSocket 차이

항목	HTTP/2	WebSocket
전송 방식	스트림 기반 요청-응답 다중화	양방향 TCP 연결
주 사용 목적	일반 요청-응답 속도 향상	실시간 통신
연결 유지	기본적으로 짧음	지속 연결 유지
📘 병행 구조 예시
HTTP/2는 정적 리소스, 일반 API

WebSocket은 채팅, 알림 등 실시간 데이터

plaintext
복사
편집
[Client]
  ├─ GET /api/products → HTTP/2 (빠른 응답)
  └─ ws://chat → WebSocket (지속 연결)
 실전에서는 Nginx + Spring Boot 환경에서 포트를 나누거나 Nginx가 프로토콜에 따라 분기 처리

 HTTP/3 도입 고려 시 체크리스트

항목	설명
브라우저 지원 여부	최신 브라우저는 대부분 지원 (Chrome, Firefox 등)
서버 환경	Nginx 1.25+ or Cloudflare 등
패킷 드롭 환경 고려	QUIC은 UDP 기반이라 패킷 유실 환경에서 더 우수
실시간 성능	WebSocket보다 빠른 연결 확립 (0-RTT)
구성 난이도	Nginx 설정 및 인증서 TLS 1.3 이상 필수
 보너스: WebSocket 메시지 보안 고려사항
Origin 체크: 악성 Origin 차단

토큰 인증 (JWT) → 최초 연결 시 헤더/파라미터로 검증

메시지 필터링 (XSS/SQL Injection 방어)

연결 제한 및 타임아웃 설정 (DDOS 방지)

✨ 정리: 실무 아키텍처 추천

기능	적용 기술
빠른 데이터 로딩	HTTP/2
실시간 채팅	WebSocket + Redis Pub/Sub
단방향 알림	SSE (간단한 서버 구성 시)
고성능 모바일 환경	HTTP/3 (QUIC 기반 CDN 활용)

1. WebSocket + JWT 인증 흐름
📌 목적
WebSocket은 기본적으로 Header 인증이 불가능하므로 JWT 토큰 기반 인증을 초기 연결 시 처리해야 함.

📘 인증 흐름
HTTP Handshake 시 토큰 전송

ws:// 또는 wss:// 접속 시 Authorization 토큰을 Query Parameter 또는 Cookie/Header-like 방식으로 전달

Spring 서버에서 토큰 검증

WebSocket HandshakeInterceptor에서 JWT 유효성 검증 수행

인증 성공 시 사용자 정보 context에 저장

연결 이후 메시지 송수신

💻 코드 예시 – Spring Boot
🔧 WebSocketConfig
java
복사
편집
@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {
    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        registry.addEndpoint("/ws")
                .addInterceptors(new JwtHandshakeInterceptor())
                .setAllowedOrigins("*");
    }
}
🔐 JwtHandshakeInterceptor
java
복사
편집
public class JwtHandshakeInterceptor implements HandshakeInterceptor {
    @Override
    public boolean beforeHandshake(ServerHttpRequest request, ServerHttpResponse response,
                                   WebSocketHandler wsHandler, Map<String, Object> attributes) {
        String token = getTokenFromQueryParam(request);
        if (isValidJwt(token)) {
            attributes.put("userId", getUserIdFromToken(token));
            return true;
        }
        return false;
    }
}
 2. 실시간 통신과 DB 일관성 처리 전략
📌 문제
WebSocket 통신은 비동기성이 강해 DB 반영 순서의 보장이나 중복 저장, 유실 문제 발생 가능성 있음

🔍 해결 전략

전략	설명
Redis Queue	WebSocket 메시지를 Queue에 넣고, Consumer에서 DB 저장
Kafka	대규모 트래픽 시 메시지 브로커로 Kafka 활용
Transaction Manager	WebSocket 처리도 트랜잭션으로 래핑 (주의: 병목 발생 가능)
메시지 UUID	메시지 단위 식별자로 중복 저장 방지
💡 실전 예시
java
복사
편집
public void handleMessage(ChatMessage message) {
    if (redisSet.contains(message.getMessageId())) return; // 중복 방지
    redisSet.add(message.getMessageId());
    db.save(message);
}
 3. WebSocket + Kafka 구조 적용
📌 왜 Kafka인가?
분산 환경에서 고가용성과 메시지 복구, 비동기 처리, 확장성 확보

📘 구조 흐름
plaintext
복사
편집
[Client A] → WS → [Spring A] — Kafka (chat-topic) —> [Spring B] → WS → [Client B]
WebSocket 메시지를 Kafka로 produce

다른 서버들은 Kafka에서 consume → WebSocket을 통해 사용자에게 전달

💻 코드 예시 (Spring Kafka)
🔹 Producer
java
복사
편집
@Service
@RequiredArgsConstructor
public class KafkaChatProducer {
    private final KafkaTemplate<String, String> kafkaTemplate;

    public void send(String topic, String message) {
        kafkaTemplate.send(topic, message);
    }
}
🔹 Consumer
java
복사
편집
@KafkaListener(topics = "chat-topic", groupId = "chat-group")
public void consume(String message) {
    // WebSocket 전송
    messagingTemplate.convertAndSend("/topic/chat", message);
}
 4. WebSocket vs WebRTC 비교 및 통합 고려사항
📘 개념 차이

항목	WebSocket	WebRTC
목적	실시간 메시지, 채팅 등	실시간 오디오/비디오, P2P 데이터 전송
연결 방식	클라이언트 ↔ 서버	클라이언트 ↔ 클라이언트 (P2P)
미디어 지원	❌ 없음	 오디오/비디오 지원
브라우저 호환성	매우 좋음	대부분 지원됨 (Safari 약간 제한 있음)
🔧 WebRTC 구성 요소
STUN: 공인 IP 주소 확인용

TURN: P2P 불가 시 중계 서버

SDP: 연결 설정 시 Session Description Protocol 사용

☑️ 통합 시 고려사항

항목	WebRTC	WebSocket
시그널링 용도	❌ 없음 → 직접 구현	 사용 권장
데이터 초기 교환	불가	 SDP, ICE 정보 교환 가능
서버 역할	최소화	중심 허브 역할
➡ WebRTC + WebSocket 조합
WebSocket은 시그널링 채널로만 사용, 실질적인 데이터 전송은 WebRTC가 담당

 정리

주제	요약
WebSocket + JWT	Handshake 단계에서 인증 처리 필수
실시간 + DB	Kafka/Redis로 비동기 처리하고 중복 방지 설계
WebSocket + Kafka	대규모 트래픽 대응용 구조
WebRTC 비교	미디어/스트리밍은 WebRTC, 시그널링은 WebSocket 활용


---

[🔙 Back to Portfolio Main](../index.md)

---
