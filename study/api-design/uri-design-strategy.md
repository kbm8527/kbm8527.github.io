---
layout: default
title: Uri Design Strategy

---

---

## 목차


### 🔗 [URI Design Strategy](/study/api-design/)


1. URI(Uniform Resource Identifier)란?
정의: 인터넷상의 “자원(Resource)”을 고유하게 식별하기 위한 표준 문자열

구성 (RFC 3986):

ruby
복사
편집
<scheme>://<authority><path>?<query>#<fragment>
scheme: http, https, ftp, urn 등

authority: 사용자 정보, 호스트명, 포트

path: 자원의 계층적 위치

query: 추가 파라미터 (key=value)

fragment: 문서 내 앵커(일반 API 설계에선 잘 사용되지 않음)

2. 네이밍(Naming) 가이드라인
명사 사용

기능이 아닌 “자원”을 표현

❌ /getUsers → ✅ /users

복수형(Collection) vs 단수형(Resource)

목록: /books → 단일 항목: /books/{bookId}

소문자 & 하이픈(-)

카멜케이스 금지, 단어 구분은 -

예) /user-profiles, /order-items

파일 확장자 생략

.json, .xml 등은 URI에서 제거

3. 계층 구조 표현(Hierarchy)
컬렉션 조회

bash
복사
편집
GET /products
단일 자원 조회

bash
복사
편집
GET /products/{productId}
하위 자원(Sub-resource)

bash
복사
편집
GET /products/{productId}/reviews
GET /users/{userId}/orders
4. Query 파라미터 활용
필터링

bash
복사
편집
GET /products?category=electronics&brand=sony
정렬(Sorting)

bash
복사
편집
GET /products?sort=price,desc
페이징(Pagination)

arduino
복사
편집
GET /products?page=2&size=20
검색(Searching)

sql
복사
편집
GET /products?search=wireless+headphones
5. API 버저닝(Versioning)
URI 버저닝 (직관적)

bash
복사
편집
GET /v1/products
헤더 버저닝

bash
복사
편집
Accept: application/vnd.myapp.v1+json
미디어 타입 버저닝

pgsql
복사
편집
Content-Type: application/vnd.myapp.product+json;version=1
팁: URI 버전은 캐시 친화적이지만 URI가 길어지고, 헤더 버전은 URI가 깔끔하나 프록시 지원 이슈가 있을 수 있습니다.

6. 동작 기반 경로 지양
❌ /createOrder, /deleteUser

✅ POST /orders, DELETE /users/{userId}

7. 고급 주제
HATEOAS
응답에 다음 가능한 액션 링크를 포함하여 클라이언트가 동적으로 API를 탐색하게 함

json
복사
편집
{
  "id": 123,
  "name": "Sample",
  "_links": {
    "self":    { "href": "/products/123" },
    "reviews": { "href": "/products/123/reviews" }
  }
}
Canonicalization & Normalization

중복 슬래시(//) 제거

트레일링 슬래시(/path/ vs /path) 통일

와일드카드 경로 지양

/* 보단 명확한 경로 사용

8. 설계 시 주의사항
보안: 민감 정보(ID, 비밀번호 등)를 URI에 노출 금지

길이 제한: 일반적으로 2,000자 이내 유지

인코딩: 특수문자·비영어권 문자는 URL 인코딩 필수

9. 종합 실전 예시
http
복사
편집
# 전체 상품 목록 조회
GET    https://api.example.com/v1/products?page=1&size=10&sort=price,asc

# 새 상품 등록
POST   https://api.example.com/v1/products
Content-Type: application/json
{
  "name": "Wireless Earbuds",
  "price": 99000
}

# 특정 상품 상세 조회
GET    https://api.example.com/v1/products/123

# 상품 전체 수정
PUT    https://api.example.com/v1/products/123
Content-Type: application/json
{
  "name": "Updated Name",
  "price": 105000
}

# 상품 일부 상태 변경
PATCH  https://api.example.com/v1/products/123
Content-Type: application/json
{
  "price": 95000
}

# 상품 삭제
DELETE https://api.example.com/v1/products/123

# 특정 사용자의 주문 리스트 조회
GET    https://api.example.com/v1/users/42/orders?status=shipped

URI와 RESTful API
자원 식별: HTTP 요청 행(예: GET /products/123)의 URI가 “어떤” 자원을 다룰지 결정합니다.

일관성: 잘 설계된 URI는 API 사용자에게 “이렇게 하면 이 자원을 가져올 수 있겠구나”를 예측 가능하게 해 줍니다.

자원 지향: URI는 절대 동작(action)을 담지 않고 “무엇을” 중심으로 설계해야 합니다.

URL vs URN vs URI

구분	설명	예시
URI	자원의 식별자를 통틀어 지칭	https://example.com/docs#intro
URL	자원의 위치(어디에, 어떻게 접근할지)	https://example.com/api/users
URN	자원의 이름(영구 식별자), 위치와 무관	urn:isbn:9780262033848
왜 URI 설계가 중요한가?
가독성(Readability)

개발자와 소비자가 URI만 보고도 “무엇을 요청하는지” 쉽게 이해할 수 있습니다.

예측 가능성(Predictability)

일관된 규칙을 따르면 새로운 엔드포인트도 짐작할 수 있어 학습 곡선이 완만해집니다.

유지보수(Maintainability)

명확한 구조 덕분에 API 변경·확장 시 파급 범위를 쉽게 파악할 수 있습니다.

SEO & 문서 자동화

URI 구조가 깔끔하면 Swagger·OpenAPI 같은 도구로 문서를 자동화하기도 쉽습니다.

실전 예시
http
복사
편집
# 전체 사용자 목록 조회
GET  https://api.example.com/v1/users

# 특정 사용자 상세 조회
GET  https://api.example.com/v1/users/42

# 해당 사용자의 주문 목록 조회
GET  https://api.example.com/v1/users/42/orders?page=1&size=10

# 새 주문 생성
POST https://api.example.com/v1/users/42/orders

# 주문의 일부 필드(상태)만 수정
PATCH https://api.example.com/v1/users/42/orders/1001/status
Content-Type: application/json

{ "status": "shipped" }

# 주문 삭제
DELETE https://api.example.com/v1/users/42/orders/1001
이제 **“URI란 무엇인지”**부터 **“어떻게 구성되고 왜 중요한지”**를 이해하셨습니다. 다음 단계로는 네이밍 규칙, 계층화 구조, 쿼리 파라미터 활용법 등을 위 예시와 함께 연습해 보세요!







---

[🔙 Back to Portfolio Main](../index.md)

---


