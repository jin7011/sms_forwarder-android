# CLAUDE.md - Empty Flutter Template 프로젝트

## 📱 **프로젝트 개요**

**Empty Flutter Template**은 Android 멀티모듈 템플릿 프로젝트를 Flutter로 완벽히 포팅한 베이스 템플릿입니다. 
상용 앱 개발에 필요한 모든 기본 기능과 아키텍처가 구현되어 있습니다.

### 🎯 **프로젝트 목표**
- Android 멀티모듈 아키텍처의 Flutter 포팅
- 상용 앱 개발을 위한 완전한 베이스 템플릿 제공
- 확장 가능하고 유지보수 가능한 코드 구조

---

## 🏗️ **아키텍처 및 프로젝트 구조**

### **멀티모듈 아키텍처**
```
lib/
├── 🔧 core/                      # 핵심 공통 모듈
│   ├── 📢 ads/                   # 광고 시스템
│   ├── 🔗 common/                # 공통 기능
│   │   ├── di/                   # 의존성 주입
│   │   ├── network/              # 네트워크 디스패처
│   │   └── result/               # Result 패턴
│   ├── 🎨 designsystem/          # 디자인 시스템
│   ├── 📊 data/                  # 데이터 레이어
│   ├── 🗄️ database/              # 로컬 데이터베이스
│   ├── 💾 datastore/             # 설정 저장소
│   ├── 🏛️ domain/                # 비즈니스 로직
│   ├── 📋 model/                 # 데이터 모델
│   ├── 🌐 network/               # HTTP 클라이언트
│   ├── 🧭 router/                # 라우팅 시스템
│   ├── 🎭 ui/                    # 공통 UI 컴포넌트
│   └── 🛠️ util/                  # 유틸리티
├── 🚀 features/                  # 기능별 모듈
│   ├── 🏠 main/                  # 메인 화면
│   └── 📋 exampleview/           # 예제 화면들
└── 🌍 shared/                    # 공유 리소스
    ├── constants/
    ├── extensions/
    └── utils/
```

### **레이어 구조**
- **Presentation Layer**: UI + ViewModel (BLoC)
- **Domain Layer**: UseCase + Repository Interface
- **Data Layer**: Repository Implementation + DataSource

---

## 📚 **라이브러리 및 의존성**

### **🏗️ 상태관리 & 의존성 주입**
```yaml
flutter_bloc: ^8.1.6              # BLoC 패턴 상태관리 (Android MVVM + LiveData 대응)
get_it: ^8.0.2                    # 서비스 로케이터 패턴 의존성 주입 컨테이너
injectable: ^2.5.0                # get_it을 위한 어노테이션 기반 의존성 주입 (Android Hilt 대응)
```

### **🌐 네트워킹 & HTTP**
```yaml
dio: ^5.7.0                       # 강력한 HTTP 클라이언트 (Android OkHttp 대응)
retrofit: ^4.4.1                  # RESTful API 클라이언트 생성기 (Android Retrofit 대응)
json_annotation: ^4.9.0           # JSON 직렬화를 위한 어노테이션 정의
connectivity_plus: ^6.1.0         # 네트워크 연결 상태 확인 (Android ConnectivityManager 대응)
```

### **🔥 Firebase & 광고**
```yaml
firebase_core: ^3.8.0             # Firebase 핵심 기능 초기화
firebase_analytics: ^11.3.4       # Firebase Analytics 사용자 행동 분석
firebase_crashlytics: ^4.1.4      # Firebase Crashlytics 앱 충돌 보고
google_mobile_ads: ^5.3.0         # Google AdMob 광고 SDK (배너/전면/보상형 광고)
```

### **🧭 라우팅 & UI**
```yaml
go_router: ^14.8.0                # 선언적 라우팅 시스템 (Android Navigation Component 대응)
material_color_utilities: ^0.11.1 # Google Material Design 컬러 유틸리티
cached_network_image: ^3.4.1      # 네트워크 이미지 캐싱 및 로딩 (Android Coil/Glide 대응)
```

