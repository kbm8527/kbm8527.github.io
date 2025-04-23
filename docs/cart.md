
---
layout: default
title: 장바구니 기능

---

# 🛒 장바구니 (Cart) 기능

##  1. 기능 개요
- **기능 명칭**: 장바구니(Cart) 관리
- **설명**: 사용자가 원하는 상품을 장바구니에 추가하고, 수량/옵션을 수정하거나, 선택,일괄 삭제하는 기능
- **기술 스택**: Spring Boot, JPA, UUID, VO/DTO 구조, @AuthenticationPrincipal, 레이어드 아키텍처

---

##  2. 구현 목적 및 요구사항
- 상품 ID, 옵션 ID 기반 장바구니 저장
- 수량, 체크 여부 변경 가능
- 선택 삭제(복수 UUID) 기능 제공
- 응답 시 상품 + 옵션 + 이미지 조합 응답 제공
- 연관관계 없이 ID 기반으로 정보 조회

---

##  3. API 명세 (일부)

| HTTP | URL | 설명 |
|------|-----|------|
| GET | /api/v1/cart/all | 장바구니 전체 조회 |
| POST | /api/v1/cart/add | 장바구니에 상품 추가 |
| PUT | /api/v1/cart/items | 장바구니 항목 수정 |
| DELETE | /api/v1/cart/items | 선택 항목 삭제 |

---

##  4. 장바구니 도메인 구조 (Entity)

```java
package com.starbucks.starvive.cart.domain;

import com.starbucks.starvive.common.domain.BaseEntity;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.UuidGenerator;
import java.util.UUID;

@Entity
@Getter
@NoArgsConstructor
public class Cart extends BaseEntity {

    @Id
    @UuidGenerator
    @Column(updatable = false, nullable = false, columnDefinition = "BINARY(16)")
    private UUID cartId;

    @Column(columnDefinition = "BINARY(16)", nullable = false)
    private UUID userId;

    @Column(columnDefinition = "BINARY(16)", nullable = false)
    private UUID productOptionId; // 상품 옵션 식별자 (= productId로 사용)

    @Column(columnDefinition = "BINARY(16)", nullable = false)
    private UUID productId;

    @Column(nullable = false)
    private Integer quantity;

    @Column(nullable = false)
    private Boolean checked;


    @Builder
    public Cart(UUID cartId, UUID userId, UUID productId, UUID productOptionId, Integer quantity, Boolean checked) {
        this.cartId = cartId;
        this.userId = userId;
        this.productId = productId;
        this.productOptionId = productOptionId;
        this.quantity = quantity;
        this.checked = checked;
    }

    public void update(UUID productOptionId, int quantity, boolean checked) {
        this.productOptionId = productOptionId;
        this.quantity = quantity;
        this.checked = checked;
    }

    public void updateChecked(boolean checked) {
        this.checked = checked;
    }
}
```

---

##  5. 장바구니 전체 조회 (ServiceImpl)

```java
 @Transactional(readOnly = true)
    @Override
    public List<CartItemResponseVo> getCartList(UUID userId) {
        return cartRepository.findAllByUserId(userId).stream()
                .map(cart -> {
                    Product product = productRepository.findById(cart.getProductId())
                            .orElseThrow(() -> new BaseException(NO_EXIST_PRODUCT));

                    ProductOption option = productOptionRepository.findById(cart.getProductOptionId())
                            .orElseThrow(() -> new BaseException(NO_EXIST_OPTION));

                    ProductImage image = productImageRepository.findFirstByProductId(cart.getProductId())
                            .orElseThrow(() -> new BaseException(NO_EXIST_IMAGE));

                    return CartItemResponseVo.from(cart, product, option, image);
                })
                .collect(Collectors.toList());
    }
```

---

##  6. 컨트롤러 주요 포인트
- `@AuthenticationPrincipal`로 유저 ID 주입
- VO → DTO 변환 일관화
- Swagger 문서화 (`@Operation`) 포함

---

##  7. 응답 구조 예시 (CartItemResponseVo)

```json

    {
        "cartId": "1195377f-2026-41ef-9467-9df422795510",
        "productId": "1644e107-26a5-4f71-b8a9-6cf09b05bb11",
        "productOptionId": "016d697b-8895-421d-9097-73b38e66567a",
        "name": "[스타벅스] 홀리데이 딜라이트 오너먼트 백참 세트",
        "optionName": "",
        "imageThumbUrl": "https://sitem.ssgcdn.com/96/45/01/item/1000630014596_i1_500.jpg",
        "imageThumbAlt": "상품이미지1",
        "price": 29000,
        "baseDiscountRate": 0,
        "discountedPrice": 29000,
        "quantity": 5,
        "checked": true
    }
```

---

##  8. 특징 및 장점

| 항목 | 구현 |
|------|------|
| 연관 도메인 분리 조회 | productId, optionId, imageId 별도 조회 |
| 응답 최적화 | VO 기반 응답 구성 |
| 수량, 옵션, 체크 수정 | 모두 DTO 한 번에 처리 |
| 선택 삭제 지원 | UUID 리스트로 일괄 삭제 |
| VO-DTO 변환 일관화 | 모든 요청/응답 VO → DTO 분리 |
| 인증 사용자 기반 처리 | @AuthenticationPrincipal 기반 userId 처리 |

---

##  9. 포트폴리오 어필 포인트
- 실제 이커머스에 필요한 장바구니 기능을 UUID 기반으로 구현
- 연관관계 대신 명시적 ID를 통한 조회로 성능 제어
- 상품 정보 조합 응답 구조 설계 능력 강조
- 실무에서도 자주 쓰이는 일괄 삭제, 수정 구조 구현
