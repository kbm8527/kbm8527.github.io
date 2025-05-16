---
layout: default
title: Java Basics
---

## 목차

### 🔗 [Java Basics](/study/basic-cs-and-programming/)

 ## Java 핵심 심화: 종합 학습서

### 1. 소개
Java는 클래스 기반의 객체지향 프로그래밍 언어로, 수십 년간 엔터프라이즈 소프트웨어 개발에서 중심적인 역할을 해왔습니다. 플랫폼 독립성, 강력한 메모리 관리, 풍부한 API를 제공하며 웹 애플리케이션부터 분산 시스템까지 다양한 개발 요구를 충족합니다.

---

### 2. Java 기본 문법과 구조

#### 2.1 변수와 자료형
Java는 **기본 타입**(int, float, boolean 등)과 **참조 타입**(배열, 클래스, 인터페이스)을 지원합니다. 기본 타입은 메모리에 직접 저장되고, 참조 타입은 데이터의 메모리 주소를 저장합니다.

#### 2.2 연산자
연산자는 다음과 같이 분류됩니다:
- 산술 연산자: +, -, *, /, %
- 관계 연산자: ==, !=, >, <
- 논리 연산자: &&, ||, !
- 비트 연산자: &, |, ^, ~

#### 2.3 제어 구조
- 조건문: `if`, `else`, `switch`
- 반복문: `for`, `while`, `do-while`
- 분기문: `break`, `continue`, `return`

---

### 3. Java의 객체지향 프로그래밍

#### 3.1 캡슐화
접근 제한자와 getter/setter를 통해 캡슐화를 구현하며 클래스 내부 정보를 외부에 숨깁니다.

#### 3.2 상속
Java는 단일 상속을 지원하며 `extends` 키워드를 통해 부모 클래스의 필드와 메서드를 상속받습니다.

#### 3.3 다형성
- 컴파일 시 다형성: 메서드 오버로딩
- 실행 시 다형성: 메서드 오버라이딩

#### 3.4 추상화
`abstract` 클래스와 `interface`를 통해 추상화를 구현하며, 구현과 정의를 분리합니다.

#### 3.5 SOLID 원칙
Java는 다음과 같은 SOLID 원칙을 따릅니다:
- SRP (단일 책임 원칙)
- OCP (개방-폐쇄 원칙)
- LSP (리스코프 치환 원칙)
- ISP (인터페이스 분리 원칙)
- DIP (의존성 역전 원칙)
SOLID 원칙 (객체지향 설계 5대 원칙)
1. SRP – Single Responsibility Principle
단일 책임 원칙
클래스는 단 하나의 책임만 가져야 하며, 오직 하나의 변경 이유만 가져야 한다.

 목적: 클래스가 너무 많은 책임을 갖지 않도록 모듈화를 강화.

❌ 위반 예시:

java
복사
편집
public class Report {
    public void generate() { ... } // 보고서 생성
    public void print() { ... }   // 출력 책임까지 가짐 (SRP 위반)
}
 개선:

java
복사
편집
public class ReportGenerator { public void generate() { ... } }
public class ReportPrinter { public void print(Report r) { ... } }
2. OCP – Open-Closed Principle
개방-폐쇄 원칙
소프트웨어 요소는 확장에 열려 있어야 하고, 변경에는 닫혀 있어야 한다.

 목적: 기존 코드를 변경하지 않고 새로운 기능을 확장할 수 있어야 한다.

 예시: 전략 패턴

java
복사
편집
public interface DiscountPolicy { int discount(int price); }
public class FixDiscount implements DiscountPolicy { ... }
public class RateDiscount implements DiscountPolicy { ... }
// 새로운 할인 정책 추가 시 기존 코드 수정 없이 확장만
3. LSP – Liskov Substitution Principle
리스코프 치환 원칙
서브타입은 언제나 자신의 기반 타입으로 교체할 수 있어야 한다.

 목적: 상속 관계에서 다형성 유지.

❌ 위반 예시:

java
복사
편집
class Bird { void fly(); }
class Ostrich extends Bird { void fly() { throw new UnsupportedOperationException(); } }
타조는 날 수 없는데 Bird로서 fly() 호출이 가능 → 설계 오류

 해결: FlyingBird, NonFlyingBird로 분리하여 상속