### **🗄️ 데이터 저장**
```yaml
hive: ^2.2.3                      # 빠른 NoSQL 데이터베이스 (Android Room 대응)
hive_flutter: ^1.1.0              # Hive의 Flutter 특화 확장
shared_preferences: ^2.3.5        # 간단한 키-값 저장소 (Android SharedPreferences 대응)
```

### **🛠️ 개발 도구**
```yaml
build_runner: ^2.4.13             # Dart 코드 생성 실행기 (어노테이션 기반 코드 생성)
json_serializable: ^6.8.0         # JSON 직렬화 코드 자동 생성 (fromJson/toJson)
injectable_generator: ^2.6.2      # Injectable 어노테이션으로 의존성 주입 코드 자동 생성
retrofit_generator: ^9.1.4        # Retrofit 어노테이션으로 HTTP 클라이언트 코드 자동 생성
freezed: ^2.5.7                   # 불변 클래스, union 타입, copyWith 메서드 자동 생성
```

---

## 🎨 **디자인 시스템**

### **컬러 팔레트**
```dart
// Light Theme Colors
static const Color purple40 = Color(0xFF6650a4);     // Primary
static const Color purpleGrey40 = Color(0xFF625b71);  // Secondary
static const Color pink40 = Color(0xFF7D5260);        // Tertiary

// Dark Theme Colors
static const Color purple80 = Color(0xFFD0BCFF);      // Primary
static const Color purpleGrey80 = Color(0xFFCCC2DC);  // Secondary
static const Color pink80 = Color(0xFFEFB8C8);        // Tertiary
```

### **타이포그래피**
```dart
// Material 3 Typography 기반
bodyLarge: TextStyle(
  fontFamily: 'Roboto',
  fontWeight: FontWeight.normal,
  fontSize: 16.0,
  height: 1.5,
  letterSpacing: 0.5,
)
```

### **테마 시스템**
- Material 3 기반 Light/Dark 테마
- 시스템 설정 자동 감지
- 동적 색상 지원 (Android 12+)

---

## 🔧 **코딩 스타일 & 컨벤션**

### **파일 네이밍**
- **snake_case**: 파일명, 디렉토리명
  ```
  ✅ main_screen.dart
  ✅ user_repository.dart
  ❌ MainScreen.dart
  ❌ UserRepository.dart
  ```

### **클래스 네이밍**
- **PascalCase**: 클래스명, 인터페이스명
  ```dart
  ✅ class MainViewModel extends Cubit<MainState>
  ✅ abstract class UserRepository
  ❌ class mainViewModel
  ```

### **변수 & 함수 네이밍**
- **camelCase**: 변수명, 함수명, 프로퍼티명
  ```dart
  ✅ final String userName;
  ✅ void fetchUserData() {}
  ❌ final String user_name;
  ❌ void FetchUserData() {}
  ```

### **상수 네이밍**
- **SCREAMING_SNAKE_CASE**: 상수명
  ```dart
  ✅ static const String API_BASE_URL = 'https://api.example.com';
  ✅ static const int MAX_RETRY_COUNT = 3;
  ```

### **디렉토리 구조 컨벤션**
```
feature_name/
├── data/                # 데이터 레이어
│   ├── datasources/     # 외부 데이터 소스 (API, DB)
│   ├── models/          # 데이터 모델
│   └── repositories/    # 저장소 구현
├── domain/              # 도메인 레이어
│   ├── entities/        # 비즈니스 엔티티
│   ├── repositories/    # 저장소 인터페이스
│   └── usecases/        # 사용 사례
└── presentation/        # 프레젠테이션 레이어
    ├── blocs/           # 상태 관리
    ├── pages/           # 화면
    └── widgets/         # UI 컴포넌트
```

---

## 🔍 **코드 품질 관리**

### **Linting 규칙**
```yaml
# flutter_lints ^5.0.0 사용
include: package:flutter_lints/flutter.yaml

# 추가 규칙
linter:
  rules:
    prefer_const_constructors: true
    prefer_const_literals_to_create_immutables: true
    avoid_print: true
    prefer_single_quotes: true
```

