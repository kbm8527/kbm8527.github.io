---
layout: default
title: Dto Vo Structure
---

## 목차

### 🔗 [Dto Vo Structure](/study/api-design/)

- [Dto Vo Structure](/study/api-design/dto-vo-structure)

DTO(Data Transfer Object) 및 VO(Value Object) 구조에 대해 더욱 심층적으로 상세히 정리하여 실제 사용 예시를 포함한 필수 내용을 안내드립니다.

## DTO(Data Transfer Object)

### 개념
DTO는 데이터를 전달하기 위한 객체로, 주로 시스템 간 또는 계층 간 데이터 전송에 사용됩니다.

### DTO의 주요 특성
- 데이터를 전송하기 위한 객체로, 로직을 포함하지 않습니다.
- 데이터 전송에 필요한 최소한의 필드만 포함하여 효율성을 높입니다.
- 계층 간 결합도를 낮추고 명확한 데이터 전송을 지원합니다.

### DTO 사용 목적
- API 응답 및 요청 시 데이터 형태 명확화
- 엔티티(Entity)와 역할 분리를 통한 유지보수성 향상
- 민감한 정보의 노출 방지

### DTO 설계 원칙
- 최소한의 필드만 포함
- 직관적인 네이밍 사용
- 데이터 검증(Validation)을 DTO 내부에 포함

### DTO와 Entity 간의 변환 예시

```java
// Entity
public class ProductEntity {
    private Long id;
    private String name;
    private int price;

    // Getters, setters...
}

// DTO
public class ProductResponseDto {
    private Long id;
    private String name;
    private int price;

    public static ProductResponseDto fromEntity(ProductEntity entity) {
        ProductResponseDto dto = new ProductResponseDto();
        dto.id = entity.getId();
        dto.name = entity.getName();
        dto.price = entity.getPrice();
        return dto;
    }

    // Getters, setters...
}
```

## VO(Value Object)

### 개념
VO는 값을 표현하는 불변 객체로, 동일한 값이면 같은 객체로 취급됩니다.

### VO의 주요 특성
- Immutable(불변성): 생성 후 변경 불가
- 데이터 변경 시 새로운 객체 생성
- 명확한 값 비교 가능

### VO 사용 목적
- 데이터 무결성 보장
- 복잡한 도메인 로직 명확히 표현
- 값 기반 비교 가능

### VO 설계 원칙
- 불변성 유지
- 모든 값은 생성자 초기화
- 도메인 의미 반영하는 명확한 네이밍

### VO 활용 예시

```java
public class Money {
    private final int amount;
    private final String currency;

    public Money(int amount, String currency) {
        this.amount = amount;
        this.currency = currency;
    }

    public Money add(Money other) {
        if (!currency.equals(other.currency)) {
            throw new IllegalArgumentException("Currency mismatch");
        }
        return new Money(this.amount + other.amount, this.currency);
    }

    public int getAmount() {
        return amount;
    }

    public String getCurrency() {
        return currency;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Money)) return false;
        Money money = (Money) o;
        return amount == money.amount && currency.equals(money.currency);
    }

    @Override
    public int hashCode() {
        return Objects.hash(amount, currency);
    }
}
```

## DTO와 VO의 차이점 요약
- **DTO**: 데이터 전송 목적, 변경 가능, 계층 간 데이터 전달
- **VO**: 도메인 내 값 표현, 불변성, 값 기반 비교

## 효과적인 활용 팁
- DTO와 VO를 목적에 맞게 명확히 분리하여 사용
- DTO는 전송 데이터 최적화, VO는 도메인 무결성 유지

이러한 개념과 예시를 통해 DTO 및 VO를 실무에서 효과적으로 적용할 수 있습니다.








  
---
[🔙 Back to Portfolio Main](../index.md)

---



