---
layout: default
title: 상품 기능
---

# 🛍️ 상품 (Product) 기능

##  1. 기능 개요
- **기능 명칭**: 상품(Product) 관리
- **설명**: 상품 등록, 수정, 삭제, 단건 및 상세 조회, 무한스크롤 조회
- **기술 스택**: Spring Boot, JPA, UUID, DTO/VO 구조, Cursor 기반 페이징

---

##  2. 구현 목적 및 요구사항
- 상품 등록/수정/삭제 기능
- 단건 조회, 상세 조회 제공
- 무한스크롤용 Cursor 기반 페이징
- 상품 정보는 Product + ProductOption + ProductImage 조합
- 베스트 상품은 별도 테이블로 관리, Spring Batch로 자동 반영

---

##  3. API 명세 

| HTTP | URL | 설명 |
|------|-----|------|
| POST | /api/v1/product/add | 상품 등록 |
| PUT | /api/v1/product | 상품 수정 |
| DELETE | /api/v1/product | 상품 삭제 |
| GET | /api/v1/product | 단건 상품 조회 |
| GET | /api/v1/product/all | 전체 상품 조회 (무한스크롤) |
| GET | /api/v1/product/detail | 상품 상세 조회 |

---

##  4. 상품 도메인 구조 (Entity)

```java
@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Product extends BaseEntity {

    @Id
    @UuidGenerator
    @Column(columnDefinition = "BINARY(16)", nullable = false)
    private UUID productId;

    @Column(nullable = false)
    private String name;

    @Enumerated(EnumType.STRING)
    private ProductStatus productStatus;

    @Builder
    public Product(UUID productId, String name,
                    ProductStatus productStatus) {
        this.productId = productId;
        this.name = name;
        this.productStatus = productStatus;
    }

    public void update(String name, ProductStatus status) {
        this.name = name;
        this.productStatus = status;
    }
}
```

---

##  5. 상품 목록 조회 (무한스크롤 방식)

```java
@Transactional(readOnly = true)
    @Override
    public List<ProductListResponseDto> getProductsByCursor(UUID lastProductId, int size) {
        Pageable pageable = PageRequest.of(0, size);
        List<Product> products = (lastProductId == null)
                ? productRepository.findAllByOrderByProductIdDesc(pageable)
                : productRepository.findByProductIdLessThanOrderByProductIdDesc(lastProductId, pageable);

        return products.stream()
                .map(product -> {
                    ProductOption option = productOptionRepository.findFirstByProductId(product.getProductId()).orElse(null);
                    ProductImage image = productImageRepository.findFirstByProductId(product.getProductId()).orElseThrow(() -> new BaseException(NO_EXIST_IMAGE));
                    return ProductListResponseDto.from(product, option, image);
                })
                .toList();
    }
```

---

##  6. 상품 상세 조회

```java
@Override
    public ProductDetailResponseDto getProductDetail(UUID productId) {
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new BaseException(NO_EXIST_PRODUCT));

        ProductOption option = productOptionRepository.findFirstByProductId(productId)
                .orElseThrow(() -> new BaseException(NO_EXIST_OPTION));

        ProductImage image = productImageRepository.findFirstByProductId(productId)
                .orElseThrow(() -> new BaseException(NO_EXIST_IMAGE));

        ProductDetailImage detailImage = productDetailImageRepository.findByProductId(productId)
                .orElse(null);

        List<ProductRequiredInfoResponseDto> requiredInfos = productRequiredInfoRepository.findByProductId(productId)
                .stream()
                .map(ProductRequiredInfoResponseDto::from)
                .collect(Collectors.toList());

        return ProductDetailResponseDto.builder()
                .productId(product.getProductId())
                .productOptionId(option.getProductOptionId())
                .imageThumbUrl(image.getImageThumbUrl())
                .name(product.getName())
                .optionName(option.getName())
                .price(option.getPrice())
                .productStatus(product.getProductStatus())
                .productDetailContent(detailImage != null ? detailImage.getProductDetailContent() : null)
                .requiredInfos(requiredInfos)
                .build();
    }
```

---

##  7. 컨트롤러 주요 포인트
- Swagger 연동 (`@Operation`)
- Cursor 기반 페이징 처리
---

##  8. 응답 구조 예시 (ProductDetailResponseDto)

