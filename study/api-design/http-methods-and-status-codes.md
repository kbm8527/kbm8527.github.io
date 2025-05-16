---
layout: default
title: Http Methods And Status Codes

---

---

## 목차


### 🔗 [HTTP Methods and Status Codes](/study/api-design/)

HTTP Methods와 HTTP 상태 코드(Status Codes)에 대해 심층적으로 상세히 정리하여 학습에 필요한 모든 내용을 안내드립니다.

## HTTP Methods

HTTP 메서드는 클라이언트가 서버에게 원하는 동작을 요청할 때 사용되는 동사 형태의 명령어입니다. RESTful API 설계에서는 HTTP 메서드를 명확히 이해하고 올바르게 사용하는 것이 매우 중요합니다.

### 주요 HTTP Methods의 개념과 용도

- **GET**
  - 자원을 조회할 때 사용됩니다.
  - 멱등성을 보장합니다(동일 요청 반복 시 동일 결과).
  - 데이터를 조회할 때 자원의 상태를 변경하지 않아야 합니다.
  
  **예시:**
  ```http
  GET /products/123
  ```

- **POST**
  - 새로운 자원을 생성할 때 사용됩니다.
  - 멱등성을 보장하지 않습니다(동일 요청 반복 시 결과가 다를 수 있음).

  **예시:**
  ```http
  POST /products
  ```

- **PUT**
  - 기존 자원의 전체를 수정하거나 없으면 생성할 때 사용됩니다.
  - 멱등성을 보장합니다.

  **예시:**
  ```http
  PUT /products/123
  ```

- **PATCH**
  - 기존 자원의 일부만 수정할 때 사용됩니다.
  - 멱등성을 보장하지 않을 수 있습니다.

  **예시:**
  ```http
  PATCH /products/123
  ```

- **DELETE**
  - 기존 자원을 삭제할 때 사용됩니다.
  - 멱등성을 보장합니다.

  **예시:**
  ```http
  DELETE /products/123
  ```

## HTTP 상태 코드(Status Codes)

HTTP 상태 코드는 클라이언트가 보낸 요청의 처리 결과를 나타내는 숫자 코드입니다. 클라이언트가 요청을 올바르게 이해하고 응답에 대응할 수 있도록 명확히 정의되어 있습니다.

### 주요 HTTP 상태 코드

#### 2xx (성공)
- **200 OK**: 요청이 성공적으로 처리됨.
- **201 Created**: 새로운 자원이 성공적으로 생성됨.
- **204 No Content**: 요청 성공, 응답 본문이 없음.

#### 4xx (클라이언트 오류)
- **400 Bad Request**: 요청이 잘못된 형식이거나 유효하지 않음.
- **401 Unauthorized**: 인증이 필요한 요청에서 인증되지 않은 상태.
- **403 Forbidden**: 서버가 요청을 이해했으나 접근 권한이 없음.
- **404 Not Found**: 요청한 자원이 서버에 존재하지 않음.
- **405 Method Not Allowed**: 요청된 HTTP 메서드가 허용되지 않음.
- **409 Conflict**: 요청이 현재 자원의 상태와 충돌함.
- **422 Unprocessable Entity**: 요청은 형식적으로는 맞지만 내용적으로 처리할 수 없음.

#### 5xx (서버 오류)
- **500 Internal Server Error**: 서버 내부에서 예기치 못한 오류가 발생함.
- **503 Service Unavailable**: 서버가 현재 요청을 처리할 수 없는 상태임(일시적 장애).

### HTTP 상태 코드의 올바른 활용
- 상태 코드는 요청 결과를 클라이언트가 쉽게 파악할 수 있도록 정확히 사용해야 합니다.
- 적절한 상태 코드를 통해 오류 처리, 예외 처리 등 API 사용자에게 명확한 정보를 제공해야 합니다.

## 멱등성(Idempotency)
- 같은 요청을 여러 번 수행해도 항상 동일한 결과를 보장하는 성질입니다.
- 멱등성을 보장해야 하는 HTTP 메서드는 GET, PUT, DELETE입니다.
- POST, PATCH 메서드는 멱등성을 보장하지 않을 수 있으므로 사용 시 주의가 필요합니다.

이러한 HTTP Methods와 상태 코드에 대한 내용을 명확히 이해하고 적용하면 API 개발과 설계 시 효과적인 커뮤니케이션과 안정성을 확보할 수 있습니다.

s

  
---
[🔙 Back to Portfolio Main](../index.md)

---


