---
layout: default
title: 추천 섹션 기능
---

# 🧩 추천 섹션 (Featured Section) 기능

##  1. 기능 개요
- **기능 명칭**: 추천 섹션(Featured Section) 관리
- **설명**: 메인 페이지에 섹션별로 추천 상품을 구성하여 출력하는 기능
- **기술 스택**: Spring Boot, JPA, UUID, 레이어드 아키텍처, VO → DTO 매핑

---

##  2. 구현 목적 및 요구사항
- 관리자가 추천 섹션을 등록/수정/삭제 가능
- 각 추천 섹션에는 다양한 상품을 연결 가능
- Product, ProductOption, ProductImage 정보를 조합하여 섹션별 상품 정보 제공
- Product와 섹션은 연관 관계 없이 ID 기반 연결
- soft delete는 사용하지 않고 `삭제 = 실제 삭제`

---

##  3. API 명세 

| HTTP | URL | 설명 |
|------|-----|------|
| POST | /api/v1/featured-section/add | 추천 섹션 등록 |
| PUT | /api/v1/featured-section | 추천 섹션 수정 |
| DELETE | /api/v1/featured-section | 추천 섹션 삭제 |
| GET | /api/v1/featured-section | 추천 섹션 단건 조회 |
| GET | /api/v1/featured-section/all | 전체 섹션 조회 |
| POST | /api/v1/featured-section/register-product | 추천 섹션에 단일 상품 등록 |
| POST | /api/v1/featured-section/register-products | 추천 섹션에 다중 상품 등록 |
| GET | /api/v1/featured-section/products | 섹션별 상품 리스트 조회 |

---

##  4. 추천 섹션 도메인 구조 (Entity)

```java
@Getter
@Entity
@NoArgsConstructor
public class FeaturedSection {

    @Id
    @UuidGenerator
    @Column(columnDefinition = "BINARY(16)", nullable = false)
    private UUID featuredSectionId;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private boolean activated;

    @Builder
    public FeaturedSection(UUID featuredSectionId, String name, boolean activated) {
        this.featuredSectionId = featuredSectionId;
        this.name = name;
        this.activated = activated;
    }

    public void update(String name, boolean activated) {
        this.name = name;
        this.activated = activated;
    }
}

```

---

##  5. 추천 섹션 상품 연결 구조 (Entity)

```java
@Getter
@Entity
@NoArgsConstructor
public class FeaturedSectionProduct {

    @Id
    @UuidGenerator
    @Column(updatable = false, nullable = false, columnDefinition = "BINARY(16)")
    private UUID featuredSectionProductId;

    @Column(columnDefinition = "BINARY(16)", nullable = false)
    private UUID productId;

    @Column(columnDefinition = "BINARY(16)", nullable = false)
    private UUID featuredSectionId;

    @Column(columnDefinition = "BINARY(16)", nullable = false)
    private UUID productOptionId;

    @Column(columnDefinition = "BINARY(16)", nullable = false)
    private UUID productImageId;

    @Builder
    public FeaturedSectionProduct(UUID featuredSectionProductId, UUID productId,
                                  UUID featuredSectionId, UUID productOptionId, UUID productImageId) {
        this.featuredSectionProductId = featuredSectionProductId;
        this.productId = productId;
        this.featuredSectionId = featuredSectionId;
        this.productOptionId = productOptionId;
        this.productImageId = productImageId;
    }
}
```

---

##  6. 섹션별 상품 리스트 조회 (ServiceImpl)

```java
@Transactional(readOnly = true)
    @Override
    public List<FeaturedSectionProductGroupResponseDto> getProductsBySections(List<UUID> sectionIds) {

        List<FeaturedSectionProduct> sectionProducts = featuredSectionProductRepository.findAllByFeaturedSectionIdIn(sectionIds);

        Map<UUID, List<FeaturedSectionProductResponseDto>> groupedBySection = sectionProducts.stream()
                .collect(Collectors.groupingBy(
                        FeaturedSectionProduct::getFeaturedSectionId,
                        Collectors.mapping(featuredSectionProduct -> {

                            Product product = productRepository.findById(featuredSectionProduct.getProductId())
                                    .orElseThrow(() -> new BaseException(NO_EXIST_PRODUCT));
                            ProductOption option = productOptionRepository.findById(featuredSectionProduct.getProductOptionId())
                                    .orElseThrow(() -> new BaseException(NO_EXIST_OPTION));
                            ProductImage image = productImageRepository.findById(featuredSectionProduct.getProductImageId())
                                    .orElseThrow(() -> new BaseException(NO_EXIST_IMAGE));

                            return FeaturedSectionProductResponseDto.from(featuredSectionProduct, product, option, image);
                        }, Collectors.toList())
                ));

        return groupedBySection.entrySet().stream()
                .map(entry -> FeaturedSectionProductGroupResponseDto.builder()
                        .featuredSectionsId(entry.getKey())
                        .products(entry.getValue())
                        .build())
                .toList();
    }

```

---

##  7. 컨트롤러 주요 포인트
- `@RequestBody` 방식으로 VO → DTO 변환 후 처리
- 단건 및 다중 상품 등록 API 분리 설계
- `@Operation`으로 Swagger 문서 자동화 처리

---

##  8. 응답 구조 예시 (VO)

```json
"featuredSectionsId": "f77d870d-8c3c-4ab6-81e7-f182a7650ee8",
        "products": [
            {
                "productId": "013ca7dd-b36e-4355-8218-8ba02f3ef791",
                "imageThumbUrl": "https://sitem.ssgcdn.com/28/54/31/item/1000560315428_i1_500.jpg",
                "imageThumbAlt": "상품이미지1",
                "name": "[스타벅스] SS 콩코드 하우스 텀블러 591ml",
                "price": 36000,
                "baseDiscountRate": 0
            }
```

---

##  9. 특징 및 장점

| 항목 | 구현 |
|------|------|
| ID 기반 매핑 | 연관관계 없이 UUID로 도메인 직접 연결 |
| 복합 응답 구성 | Product + Option + Image 정보 조합 |
| VO-DTO-Entity 구조 | 명확한 계층 분리 |
| 예외 처리 | BaseException + BaseResponseStatus로 통일 |
| 일괄 등록 기능 | 여러 상품을 섹션에 한 번에 등록 가능 |
| 확장성 고려 | 상품 정보가 변경되어도 섹션 응답 구조 유지 |

---

##  10. 포트폴리오 어필 포인트
- 실제 커머스 백엔드의 추천 섹션 기능과 매우 유사한 구조
- 다양한 도메인을 조합하여 단일 응답을 구성하는 설계 능력 표현
- 연관 관계 없이 ID 기반 매핑으로 성능과 복잡도 제어
- 일괄 등록 및 단건 등록 API 분리 → 실무 유용성 강조