### **코드 생성 명령어**
```bash
# 의존성 설치
flutter pub get

# 코드 생성 (JSON, Injectable, Retrofit 등)
flutter packages pub run build_runner build --delete-conflicting-outputs

# 코드 분석
flutter analyze

# 테스트 실행
flutter test

# 포맷팅
dart format .
```

### **Git Hooks (권장)**
```bash
# pre-commit hook 설정
#!/bin/sh
flutter analyze
if [ $? -ne 0 ]; then
  echo "Flutter analyze failed"
  exit 1
fi

flutter test
if [ $? -ne 0 ]; then
  echo "Flutter tests failed"
  exit 1
fi
```

---

## 🌐 **API 호출 패턴**

### **NetworkDataSource 사용**
```dart
@RestApi()
abstract class UserApiDataSource {
  @factoryMethod
  factory UserApiDataSource(Dio dio) = _UserApiDataSource;
  
  @GET('/users/{id}')
  Future<UserDto> getUser(@Path('id') String userId);
  
  @POST('/users')
  Future<UserDto> createUser(@Body() CreateUserRequest request);
}
```

### **Repository 패턴**
```dart
@injectable
class UserRepository {
  final UserApiDataSource _apiDataSource;
  final UserLocalDataSource _localDataSource;
  
  UserRepository(this._apiDataSource, this._localDataSource);
  
  Future<Result<User>> getUser(String userId) async {
    try {
      final userDto = await _apiDataSource.getUser(userId);
      final user = userDto.toEntity();
      await _localDataSource.saveUser(user);
      return Result.success(user);
    } catch (e) {
      return Result.error(e.toString());
    }
  }
}
```

### **BLoC 상태 관리**
```dart
@injectable
class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;
  
  UserBloc(this._userRepository) : super(const UserState.initial()) {
    on<LoadUser>(_onLoadUser);
  }
  
  Future<void> _onLoadUser(LoadUser event, Emitter<UserState> emit) async {
    emit(const UserState.loading());
    final result = await _userRepository.getUser(event.userId);
    
    result.when(
      success: (user) => emit(UserState.loaded(user)),
      error: (message) => emit(UserState.error(message)),
      loading: () => emit(const UserState.loading()),
    );
  }
}
```

---

## 📱 **플랫폼별 설정**

### **Android 설정**
- **minSdkVersion**: 26 (Android 8.0)
- **targetSdkVersion**: 35 (Android 15)
- **NDK Version**: 27.0.12077973
- **Firebase 지원**: 완전 지원
- **AdMob 지원**: 완전 지원

### **iOS 설정**
- **iOS Deployment Target**: 12.0
- **Firebase 지원**: 완전 지원 (설정 필요)
- **AdMob 지원**: 완전 지원 (설정 필요)

### **Web 설정**
- **Firebase 지원**: 제한적 (Analytics, Auth)
- **AdMob 지원**: 미지원 (정상적인 동작)

---

## 🚫 **절대 하면 안 되는 것들**

### **🔒 보안 관련**
```dart
❌ API 키나 비밀번호를 코드에 하드코딩
// 절대 이렇게 하지 마세요!
const String API_KEY = "sk-1234567890abcdef";

✅ 환경변수나 보안 저장소 사용
const String API_KEY = String.fromEnvironment('API_KEY');
```

### **📂 파일 구조**
```
❌ lib/screens/all_screens_here.dart
❌ lib/utils/everything_util.dart
❌ lib/widgets/giant_widget.dart

✅ 모듈별 분리된 구조 유지
✅ 단일 책임 원칙 준수
✅ 적절한 파일 분할
```

### **🎨 UI/UX**
```dart
❌ 하드코딩된 색상값 사용
Container(color: Color(0xFF123456))

✅ 디자인 시스템 색상 사용
Container(color: Theme.of(context).colorScheme.primary)

❌ 직접적인 픽셀값 사용
Container(width: 320, height: 568)

✅ 반응형 디자인 적용
Container(
  width: MediaQuery.of(context).size.width * 0.8,
  height: MediaQuery.of(context).size.height * 0.3,
)
```

