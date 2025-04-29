---
layout: default
title: Password Encryption
---

## 목차

### 🔗 [Password Encryption](/study/authentication-and-security/)

🛡 Password Encryption (비밀번호 암호화) 완전 정복
1. Password Encryption이란?
비밀번호 암호화란,
사용자가 입력한 비밀번호를 변환된 형태로 안전하게 보관하는 것을 말합니다.

📌 왜 필요한가?
해킹, 데이터 유출 사고 발생 시 원본 비밀번호 노출 방지.

데이터베이스 유출 사고가 나더라도, 해커가 바로 사용할 수 없게 한다.

📌 실제 사례
2012년 LinkedIn 해킹 → 1억 1천만 개 비밀번호 평문 저장 → 대규모 유출 발생

이후 비밀번호 평문 저장은 심각한 보안 위반으로 간주.

2. 단순한 암호화 vs 해시(Hashing)

암호화 (Encryption)	해시 (Hashing)
복호화 가능	복호화 불가
대칭키, 비대칭키 사용	고정된 출력값 생성
복호화해서 원문 복원 가능	원문 복원이 원칙적으로 불가능
데이터 전송 보호(HTTPS 등)	비밀번호 저장, 무결성 검증
 비밀번호는 "복호화할 필요가 없기 때문에 반드시 해시해야 한다."

3. 비밀번호 저장 기본 전략
해시(Hashing): 입력 비밀번호를 해시 함수로 변환해 저장

솔트(Salt) 추가: 사용자별 무작위 문자열 추가 → rainbow table 공격 방지

스트레칭(Stretching): 해시 연산 반복 → 계산량 증가 → 브루트포스 방어

페퍼(Pepper): 서버에만 저장된 비밀 키를 추가해 이중 보안 강화

4. 해시 함수 종류

알고리즘	특징
SHA-256, SHA-512	너무 빠름 → 비밀번호 용으로 부적합
bcrypt	Blowfish 기반, salt 자동 추가, cost 조정 가능
PBKDF2	표준화, 반복 계산 기반
scrypt	CPU + 메모리 소모, 클라우드 공격에 강함
Argon2	최신, 메모리 조정 가능, 보안성 최고
5. bcrypt 알고리즘 자세히
Blowfish 기반

Salt 자동 생성

Cost Factor로 연산 난이도 조정 가능
(cost=12이면 2¹²번 해시 연산)

📌 bcrypt 문자열 구조
perl
복사
편집
$2a$12$SaltsaltSaltsaltS...$hashedPassword
[버전][cost][salt][해시값]
6. Password Encryption 실전 예제
6.1 Spring Security (Java)
java
복사
편집
BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
String encodedPassword = encoder.encode("plainPassword");
boolean matches = encoder.matches("plainPassword", encodedPassword);
6.2 Node.js (Express)
javascript
복사
편집
const bcrypt = require('bcrypt');
const hash = await bcrypt.hash('plainPassword', 12);
const isMatch = await bcrypt.compare('plainPassword', hash);
6.3 Django (Python)
python
복사
편집
from django.contrib.auth.hashers import make_password, check_password

hashed = make_password('plainPassword')
is_correct = check_password('plainPassword', hashed)
7. 심화 보안 최적화
7.1 솔트(Salt)
사용자별 랜덤 문자열 추가

rainbow table 공격 무력화

bcrypt는 자동으로 Salt 포함

7.2 페퍼(Pepper)
시스템 전역 비밀 문자열 추가

서버의 ENV 파일이나 KMS에 저장

DB에 저장하지 않는다.

java
복사
편집
String pepper = System.getenv("PEPPER_KEY");
String passwordWithPepper = rawPassword + pepper;
String encoded = passwordEncoder.encode(passwordWithPepper);
7.3 스트레칭(Stretching)
해시 연산을 수천 번 반복

bcrypt는 내부적으로 stretching 포함

cost factor를 높이면 해시 생성 시간 증가 → 보안성 강화

🔥 추가 심화 통합
8. bcrypt vs Argon2 성능 비교

항목	bcrypt	Argon2
기반	Blowfish 암호화	메모리 강화형 해시
저항성	CPU 공격에 강함	CPU + 메모리 공격 모두 방어
조정 가능성	cost factor만 조정	시간, 메모리, 병렬성 모두 조정 가능
특징	느려서 브루트포스 방어 가능	현대 공격(메모리 공격 등)에 최적
추천 사용처	일반적인 웹 인증	고보안 시스템(금융, 암호화폐 등)
 정리

웹 백엔드는 여전히 bcrypt

고보안이 필요하면 Argon2 추천

9. 비밀번호 해시 마이그레이션 전략
문제 상황

기존 시스템이 bcrypt(cost=10)로 저장했는데, 보안을 강화하고 싶을 때.

해결 방법

사용자가 로그인할 때 기존 비밀번호를 새로운 cost로 재암호화

java
복사
편집
if (passwordEncoder.upgradeEncoding(existingHash)) {
    String newHash = passwordEncoder.encode(rawPassword);
    userService.updatePassword(userId, newHash);
}
upgradeEncoding()을 통해 현재 해시 기준이 낮으면 새로운 해시로 교체

