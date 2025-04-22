
---
layout: default
title: 배너 이미지 기능
---

# 🖼️ 배너 이미지 (Banner Image) 기능

##  1. 기능 개요
- **기능 명칭**: 배너 이미지(Banner Image) 관리
- **설명**: 메인 페이지 상단에 노출되는 배너 이미지를 등록/수정/삭제/조회하는 기능
- **기술 스택**: Spring Boot, JPA, AWS S3, MultipartFile, UUID, @ControllerAdvice

---

##  2. 구현 목적 및 요구사항
- 배너 이미지를 백엔드에서 등록하고, 프론트는 해당 이미지를 메인에 노출
- 클릭 가능한 배너: 이미지와 함께 링크(추후 확장 예정)
- 단일/다중 이미지 등록 모두 가능
- 이미지 삭제 시 실제 S3에서 삭제 처리
- soft delete 기반 데이터 관리 (`activated = false`)

---

##  3. API 명세 (일부)

| HTTP | URL | 설명 |
|------|-----|------|
| POST | /api/v1/banner/single | 단일 배너 등록 (이미지 + JSON) |
| POST | /api/v1/banner/multi | 다중 배너 등록 |
| GET | /api/v1/banner/all | 전체 배너 조회 |
| PUT | /api/v1/banner | 배너 수정 |
| DELETE | /api/v1/banner?bannerId=xxx | 배너 삭제 |

---

##  4. 배너 도메인 구조 (Entity)
```java
@Entity
@Getter
@NoArgsConstructor
public class Banner extends BaseEntity {

    @Id
    @UuidGenerator
    @Column(updatable = false, nullable = false, columnDefinition = "BINARY(16)")
    private UUID bannerId;

    @Column(nullable = false)
    private String imageBannerUrl;

    @Column(nullable = false)
    private String imageBannerAlt;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    @Column(nullable = false)
    private LocalDate postedAt; // 배너 게시일

    @Column(nullable = false)
    private Boolean activated;  // 배너 상태


    @Builder
    public Banner(String imageBannerUrl, String imageBannerAlt, LocalDate postedAt, boolean activated) {
        this.imageBannerUrl = imageBannerUrl;
        this.imageBannerAlt = imageBannerAlt;
        this.postedAt = postedAt;
        this.activated = activated;
    }

    public void updateImage(String newImageUrl) {
        this.imageBannerUrl = newImageUrl;
    }

    public void updateInfo(UpdateBannerImageRequestDto updateBannerImageRequestDto) {
        this.imageBannerAlt = updateBannerImageRequestDto.getImageBannerAlt();
        this.postedAt = updateBannerImageRequestDto.getPostedAt();
        this.activated = updateBannerImageRequestDto.isActivated();
    }

    public void softDelete() {
        this.activated = false;
    }
}
```

---

##  5. 주요 비즈니스 로직 (ServiceImpl)

### ⬆️ 단일 배너 업로드

```java
    @Override
    public UUID uploadBanner(MultipartFile image, AddBannerImageRequestDto addBannerImageRequestDto) {
        if (image == null || image.isEmpty()) {
            throw new BaseException(S3_EMPTY_FILE_NAME);
        }

        String imageUrl = s3Uploader.upload(image, FOLDER_NAME);
        Banner banner = buildBanner(imageUrl, addBannerImageRequestDto);

        return bannerImageRepository.save(banner).getBannerId();
    }
```

### 🛠️ 배너 수정

```java
 @Override
    public void updateBannerImage(UUID bannerId, MultipartFile image, UpdateBannerImageRequestDto updateBannerImageRequestDto) {
        Banner banner = bannerImageRepository.findById(bannerId)
                .orElseThrow(() -> new BaseException(NO_EXIST_BANNER));

        if (image != null && !image.isEmpty()) {

            log.info("Updating banner image for bannerId: {}", bannerId);
            String updatedUrl = s3Uploader.upload(image, FOLDER_NAME);
            banner.updateImage(updatedUrl);
        }

        banner.updateInfo(updateBannerImageRequestDto);
    }

```

### 🗑️ 삭제 (Soft Delete + 실제 S3 삭제)

```java
 @Override
    @Transactional
    public void deleteBannerImage(UUID bannerId) {
        Banner banner = bannerImageRepository.findById(bannerId)
                .orElseThrow(() -> new BaseException(NO_EXIST_BANNER));

        if (banner.getImageBannerUrl() != null) {
            s3Uploader.deleteFile(banner.getImageBannerUrl());
        }

        banner.softDelete();
    }
```

---

##  6. 컨트롤러 주요 포인트
```java
- `@RequestPart` 로 Multipart + JSON 동시 수신
- `ObjectMapper`로 JSON 문자열 → VO 수동 매핑
- Swagger 연동 (`@Operation` 활용)

   @Operation(summary = "단일 배너 등록", description = "단일 배너 이미지를 등록합니다.", tags = {"banner-image"})
    @PostMapping("/single")
    public UUID uploadBanner(
            @RequestPart("image") MultipartFile image,
            @RequestPart("addBannerImageRequestVo") String json
    ) throws JsonProcessingException {

        // JSON 문자열 → VO 객체 수동 변환
        AddBannerImageRequestVo addBannerImageRequestVo = objectMapper.readValue(json, AddBannerImageRequestVo.class);

        return bannerImageService.uploadBanner(image, AddBannerImageRequestDto.from(addBannerImageRequestVo));
    }

---

##  7. 특징 및 장점

| 항목 | 구현 |
|------|------|
| S3 이미지 업로드 | S3Uploader.upload() 사용 |
| 이미지 삭제 처리 | 실제 삭제 + soft delete |
| 다중 업로드 지원 | MultipartFile List 처리 |
| JSON + 이미지 통합 수신 | @RequestPart + ObjectMapper |
| 예외 처리 | @ControllerAdvice + BaseException |
| 응답 DTO | BannerImageResponseDto.from(Banner) 사용 |

---

##  8. 응답 DTO 예시

```json
  {
        "bannerId": "055fae6b-fb89-4093-a14a-5aaa15adfb1b",
        "imageBannerUrl": "https://starvive-assets.s3.ap-northeast-2.amazonaws.com/banner/4b593aad-4f31-42f0-922d-0c9dcf56b474.jpg",
        "imageBannerAlt": "Flower Market",
        "postedAt": "2025-03-20",
        "activated": true
    }
```

---

##  9. 포트폴리오 어필 포인트
- 실무와 유사한 구조: S3 연동, Multipart 처리
- 유지보수 고려한 구조 분리: VO-DTO, 예외 공통 처리
- 확장성: 단일/다중 업로드, soft delete 방식