### **📊 상태 관리**
```dart
❌ StatefulWidget에서 복잡한 비즈니스 로직 처리
❌ setState()로 전역 상태 관리
❌ BLoC 없이 직접 API 호출

✅ BLoC 패턴을 통한 상태 관리
✅ Repository 패턴을 통한 데이터 처리
✅ 적절한 관심사 분리
```

### **🌐 네트워킹**
```dart
❌ 직접적인 HTTP 호출
http.get('https://api.example.com/users')

❌ 에러 처리 없는 API 호출
❌ 타임아웃 설정 없는 네트워크 요청

✅ Dio + Retrofit 패턴 사용
✅ 적절한 에러 처리 및 타임아웃 설정
✅ 네트워크 연결 상태 확인
```

### **🗃️ 데이터베이스**
```dart
❌ UI에서 직접 데이터베이스 접근
❌ 메인 스레드에서 무거운 DB 작업
❌ 트랜잭션 없는 복잡한 DB 작업

✅ Repository 패턴을 통한 데이터 접근
✅ 비동기 처리 및 격리 사용
✅ 적절한 트랜잭션 관리
```

### **🔧 의존성 관리**
```dart
❌ Singleton 패턴 남용
❌ 전역 변수 사용
❌ 순환 의존성 생성

✅ 의존성 주입 컨테이너 사용
✅ 인터페이스 기반 설계
✅ 느슨한 결합 유지
```

### **📱 플랫폼별 주의사항**
```dart
❌ Platform.isAndroid 체크 없이 Android 전용 코드 사용
❌ iOS에서 지원하지 않는 권한 요청
❌ 웹에서 지원하지 않는 네이티브 기능 호출

✅ 플랫폼별 분기 처리
✅ 플랫폼별 대체 방안 준비
✅ 각 플랫폼의 제약사항 고려
```

### **🧪 테스트**
```dart
❌ 테스트 없는 중요 비즈니스 로직
❌ 네트워크 의존적인 테스트
❌ UI 테스트에서 실제 데이터 사용

✅ 단위 테스트로 비즈니스 로직 검증
✅ 목업 데이터를 통한 독립적인 테스트
✅ 위젯 테스트로 UI 동작 검증
```

### **📋 버전 관리**
```
❌ 생성된 파일들을 Git에 커밋 (.g.dart, .config.dart)
❌ 빌드 폴더를 Git에 커밋
❌ 개인 설정 파일 커밋 (local.properties, *.iml)

✅ .gitignore 파일 제대로 설정
✅ 생성된 코드는 빌드 시점에 생성
✅ 환경별 설정 파일 분리
```

### **📈 성능**
```dart
❌ ListView에서 itemBuilder 없이 모든 아이템 생성
❌ 불필요한 setState() 호출
❌ 메모리 누수 유발하는 리스너 해제 안함

✅ ListView.builder 사용
✅ 필요한 경우에만 상태 업데이트
✅ dispose에서 리소스 정리
```

---

## 🛠️ **개발 워크플로우**

### **새로운 기능 추가**
1. **feature/기능명** 브랜치 생성
2. 도메인 엔티티 정의
3. 데이터 모델 및 API 정의
4. Repository 구현
5. UseCase 구현
6. BLoC 상태 관리 구현
7. UI 화면 구현
8. 테스트 작성
9. 코드 리뷰 후 병합

### **코드 생성 순서**
```bash
# 1. 모델 클래스 작성 후
flutter packages pub run build_runner build

# 2. 의존성 주입 어노테이션 추가 후
flutter packages pub run build_runner build

# 3. API 인터페이스 정의 후
flutter packages pub run build_runner build
```

### **테스트 전략**
- **Unit Test**: Repository, UseCase, BLoC
- **Widget Test**: 개별 UI 컴포넌트
- **Integration Test**: 전체 기능 플로우

---

## 🚀 **배포 및 빌드**

### **개발 환경**
```bash
flutter run -d chrome        # 웹 개발
flutter run -d emulator-5554 # Android 에뮬레이터
```