```json
{
    "productId": "449eae12-14dd-41a9-b293-7c25c749b978",
    "productOptionId": "010e268a-2b69-4d93-b729-5bbff763ebc1",
    "imageThumbUrl": "https://sitem.ssgcdn.com/40/26/80/item/1000555802640_i1_500.jpg",
    "name": "스타벅스 [부드러운 디저트 세트(HOT)]카페 아메리카노T 2잔+부드러운 생크림 카스테라",
    "optionName": "",
    "price": 13900,
    "baseDiscountRate": 0,
    "discountedPrice": 13900,
    "productStatus": "READY",
    "productDetailContent": "\n            <!-- 불량판정서 -->\n<div class=\"cdtl_sec_area\">\n    <div class=\"cdtl_sec cdtl_detail_num\">\n        <div class=\"cdtl_cont_info\">\n            <div class=\"cdtl_cont_bx\">\n                <p class=\"cdtl_prd_num\">상품번호 : 1000555802640</p>\n                </div>\n        </div>\n    </div>\n\n    <!--  몰탭 광고 상품 비노출 처리 -->\n    <!--[D] 오픈마켓 -->\n        <!--[D] 해외직구안내 노출 -->\n        <!--[D] 신세계면세점 노출 -->\n        <!--[D] SSG 개런티 -->\n        <!-- [D] 발렉스 -->\n        <!--[D] 미식관 -->\n        <!-- [D] 삼성, 엘지전자 설치상품 -->\n        <!-- 옵션컬러비교 -->\n    <!--  몰탭 광고 상품 비노출 처리 -->\n    <!-- 상품정보탭 > 멤버십 전용 상품 안내 배너 -->\n    <div class=\"cdtl_sec cdtl_seller_html ty_1800\">\n        <h4 class=\"blind\">상품 상세 정보</h4>\n\n        <div class=\"blind\" id=\"itemNutritionGrid\">\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n</div>\n\n        <div class=\"cdtl_capture_img\">\n            <div id=\"descContents\">\n    <button class=\"btn_a11y FullText\" onclick=\"itemDtlDescImgOcrVoiceSupportFullText();\">이미지 OCR 대체 텍스트 음성지원 전체 듣기</button>\n    <button class=\"btn_a11y SummaryText\" onclick=\"itemDtlDescImgOcrVoiceSupportSummaryText();\">이미지 OCR 대체 텍스트 음성지원 요약본 듣기</button>\n    \n <img alt=\"부드러운디저트 세트\" src=\"https://sstatic.ssgcdn.com/cmpt/edit/202405/17/092024051709105960905623012562_430.jpg\" style=\"width: 930px; height: 1800px;\"></div>\n                        </div>\n\n        <div class=\"cdtl_capture_img\">\n                <div class=\"cdtl_tmpl_cont ty_grocery\">\n                    <!-- SSG.Tip -->\n</div>\n            </div>\n        <div class=\"cdtl_seller_html_collapse\">\n            <!-- 활성시 active -->\n            <button type=\"button\" class=\"btn_collapse ctrl_collapse\">\n                <span class=\"collapse_on\">상세정보 펼쳐보기</span>\n                <span class=\"collapse_off\">상세정보 접기</span>\n            </button>\n        </div>\n    </div>\n\n</div>",
    "requiredInfos": [
        {
            "type": "환불 조건",
            "value": "1. 구매자는 최초 유효기간 이내 미사용한 상품권에 대해 구매취소 가능합니다. 2. 최종 수신자는 유효기간 이내 사용가능한 금액형 상품권은 액면가 기준 60%(단, 액면가 1만원 이하는 80%) 사용 후 남은 잔액의 100% 환불이 가능합니다. (단, 할인판매된 금액형 상품권의 경우 상기 조건하에 구매금액을 기준으로 사용비율에 따라 계산하여 남은 비율의 금액을 기준으로 100% 환불이 가능합니다.) 3. 최종 수신자는 유효기간이 만료되었으나 구매일로부터 5년이 지나지 않은 상품권의 경우 물품형은 구매금액의 90%, 금액형은 잔액의 90% 환불이 가능합니다. (단, 할인판매된 금액형 상품권의 경우 구매금액을 기준으로 사용비율에 따라 계산하여 남은 비율의 금액을 기준으로 90% 환불이 가능합니다.) 4. 해당 상품 품절 시 동일 가격 이상의 다른 상품으로 교환가능하며(차액추가지불), 이를 원하지 않을 경우 최초 유효기간 내 환불가능 5. 해당 상품 가격이 인상에 따른 동일 상품 교환불가 시 최초 유효기간 내 환불가능"
        },
        {
            "type": "소비자 상담 관련 전화번호",
            "value": "[구매, 취소, 재전송, 유효기간 연장] 마이페이지 나의 주문내역상에서 환불/재발송 가능 혹은 1577-3419(에스에스지닷컴 고객센터) / [ 환불] 1644-1133(SSGPAY 고객센터) [지급보증] 본 상품권은 지급보증 및 피해보상보험 계약없이 (주)에스에스지닷컴의 신용으로 발행합니다."
        },
        {
            "type": "이용 가능 매장",
            "value": "이용 불가 매장 : 미군부대 매장, 워터파크 입점 매장 등 일부 매장"
        },
        {
            "type": "환불 방법",
            "value": "[최초 유효기간이내] 마이페이지 나의 주문내역상에서 환불 가능 혹은 1577-3419(에스에스지닷컴 고객센터)로 취소요청 / [최초 유효기간 경과 후] 1644-1133(SSGPAY 고객센터)로 환불요청"
        },
        {
            "type": "유효기간, 이용조건(유효기간 경과시 보상기준 포함)",
            "value": "해당 상품의 최초 유효기간은 1년(366)이며 유효기간 이내 쿠폰은 발급일로부터 5년 범위 내에서 92일 단위로 연장가능"
        },
        {
            "type": "발행자",
            "value": "(주)에스에스지닷컴"
        }
    ]
}
```

---

##  9. 특징 및 장점

| 항목 | 구현 |
|------|------|
| Cursor 방식 페이징 | UUID 기반 ID로 무한 스크롤 구현 |
| 상세 응답 조합 | Product + Option + Image + Detail + RequiredInfo |
| VO → DTO 변환 구조 | 유지보수 고려한 명확한 계층 분리 |

---

##  10. 포트폴리오 어필 포인트
- 무한스크롤, 상세 조회, 베스트 상품 등 전반적인 커머스 상품 기능 구현
- 실무에서 자주 쓰이는 DTO/VO 구조 분리와 유연한 확장성 확보