4. ISP – Interface Segregation Principle
인터페이스 분리 원칙
클라이언트는 자신이 사용하지 않는 인터페이스에 의존하지 않아야 한다.

 목적: 불필요한 의존성 제거, 인터페이스 세분화

❌ 위반 예시:

java
복사
편집
interface Worker {
    void work();
    void eat(); // 모든 Worker가 eat()을 가져야 할까?
}
 개선:

java
복사
편집
interface Workable { void work(); }
interface Eatable { void eat(); }
5. DIP – Dependency Inversion Principle
의존성 역전 원칙
고수준 모듈은 저수준 모듈에 의존하면 안 되며, 둘 다 추상화에 의존해야 한다.

 목적: 추상화에 의존 → 유연한 설계

❌ 위반 예시:

java
복사
편집
class Light { public void turnOn() { ... } }
class Switch { private Light light = new Light(); }
 개선:

java
복사
편집
interface Switchable { void turnOn(); }
class Light implements Switchable { ... }
class Switch { private Switchable device; }






---

### 4. Java 고급 문법과 API

#### 4.1 static 키워드
`static`은 클래스 레벨의 필드나 메서드를 정의하며, 모든 인스턴스에서 공유됩니다.

#### 4.2 예외 처리
Java는 체크 예외와 언체크 예외를 지원하며, `try-catch-finally` 또는 `throws`를 통해 처리합니다.

#### 4.3 제네릭
제네릭은 타입 안정성을 제공하며 명시적 형변환 없이 컬렉션을 다룰 수 있게 합니다.

#### 4.4 컬렉션 프레임워크
`List`, `Set`, `Map`, `Queue` 등을 포함하며, `Iterator`를 통해 반복 처리합니다.

#### 4.5 열거형과 중첩 클래스
열거형은 상수 집합을 정의하며, Java는 정적, 내부, 익명 클래스를 지원합니다.

---

### 5. Java 표준 라이브러리

#### 5.1 java.lang
`String`, `Object`, `Math`, `System` 등 자주 사용하는 클래스 포함

#### 5.2 java.util
`ArrayList`, `HashMap`, `Collections` 등의 자료구조 및 유틸리티 제공

#### 5.3 java.time
`LocalDate`, `Duration`, `DateTimeFormatter` 등 날짜 및 시간 API

#### 5.4 java.io와 java.nio
파일 입출력, 고성능 비동기 I/O 제공

---

### 6. 함수형 프로그래밍

#### 6.1 람다 표현식
Java 8 도입. 예: `(a, b) -> a + b`

#### 6.2 함수형 인터페이스
`@FunctionalInterface`로 표시하며, `Function`, `Consumer`, `Predicate` 등이 있음

#### 6.3 Stream API
`map`, `filter`, `reduce`, `collect` 등 선언적 컬렉션 처리 가능

#### 6.4 Optional
값의 유무를 표현하는 컨테이너 클래스

---

### 7. 병렬 프로그래밍과 멀티스레드

#### 7.1 Thread 기본
`Runnable`, `Thread`, `start()`, `join()` 등을 사용해 스레드 실행

#### 7.2 동기화
`synchronized`, `ReentrantLock`, `volatile` 등으로 경쟁 조건 방지

#### 7.3 Executor & Future
`ExecutorService`로 스레드 풀 관리, 비동기 작업 수행

#### 7.4 CompletableFuture
Java 8 도입, 비동기 작업 체이닝과 결과 처리 가능

---

### 8. JVM 내부 구조

#### 8.1 메모리 구조
- Heap
- Stack
- Method Area
- Native Method Stack

JVM 메모리 구조 용어 정리
1. Heap
객체가 저장되는 공간. 모든 클래스 인스턴스, 배열은 Heap에 저장됨.

GC(Garbage Collector)의 대상

new 키워드로 생성되는 모든 객체는 Heap에 저장됨

2. Stack
메서드 호출 시 사용되는 지역 변수, 매개변수, 호출 정보 저장 공간.