### **프로덕션 빌드**
```bash
# Android APK
flutter build apk --release

# Android AAB (Play Store)
flutter build appbundle --release

# iOS (Xcode 필요)
flutter build ios --release

# Web
flutter build web --release
```

---

## 📝 **추가 설정 사항**

### **필수 설정**
1. **Firebase 프로젝트 생성** 및 `firebase_options.dart` 업데이트
2. **AdMob 계정 생성** 및 광고 단위 ID 교체
3. **패키지명 변경** (`com.empty.empty_flutter` → 실제 패키지명)
4. **앱 아이콘 및 스플래시 스크린** 교체

### **권한 설정** (Android)
```xml
<!-- 기본 권한 -->
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />

<!-- 위치 권한 -->
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />

<!-- 광고 관련 권한 -->
<uses-permission android:name="com.google.android.gms.permission.AD_ID" />
```

---

## 🔍 **트러블슈팅**

### **자주 발생하는 문제**

1. **NDK 버전 오류**
   ```
   해결: android/app/build.gradle.kts에서 ndkVersion = "27.0.12077973" 설정
   ```

2. **코드 생성 오류**
   ```bash
   flutter packages pub run build_runner clean
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

3. **의존성 충돌**
   ```bash
   flutter pub deps
   flutter pub upgrade --major-versions
   ```

4. **Firebase 초기화 오류**
   ```
   해결: firebase_options.dart 파일 확인 및 Firebase 프로젝트 설정 검토
   ```

---

## 📞 **지원 및 문의**

이 템플릿은 상용 프로젝트 개발을 위한 완전한 베이스를 제공합니다. 
추가 기능이나 커스터마이징이 필요한 경우, 기존 패턴을 따라 확장하시면 됩니다.

**주요 특징**:
- ✅ 프로덕션 레디
- ✅ 확장 가능한 아키텍처
- ✅ 완전한 테스트 지원
- ✅ CI/CD 파이프라인 호환
- ✅ 멀티플랫폼 지원

---

## 🚨 **주요 트러블슈팅 사례**

### **GoRouter + MaterialPageRoute Navigator 충돌 문제**

#### **문제 상황**
GoRouter로 관리되는 화면에서 MaterialPageRoute로 전체 화면을 push한 후, 뒤로가기 버튼을 누르면:
- ❌ 정상적으로 이전 화면으로 돌아가지 않음
- ❌ 대신 앱 종료 관련 로직이 실행됨
- ❌ Android 백버튼이 제대로 동작하지 않음

#### **근본 원인**
```dart
// ❌ 문제 코드
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => DetailScreen(...),
  ),
);
```

**문제 분석:**
1. `Navigator.of(context).push()`는 **local Navigator**에 화면을 push함
2. `main.dart`의 MethodChannel 백버튼 핸들러는 **root Navigator**를 체크함
3. 서로 다른 Navigator를 참조하고 있어 `canPop()` 체크가 실패
4. root Navigator의 `canPop()` = `false` (DetailScreen이 local Navigator에 있으므로)
5. 잘못된 로직 실행: 앱 종료 토스트 표시

**Navigator 계층 구조:**
```
Root Navigator (GoRouter 관리)
  ↓
  MainScreen (GoRouter route: /main)
    ↓
    Local Navigator
      ↓
      DetailScreen (MaterialPageRoute) ← ❌ 여기에 push됨
```

**MethodChannel 백버튼 핸들러:**
```dart
// main.dart
final canPop = navigatorState?.canPop() ?? false; // root Navigator 체크
// → DetailScreen이 local Navigator에 있으므로 false 반환!

if (!canPop && location == '/main') {
  // 잘못된 로직 실행 ❌
  showExitToast();
}
```

#### **해결 방법**

```dart
// ✅ 올바른 코드
Navigator.of(context, rootNavigator: true).push(
  MaterialPageRoute(
    builder: (context) => DetailScreen(...),
  ),
);
```

**핵심 포인트:**
- `rootNavigator: true` 파라미터 추가
- DetailScreen을 **root Navigator**에 push
- main.dart의 `canPop()` 체크가 정상 동작
- 정상적인 뒤로가기 처리

**올바른 Navigator 계층:**
```
Root Navigator (GoRouter 관리)
  ↓
  ├─ MainScreen (GoRouter route: /main)
  └─ DetailScreen (MaterialPageRoute) ← ✅ 여기에 push됨