장점

사용자 체감 변화 없음

서비스 중단 없이 보안 강화

10. 페퍼 키 관리 전략
페퍼(Pepper) 사용 시 주의사항

코드를 통해 System.getenv("PEPPER_KEY") 등으로 관리

KMS(AWS Key Management Service)나 Vault를 통해 키 보관

페퍼 키 유출 시 심각한 사고 → 운영 서버 외부에 노출 금지

만약 페퍼 키 변경이 필요하면?

주기적으로 모든 사용자 비밀번호 재해시 필요

🛡 최종 요약

항목	필수 체크
비밀번호 평문 저장 절대 금지	해시 + salt
해시 알고리즘	bcrypt (기본), argon2 (고보안)
cost factor 관리	bcrypt 12 이상 권장
페퍼 적용	추가적 보안 강화
마이그레이션 대비	해시 강화 가능성 대비
로그인 실패 제한	브루트포스 방어


11. Salt, Pepper, Stretching 관계 시각화
비밀번호 보안을 높이는 주요 3요소는 서로 다릅니다. 헷갈리기 쉬우니까 명확히 구분합니다.


요소	설명	목적
Salt (솔트)	각 사용자별 랜덤 문자열 추가	Rainbow Table 공격 방어
Pepper (페퍼)	시스템 비밀 문자열 추가	추가적인 이중 보호
Stretching (스트레칭)	반복 해시 연산	브루트포스 공격 시간 증가
🔵 전체 흐름

plaintext
복사
편집
1. 입력 비밀번호 (raw password)
    ↓
2. Pepper 추가 (비밀 키 추가) → [raw password + pepper]
    ↓
3. Salt 추가 (개인 랜덤값 추가) → [raw password + pepper + salt]
    ↓
4. Stretching (여러번 반복 해시) → [최종 해시값]
    ↓
5. 데이터베이스 저장
 핵심 요약

Pepper: 시스템 수준 보안 (서버에만 저장)

Salt: 사용자마다 다르게 (DB 저장 가능)

Stretching: 계산 시간 증가 (느려지게 해서 공격 어렵게)

12. bcrypt 내부 동작 (Blowfish 기반)
bcrypt는 단순히 해시 함수가 아닙니다.
내부적으로 Blowfish 블록 암호화 알고리즘을 변형하여 사용합니다.

📌 주요 동작
입력 비밀번호 + salt를 조합

Blowfish key setup 과정을 수백 번 반복 (cost factor)

최종적으로 192비트 고정된 해시값 생성

📌 구조 예시
plaintext
복사
편집
$2a$12$saltstring......$encryptedpassword
  |  |   |
  |  |   +-- salt 22자 (Base64)
  |  +------ cost factor (2^12 = 4096번 연산)
  +--------- bcrypt 버전
 특징

cost factor를 높이면 → 계산량 지수적으로 증가

rainbow table 무력화 (salt 자동 적용)

메모리 사용량이 작음 (CPU 위주 공격 방어)

13. Spring Security PasswordEncoder 커스터마이징
실제 실무에서는 PasswordEncoder를 강화하거나 복합적으로 적용하기도 합니다.

📌 기본 사용법
java
복사
편집
@Bean
public PasswordEncoder passwordEncoder() {
    return new BCryptPasswordEncoder(12); // cost factor 12
}
📌 Pepper 적용 커스터마이징 예시
비밀번호에 Pepper를 적용해서 인코딩하기

java
복사
편집
@Component
public class CustomPasswordEncoder implements PasswordEncoder {

    private final BCryptPasswordEncoder bCryptPasswordEncoder = new BCryptPasswordEncoder();
    private final String pepper = System.getenv("PEPPER_KEY"); // 환경변수로 관리

    @Override
    public String encode(CharSequence rawPassword) {
        return bCryptPasswordEncoder.encode(rawPassword + pepper);
    }

    @Override
    public boolean matches(CharSequence rawPassword, String encodedPassword) {
        return bCryptPasswordEncoder.matches(rawPassword + pepper, encodedPassword);
    }
}
사용 등록

java
복사
편집
@Bean
public PasswordEncoder passwordEncoder() {
    return new CustomPasswordEncoder();
}
 즉시 페퍼 적용
 개별 사용자 코드 수정 필요 없음

14. 추가 실무 보안 패턴
📌 Password 정책 강화

항목	권장
최소 길이	12자 이상
조합	대문자+소문자+숫자+특수문자
금지사항	아이디/전화번호/반복문자 금지
변경 주기	최소 6개월 이내 권장
이전 비밀번호 사용 금지	최근 3개 이상 금지
📌 공격 방어 (Brute Force 대응)
로그인 실패 횟수 5회 → 계정 일시 잠금

일정 시간 이상 로그인 시도 지연

CAPTCHA 적용

IP 차단 정책 도입

📌 마이그레이션 적용 전략
기존 bcrypt(cost 10) 사용 → 로그인 성공 시 bcrypt(cost 12)로 갱신

Argon2로 마이그레이션 시도 시에도, 로그인 성공 시점에만 변경 (서비스 중단 없음)



---
[🔙 Back to Portfolio Main](../index.md)

---

