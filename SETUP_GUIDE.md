# 🚀 Setup Guide - Empty Flutter Template

Android 멀티모듈 템플릿을 Flutter로 완전히 포팅한 베이스 프로젝트 설정 가이드입니다.

## ✅ 설정 완료 상태

### 🎯 **주요 기능 구현 완료**
- ✅ **Riverpod 기반 아키텍처** (최신 Flutter 상태관리)
- ✅ **Clean Architecture** (Domain/Presentation 계층 분리)
- ✅ **Material 3 디자인 시스템** (Light/Dark 테마)
- ✅ **의존성 주입** (StateNotifierProvider)
- ✅ **Freezed 불변 상태** (타입 안전한 상태 모델)
- ✅ **네트워킹** (Dio + Retrofit)
- ✅ **라우팅** (go_router)
- ✅ **로깅 시스템** (AppLogger)
- ✅ **광고 시스템** (Google AdMob)
- ✅ **Firebase 통합** (Analytics, Crashlytics, Remote Config)
- ✅ **권한 관리** (permission_handler)

### 📁 **생성된 구조**
```
lib/
├── core/
│   ├── ads/              # AdMob 배너/전면 광고
│   ├── common/           # 공통 기능 (Result 패턴, Provider)
│   ├── designsystem/     # Material 3 테마
│   ├── network/          # Dio + Retrofit
│   ├── router/           # go_router 설정
│   ├── services/         # Firebase 서비스 + Provider
│   └── util/             # 로깅
├── features/
│   ├── splash/           # Riverpod 아키텍처 완벽 구현 (참고 예제)
│   │   ├── domain/models/        # Freezed 상태 모델
│   │   └── presentation/
│   │       ├── notifiers/        # 비즈니스 로직
│   │       ├── providers/        # Riverpod Provider
│   │       └── screens/          # UI
│   ├── main/             # 메인 화면 (바텀 네비게이션)
│   ├── example1/         # 예제 화면 1
│   ├── example2/         # 예제 화면 2
│   └── settings/         # 설정 화면
└── shared/               # 공유 리소스
```

---

## 🔧 **1단계: 개발 환경 설정**

### 필수 요구사항
```bash
# Flutter SDK 확인
flutter --version
# Flutter 3.8.1 이상, Dart 3.0 이상 필요

# 의존성 설치
flutter pub get
```

### 코드 생성 (선택사항)
```bash
# Freezed, Retrofit 등 자동 생성 코드
flutter packages pub run build_runner build --delete-conflicting-outputs
```

---

## 🔥 **2단계: Firebase 설정**

### Firebase CLI 설치 및 설정
```bash
# Firebase CLI 설치 (처음 한 번만)
npm install -g firebase-tools

# Firebase 로그인
firebase login

# Firebase 프로젝트 연동
firebase use --add  # 프로젝트 선택

# FlutterFire 설정 (lib/firebase_options.dart 자동 생성)
flutterfire configure --project=your-project-id
```