```

#### **코드 변경 사항**

**1. 화면 push 시 (예: main_screen.dart)**
```dart
// Before
final result = await Navigator.of(context).push(
  MaterialPageRoute(...),
);

// After
// rootNavigator: true를 사용하여 root Navigator에 push
// 이렇게 해야 main.dart의 MethodChannel back button handler에서 canPop() 체크가 동작함
final result = await Navigator.of(context, rootNavigator: true).push(
  MaterialPageRoute(
    builder: (context) => DetailScreen(
      data: data,
    ),
  ),
);
```

**2. main.dart 백버튼 핸들러 (MethodChannel)**
```dart
// ✅ 먼저 Navigator stack 확인 (MaterialPageRoute로 push된 화면이 있는지)
final navigatorKey = router.router.routerDelegate.navigatorKey;
final navigatorState = navigatorKey.currentState;
final canPop = navigatorState?.canPop() ?? false;

// Navigator가 pop 가능하면 Navigator에게 처리를 위임
if (canPop) {
  return false; // Navigator가 처리하도록 함
}

// canPop이 false일 때만 location 기반 로직 실행
final location = router.router.routerDelegate.currentConfiguration.uri.path;
if (location == '/main') {
  // 앱 종료 로직
}
```

#### **동작 흐름**

**수정 전 (문제 발생):**
```
1. DetailScreen이 local Navigator에 push됨
2. 사용자가 백버튼 누름
3. MethodChannel 핸들러 실행
4. root Navigator.canPop() 체크 → false (local Navigator에 있으므로)
5. location == '/main' 체크 → true
6. "한번 더 누르면 종료" 토스트 표시 ❌
```

**수정 후 (정상 동작):**
```
1. DetailScreen이 root Navigator에 push됨 (rootNavigator: true)
2. 사용자가 백버튼 누름
3. MethodChannel 핸들러 실행
4. root Navigator.canPop() 체크 → true ✅
5. return false → Navigator에게 처리 위임
6. Navigator가 DetailScreen을 pop
7. MainScreen으로 정상 복귀 ✅
```

#### **핵심 교훈**

**GoRouter + MaterialPageRoute를 함께 사용할 때:**
1. ✅ **항상 `rootNavigator: true` 명시**
2. ✅ **MethodChannel 백버튼 핸들러에서 root Navigator 체크 우선**
3. ✅ **Navigator 계층 구조를 명확히 이해**
4. ❌ **local Navigator와 root Navigator 혼동 금지**

**적용 패턴:**
```dart
// ✅ 전체 화면 네비게이션 (바텀바를 가리는 화면)
Navigator.of(context, rootNavigator: true).push(
  MaterialPageRoute(builder: (context) => DetailScreen()),
);

// ✅ iOS 스타일 스와이프 뒤로가기 지원
Navigator.of(context, rootNavigator: true).push(
  CupertinoPageRoute(builder: (context) => DetailScreen()),
);

// ❌ 잘못된 사용
Navigator.of(context).push(  // local Navigator 사용 금지
  MaterialPageRoute(...),
);
```

#### **실제 적용 예시**

**갤러리 앱에서의 적용:**
```dart
// gallery_screen.dart - 미디어 상세 화면으로 이동
onTap: (item) async {
  if (state.isSelectionMode) {
    notifier.toggleItemSelection(item.id);
  } else {
    final currentItems = state.photoSectionItems;
    final initialIndex = currentItems.indexOf(item);

    // rootNavigator: true 사용 - CRITICAL!
    final result = await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => MediaDetailScreen(
          items: currentItems,
          initialIndex: initialIndex,
        ),
      ),
    );

    // 디테일 화면에서 돌아온 경우 갤러리 새로고침
    if (result == true && mounted) {
      notifier.loadMediaItems();
    }
  }
}
```

---

*이 문서는 프로젝트 개발 과정에서 지속적으로 업데이트됩니다.*