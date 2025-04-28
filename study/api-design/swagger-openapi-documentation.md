---
layout: default
title: Swagger Openapi Documentation
---


## 목차


### 🔗 [Swagger Documentation](/study/api-design/)


Swagger/OpenAPI는 RESTful API를 설계, 문서화, 테스트, 그리고 클라이언트·서버 코드 생성을 지원하는 오픈 표준 사양이자 툴체인입니다. 아래는 Swagger 활용을 처음부터 실습까지 따라 할 수 있도록 단계별로 정리한 내용입니다.

### 1. 설치 및 환경 준비

1. **Node.js 및 npm 설치**:
   - Node.js 공식 사이트(https://nodejs.org/)에서 설치 후 `node -v`, `npm -v`로 버전 확인

2. **Swagger Editor 로컬 실행**:
   ```bash
   npm install -g @swagger-api/swagger-editor
   swagger-editor --hostname 0.0.0.0 --port 3000
   ```
   - 브라우저에서 http://localhost:3000 접속 → 실시간으로 YAML 편집 및 UI 확인 가능

3. **Spring Boot 연동용 springdoc-openapi** (선택)
   ```xml
   <dependency>
     <groupId>org.springdoc</groupId>
     <artifactId>springdoc-openapi-ui</artifactId>
     <version>1.7.0</version>
   </dependency>
   ```

### 2. OpenAPI 사양 기본 구조

```yaml
openapi: 3.0.1
info:
  title: Book Service API
  version: 1.0.0
servers:
  - url: http://localhost:8080/api
paths:
  /books:
    get:
      summary: 전체 도서 조회
      responses:
        '200':
          description: 성공
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/Book'
components:
  schemas:
    Book:
      type: object
      properties:
        id:
          type: integer
        title:
          type: string
        author:
          type: string
      required:
        - id
        - title
        - author
```

### 3. 실습 예제: Book API 정의 및 테스트

1. **YAML 파일 작성**
   - 위 예시를 `book-api.yaml`로 저장
2. **Swagger Editor 로드**
   - 에디터 왼쪽에 YAML 붙여넣기 → 오른쪽에서 API 문서 및 Try it out 사용
3. **POST 엔드포인트 추가**
   ```yaml
   /books:
     post:
       summary: 새 도서 등록
       requestBody:
         required: true
         content:
           application/json:
             schema:
               $ref: '#/components/schemas/Book'
       responses:
         '201':
           description: 생성됨
   ```

### 4. Spring Boot와 통합

1. **springdoc-openapi-ui 활성화**
   - 의존성 추가 후 애플리케이션 실행
   - http://localhost:8080/swagger-ui.html 접속 → 자동 생성된 문서 확인

2. **Controller 어노테이션 예시**
   ```java
   @RestController
   @RequestMapping("/api/books")
   public class BookController {
       @Operation(summary = "전체 도서 조회")
       @GetMapping
       public List<BookDto> getAll() { ... }

       @Operation(summary = "새 도서 등록")
       @ApiResponse(responseCode = "201", description = "등록 성공")
       @PostMapping
       public ResponseEntity<Void> create(@RequestBody BookDto dto) { ... }
   }
   ```

### 5. 클라이언트 코드 생성 (OpenAPI Generator)

```bash
npm install @openapitools/openapi-generator-cli -g
openapi-generator-cli generate -i book-api.yaml -g java -o ./generated-client
```

### 6. 베스트 프랙티스

- **components 구조 활용**: 재사용 가능한 스키마(`components/schemas`), 파라미터, 응답 정의
- **보안 스킴 정의**: JWT, OAuth2 등을 `components/securitySchemes`에 명시
- **버저닝 전략**: `info.version` 또는 URI `/v1/books` 등
- **명확한 설명 추가**: `summary`, `description`, `tags` 활용




  
---

[🔙 Back to Portfolio Main](../index.md)

---