각 쓰레드는 자신만의 Stack을 가짐

LIFO 구조 (Last In First Out)

메서드가 끝나면 자동으로 할당 해제됨

3. Method Area (또는 MetaSpace in Java 8+)
클래스의 메타 정보 (static 변수, 메서드 정보 등)가 저장됨.

클래스 로딩 시 클래스 구조가 이곳에 저장됨

static 변수들도 여기에 위치

4. PC Register
각 쓰레드가 실행 중인 JVM 명령어 주소를 저장

명령어 단위로 어떤 작업을 수행해야 하는지 추적

5. Native Method Stack
C/C++로 작성된 native 메서드가 실행될 때 사용됨

예: System.gc() 같은 JVM 외부 메서드




#### 8.2 GC (Garbage Collection)
Serial, Parallel, CMS, G1, ZGC 등 다양한 수집기 지원

#### 8.3 클래스 로딩
클래스 로더 계층: Bootstrap, Extension, Application

#### 8.4 JIT 컴파일
실행 중 바이트코드를 네이티브 코드로 변환해 성능 최적화

---

### 9. 실무 활용

#### 9.1 빌드 도구
- Maven: 설정 기반
- Gradle: DSL 기반, 빠른 빌드

#### 9.2 테스트
- JUnit 5, AssertJ
- Mockito를 통한 Mock 객체 테스트

#### 9.3 로깅
- SLF4J + Logback, Log4j

#### 9.4 Spring Boot REST API 예제
```java
@RestController
@RequestMapping("/api")
public class SampleController {
  @GetMapping("/hello")
  public String hello() {
    return "Hello World!";
  }
}
```

---

### 10. 결론
이 문서는 Java의 기본 문법부터 고급 기능, 그리고 실무 적용까지 체계적으로 정리된 학습 자료입니다. 백엔드 개발, 시스템 프로그래밍, 고성능 컴퓨팅을 위한 기반 지식으로 적합합니다.

---

*추가 학습: Kotlin 연동, 리액티브 프로그래밍, GraalVM 네이티브 컴파일 등의 주제로 확장 가능합니다.*

+-

1. Java 리플렉션 (Reflection)
개념: 리플렉션은 런타임에 클래스의 구조를 조사하고 조작할 수 있는 기능을 제공합니다.​

예제 코드:

java
복사
편집
import java.lang.reflect.Method;

public class ReflectionExample {
    public void greet(String name) {
        System.out.println("Hello, " + name);
    }

    public static void main(String[] args) throws Exception {
        Class<?> clazz = Class.forName("ReflectionExample");
        Object obj = clazz.getDeclaredConstructor().newInstance();
        Method method = clazz.getMethod("greet", String.class);
        method.invoke(obj, "World");
    }
}
실습 자료: 자세한 리플렉션 예제는 Programiz의 Java Reflection 튜토리얼에서 확인하실 수 있습니다.​

🏷️ 2. 어노테이션 프로세서 (Annotation Processor)
개념: 컴파일 타임에 어노테이션을 분석하고, 코드를 생성하거나 검증하는 기능을 제공합니다.​

예제 코드:

java
복사
편집
// 커스텀 어노테이션 정의
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.SOURCE)
public @interface Builder {
}

// 어노테이션 프로세서 구현
@SupportedAnnotationTypes("Builder")
@SupportedSourceVersion(SourceVersion.RELEASE_8)
public class BuilderProcessor extends AbstractProcessor {
    @Override
    public boolean process(Set<? extends TypeElement> annotations, RoundEnvironment roundEnv) {
        // 코드 생성 로직
        return true;
    }
}
실습 자료: 어노테이션 프로세서에 대한 자세한 내용은 Baeldung의 튜토리얼을 참고하세요.​

⚙️ 3. 바이트코드 조작 (Bytecode Manipulation)
개념: 클래스의 바이트코드를 직접 수정하여 동작을 변경하는 기술입니다.​

예제 코드:

java
복사
편집
ClassReader classReader = new ClassReader("com.example.MyClass");
ClassWriter classWriter = new ClassWriter(classReader, 0);
ClassVisitor classVisitor = new MyClassVisitor(Opcodes.ASM9, classWriter);
classReader.accept(classVisitor, 0);
byte[] modifiedClass = classWriter.toByteArray();
실습 자료: ASM을 활용한 바이트코드 조작에 대한 자세한 내용은 Baeldung의 가이드를 참고하세요.​

🔗 4. Java 네이티브 인터페이스 (JNI)
개념: Java에서 C/C++로 작성된 네이티브 코드를 호출할 수 있는 기능입니다.​

예제 코드:

java
복사
편집
public class HelloJNI {
    static {
        System.loadLibrary("hello");
    }

    private native void sayHello();

    public static void main(String[] args) {
        new HelloJNI().sayHello();
    }
}
실습 자료: JNI에 대한 자세한 튜토리얼은 Baeldung의 가이드를 참고하세요.​

🧪 5. Java 에이전트 및 Instrumentation
개념: JVM의 클래스 로딩 과정에 개입하여 클래스의 바이트코드를 조작할 수 있는 기능입니다.​

예제 코드:

java
복사
편집
public class MyAgent {
    public static void premain(String agentArgs, Instrumentation inst) {
        System.out.println("Agent loaded before main");
    }
}
실습 자료: Java Instrumentation API에 대한 자세한 내용은 Baeldung의 튜토리얼을 참고하세요.​

📦 6. Java 모듈 시스템 (JPMS)
개념: Java 9에서 도입된 모듈 시스템으로, 애플리케이션을 모듈 단위로 구성하여 캡슐화와 의존성 관리를 강화합니다.​

예제 코드:

java
복사
편집
// module-info.java
module com.example.myapp {
    requires java.base;
    exports com.example.myapp;
}
실습 자료: Java 모듈 시스템에 대한 자세한 내용은 Baeldung의 가이드를 참고하세요.​

🔄 7. 리액티브 프로그래밍 (Reactive Programming)
개념: 데이터의 흐름과 변화에 반응하여 비동기적으로 처리하는 프로그래밍 패러다임입니다.​

예제 코드:

java
복사
편집
Flux<String> flux = Flux.just("A", "B", "C")
    .map(String::toLowerCase)
    .filter(s -> s.equals("b"));

flux.subscribe(System.out::println);
실습 자료: 리액티브 프로그래밍에 대한 자세한 내용은 Project Reactor의 공식 문서를 참고하세요.​

⚡ 8. GraalVM과 Native Image
개념: GraalVM은 다양한 언어를 지원하는 고성능 런타임으로, Java 애플리케이션을 네이티브 바이너리로 컴파일할 수 있는 기능을 제공합니다.​

예제 코드:

java
복사
편집
public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello, Native World!");
    }
}
실습 자료: GraalVM을 활용한 네이티브 이미지 생성에 대한 자세한 내용은 GraalVM의 공식 문서를 참고하세요.​

🤖 9. Java와 머신러닝
개념: Java에서도 머신러닝 모델을 구축하고 활용할 수 있는 라이브러리들이 존재합니다.​

예제 코드:

java
복사
편집
MultiLayerConfiguration config = new NeuralNetConfiguration.Builder()
    .list()
    .layer(0, new DenseLayer.Builder().nIn(4).nOut(3).build())
    .layer(1, new OutputLayer.Builder().nIn(3).nOut(1).build())
    .build();
실습 자료: Deeplearning4j를 활용한 머신러닝 예제는 Baeldung의 가이드를 참고하세요.​

🔐 10. Java 보안
개념: Java에서 제공하는 보안 기능을 활용하여 애플리케이션의 보안을 강화할 수 있습니다.​

예제 코드:

java
복사
편집
KeyGenerator keyGen = KeyGenerator.getInstance("AES");
keyGen.init(256);
SecretKey secretKey = keyGen.generateKey();

Cipher cipher = Cipher.getInstance("AES");
cipher.init(Cipher.ENCRYPT_MODE, secretKey);
byte[] encrypted = cipher.doFinal("Hello".getBytes());
실습 자료: AES 암호화에 대한 자세한 내용은 Baeldung의 튜토리얼을 참고하세요.


---

[🔙 Back to Portfolio Main](../index.md)

---