### Firebase 콘솔 설정
1. [Firebase Console](https://console.firebase.google.com/) 접속
2. 프로젝트 생성 또는 선택
3. Android/iOS 앱 추가
4. `google-services.json` (Android) / `GoogleService-Info.plist` (iOS) 다운로드

### Android Firebase 설정
```bash
# google-services.json 파일 위치
android/app/google-services.json
```

### iOS Firebase 설정
```bash
# GoogleService-Info.plist 파일 위치
ios/Runner/GoogleService-Info.plist
```

---

## 📱 **3단계: AdMob 설정**

### 1. AdMob 계정 및 광고 단위 생성
1. [AdMob Console](https://admob.google.com/) 접속
2. 앱 추가 (Android/iOS 각각)
3. 광고 단위 생성:
   - **배너 광고** 단위 ID
   - **전면 광고** 단위 ID

### 2. Android AdMob 설정
```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<manifest>
    <application>
        <!-- AdMob App ID -->
        <meta-data
            android:name="com.google.android.gms.ads.APPLICATION_ID"
            android:value="ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY"/>
    </application>
</manifest>
```

### 3. iOS AdMob 설정
```xml
<!-- ios/Runner/Info.plist -->
<dict>
    <!-- AdMob App ID -->
    <key>GADApplicationIdentifier</key>
    <string>ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY</string>

    <!-- SKAdNetwork 식별자 (iOS 14+) -->
    <key>SKAdNetworkItems</key>
    <array>
        <dict>
            <key>SKAdNetworkIdentifier</key>
            <string>cstr6suwn9.skadnetwork</string>
        </dict>
    </array>
</dict>
```

### 4. 광고 단위 ID 업데이트
```dart
// lib/core/ads/ad_unit_ids.dart

// Android 배너 광고 ID
static const String _androidBannerId = 'ca-app-pub-XXXXXXXXXXXXXXXX/BANNER_ID';

// Android 전면 광고 ID
static const String _androidInterstitialId = 'ca-app-pub-XXXXXXXXXXXXXXXX/INTERSTITIAL_ID';

// iOS 배너 광고 ID
static const String _iosBannerId = 'ca-app-pub-XXXXXXXXXXXXXXXX/BANNER_ID';

// iOS 전면 광고 ID
static const String _iosInterstitialId = 'ca-app-pub-XXXXXXXXXXXXXXXX/INTERSTITIAL_ID';
```

---

## 🍎 **4단계: iOS 빌드 설정**

### 1. CocoaPods 설치 (처음 한 번만)
```bash
# CocoaPods 설치
sudo gem install cocoapods

# 버전 확인
pod --version
```

### 2. iOS 의존성 설치
```bash
# ios 폴더로 이동
cd ios

# Pod 설치 (처음 또는 의존성 변경 시)
pod install

# Pod 업데이트 (의존성 업데이트 시)
pod update

# 프로젝트 루트로 복귀
cd ..
```

**주의사항:**
- `ios/Runner.xcworkspace` 파일을 Xcode에서 열어야 합니다 (`.xcodeproj`가 아님!)
- Pod 설치 후 항상 `.xcworkspace`를 사용하세요

### 3. Xcode 설정
```bash
# Xcode에서 프로젝트 열기
open ios/Runner.xcworkspace
```

**Xcode에서 설정:**
1. **Signing & Capabilities** 탭
   - Team 선택 (Apple Developer 계정)
   - Bundle Identifier 변경 (예: `com.yourcompany.yourapp`)
2. **General** 탭
   - Display Name 설정
   - Version/Build 번호 설정
3. **Info** 탭
   - 권한 설명 추가 (마이크, 카메라 등)

### 4. iOS 릴리즈 빌드
```bash
# 1. iOS 릴리즈 빌드 (IPA 생성)
flutter build ios --release

# 2. Xcode Archive (App Store 배포용)
# Xcode > Product > Archive 메뉴에서 진행

# 3. Archive 후 Organizer에서 Distribute App
# - App Store Connect (App Store 출시)
# - Ad Hoc (테스트 배포)
# - Development (개발용)
```

**Archive 빌드 명령어 (터미널):**
```bash
# Archive 빌드
xcodebuild -workspace ios/Runner.xcworkspace \
           -scheme Runner \
           -configuration Release \
           -archivePath build/Runner.xcarchive \
           archive

# IPA 생성 (수동)
xcodebuild -exportArchive \
           -archivePath build/Runner.xcarchive \
           -exportPath build/ios \
           -exportOptionsPlist ios/ExportOptions.plist
```

---

## 🤖 **5단계: Android 키스토어 생성 및 릴리즈 빌드**

### 1. 키스토어 생성

#### 키스토어 파일 생성
```bash
# 키스토어 생성 (처음 한 번만)
keytool -genkey -v -keystore /Users/jeonseongjin/Desktop/dev/key/jin.jks \
        -keyalg RSA -keysize 2048 -validity 10000 \
        -alias upload

# 입력 항목:
# - 키스토어 비밀번호: [안전한 비밀번호 입력]
# - 이름, 조직, 도시, 주, 국가 코드 입력
# - alias 비밀번호: [키스토어와 동일하거나 다른 비밀번호]
```

**주요 용어:**
- **keystore**: 키 저장소 파일 (`.jks` 또는 `.keystore`)
- **alias**: 키스토어 내의 키 별칭 (하나의 keystore에 여러 alias 가능)
- **validity**: 키 유효기간 (일 단위, 10000일 = 약 27년)

#### 기존 키스토어에 새 Alias 추가
```bash
# 이미 생성된 키스토어에 새로운 alias 추가
keytool -genkey -v -keystore /Users/jeonseongjin/Desktop/dev/key/jin.jks \
        -keyalg RSA -keysize 2048 -validity 10000 \
        -alias new-app-key

# 키스토어 비밀번호 입력 (기존 키스토어 비밀번호)
# 새 alias 정보 입력
# 새 alias 비밀번호 입력
```

#### 키스토어 정보 확인
```bash
# 키스토어의 모든 alias 목록 보기
keytool -list -v -keystore /Users/jeonseongjin/Desktop/dev/key/jin.jks

# 특정 alias 정보 확인
keytool -list -v -keystore /Users/jeonseongjin/Desktop/dev/key/jin.jks -alias upload
```

### 2. key.properties 파일 생성

```bash
# android/key.properties 파일 생성
cat > android/key.properties << EOF
storePassword=YOUR_KEYSTORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
storeFile=/Users/jeonseongjin/Desktop/dev/key/jin.jks
EOF
```

**⚠️ 보안 주의사항:**
- `key.properties`는 절대 Git에 커밋하지 마세요!
- `.gitignore`에 `**/key.properties` 추가 확인

### 3. build.gradle 설정

#### android/app/build.gradle 수정
```gradle
// 키스토어 설정 로드
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    // ...

    // 서명 설정
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release

            // 코드 난독화
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
}
```

### 4. Android 릴리즈 빌드

#### APK 빌드 (테스트 배포용)
```bash
# Release APK 생성
flutter build apk --release

# APK 파일 위치
# build/app/outputs/flutter-apk/app-release.apk

# Split APK 생성 (아키텍처별)
flutter build apk --split-per-abi --release

# 생성된 APK들
# build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk
# build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
# build/app/outputs/flutter-apk/app-x86_64-release.apk
```

#### AAB 빌드 (Google Play 배포용)
```bash
# App Bundle (AAB) 생성 - Google Play 권장 형식
flutter build appbundle --release

# AAB 파일 위치
# build/app/outputs/bundle/release/app-release.aab
```

**APK vs AAB:**
- **APK**: 직접 설치 가능, 테스트 배포용
- **AAB**: Google Play 전용, 최적화된 배포 (사용자별 맞춤 APK 생성)

### 5. 빌드 검증

```bash
# APK 서명 확인
keytool -printcert -jarfile build/app/outputs/flutter-apk/app-release.apk

# AAB 서명 확인
jarsigner -verify -verbose -certs build/app/outputs/bundle/release/app-release.aab
```

---

## 📦 **6단계: 앱 정보 커스터마이징**

### 1. 패키지명/Bundle ID 변경

#### Android
```gradle
// android/app/build.gradle
android {
    defaultConfig {
        applicationId "com.yourcompany.yourappname"
    }
}
```

#### iOS
```bash
# Xcode에서 변경
# Runner > General > Bundle Identifier
# 또는 ios/Runner.xcodeproj/project.pbxproj 파일에서 PRODUCT_BUNDLE_IDENTIFIER 검색
```

### 2. 앱 이름 변경

#### Android
```xml
<!-- android/app/src/main/res/values/strings.xml -->
<resources>
    <string name="app_name">Your App Name</string>
</resources>
```

#### iOS
```xml
<!-- ios/Runner/Info.plist -->
<key>CFBundleDisplayName</key>
<string>Your App Name</string>
```

### 3. 앱 버전 관리

#### pubspec.yaml
```yaml
version: 1.0.0+1
# 1.0.0 = 버전 이름 (사용자에게 표시)
# +1 = 빌드 번호 (내부 버전, 매 빌드마다 증가)
```

---

## 🔍 **7단계: 빌드 및 실행**

### 개발 빌드
```bash
# 디버그 모드 실행
flutter run

# 특정 디바이스 지정
flutter run -d chrome        # 웹
flutter run -d emulator-5554 # Android 에뮬레이터
flutter run -d iPhone        # iOS 시뮬레이터
```

### 릴리즈 빌드 테스트
```bash
# 릴리즈 모드로 실행 (성능 확인)
flutter run --release

# 프로파일 모드 (성능 프로파일링)
flutter run --profile
```

### 프로젝트 정리
```bash
# 빌드 캐시 정리
flutter clean

# 의존성 재설치
flutter pub get

# iOS Pod 재설치
cd ios && pod install && cd ..
```

---

## ✅ **8단계: 테스트 및 검증**

### 코드 분석
```bash
# 정적 분석
flutter analyze

# 코드 포맷팅
dart format .
```

### 테스트 실행
```bash
# 유닛 테스트
flutter test

# 위젯 테스트
flutter test test/widget_test.dart

# 통합 테스트
flutter test integration_test/
```

---

## 🎯 **현재 상태 요약**

### ✅ **즉시 사용 가능한 기능**
- Riverpod 기반 완벽한 아키텍처
- Material 3 테마 자동 전환
- Bottom Navigation 라우팅
- 의존성 주입 시스템
- 로깅 시스템
- 기본 화면 구조

### ⚙️ **추가 설정이 필요한 기능**
- Firebase 프로젝트 연동 (`firebase_options.dart` 업데이트)
- AdMob 운영 광고 ID (현재 테스트 ID 사용 중)
- iOS 서명 인증서 (Apple Developer 계정 필요)
- Android 키스토어 (릴리즈 빌드용)

---

## 💡 **주요 파일 체크리스트**

| 파일 | 역할 | 설정 상태 |
|------|------|-----------|
| `lib/main.dart` | 앱 진입점 | ✅ 완료 |
| `lib/firebase_options.dart` | Firebase 설정 | 🔧 업데이트 필요 |
| `android/app/google-services.json` | Firebase Android | 🔧 추가 필요 |
| `ios/Runner/GoogleService-Info.plist` | Firebase iOS | 🔧 추가 필요 |
| `android/app/src/main/AndroidManifest.xml` | 권한 및 AdMob | 🔧 AdMob ID 변경 필요 |
| `ios/Runner/Info.plist` | iOS 설정 | 🔧 AdMob ID 변경 필요 |
| `lib/core/ads/ad_unit_ids.dart` | 광고 ID 관리 | 🔧 운영 ID로 변경 필요 |
| `android/key.properties` | 키스토어 설정 | 🔧 생성 필요 |
| `pubspec.yaml` | 의존성 정의 | ✅ 완료 |

---

## 🚀 **다음 단계**

1. ✅ **Firebase 프로젝트 연동** (2단계)
2. ✅ **AdMob 계정 설정** (3단계)
3. ✅ **iOS 서명 및 빌드** (4단계)
4. ✅ **Android 키스토어 생성** (5단계)
5. 🎨 **앱 커스터마이징** (디자인, 기능 추가)
6. 🧪 **테스트 작성** (유닛/위젯/통합)
7. 📱 **배포** (App Store / Google Play)

---

## 🆘 **트러블슈팅**

### iOS Pod 설치 오류
```bash
# Pod 캐시 정리
cd ios
pod cache clean --all
pod deintegrate
rm -rf Pods Podfile.lock
pod install
cd ..
```

### Android 빌드 오류
```bash
# Gradle 캐시 정리
cd android
./gradlew clean
./gradlew --stop
rm -rf .gradle
cd ..
flutter clean
```

### 키스토어 비밀번호 분실
```text
⚠️ 키스토어 비밀번호를 분실하면 복구 불가능합니다!
- 새 키스토어를 생성해야 하며
- Google Play에서는 새 앱으로 등록해야 합니다
- 반드시 비밀번호를 안전하게 보관하세요!
```

---


## 🚀 Flutter 프로젝트 설정

### 1. Firebase CLI 설치

```bash
# Firebase CLI 설치
npm install -g firebase-tools

# Firebase 로그인
firebase login
```

### 2. FlutterFire CLI 설치

```bash
# FlutterFire CLI 전역 활성화
dart pub global activate flutterfire_cli
```

**PATH 설정 (필수):**

FlutterFire CLI가 PATH에 추가되어야 `flutterfire` 명령어를 사용할 수 있습니다.

**macOS/Linux 자동 설정:**

```bash
# 1. .zshrc 파일에 PATH 추가 (zsh 사용 시)
echo 'export PATH="$PATH":"$HOME/.pub-cache/bin"' >> ~/.zshrc

# 또는 .bashrc 파일에 추가 (bash 사용 시)
# echo 'export PATH="$PATH":"$HOME/.pub-cache/bin"' >> ~/.bashrc

# 2. 설정 재로드
source ~/.zshrc  # 또는 source ~/.bashrc
```

**Windows 설정:**
1. 시스템 환경 변수 편집
2. Path 변수에 `%USERPROFILE%\AppData\Local\Pub\Cache\bin` 추가

**PATH 설정 확인:**

```bash
# FlutterFire CLI 실행 테스트
flutterfire --version
```

성공적으로 버전이 출력되면 설정 완료입니다.

### 3. FlutterFire 구성

Flutter 프로젝트 루트 디렉토리에서 실행:

```bash
# 프로젝트 디렉토리로 이동
cd /path/to/soundless

# FlutterFire 구성 실행
flutterfire configure
```


이제 이 템플릿을 바탕으로 실제 앱 개발 및 배포를 시작할 수 있습니다! 🎉
