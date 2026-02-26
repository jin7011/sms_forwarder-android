# SMS Forwarder for Android

Android SMS/MMS 메시지를 Slack 채널로 자동 전달하는 오픈소스 앱입니다.

> **MMS 텍스트 포워딩을 지원하는 몇 안 되는 오픈소스 SMS Forwarder입니다.**
> 대부분의 유사 프로젝트는 SMS만 지원하지만, 이 앱은 MMS의 텍스트까지 추출하여 Slack으로 전달합니다.

<br>

## Why this project?

기존 오픈소스 SMS Forwarder들과의 비교:

| 프로젝트 | SMS | MMS 텍스트 | Slack | 백그라운드 |
|---------|:---:|:---:|:---:|:---:|
| **SMS Forwarder (이 프로젝트)** | ✅ | ✅ | ✅ | ✅ Foreground Service |
| [nimblehq/sms-forwarder](https://github.com/nimblehq/sms-forwarder) | ✅ | ❌ | ✅ | ❌ |
| [telegram-sms](https://github.com/telegram-sms/telegram-sms) | ✅ | ❌ | ❌ | ✅ |
| [SMS2Telegram](https://github.com/imTigger/SMS2Telegram) | ✅ | ❌ | ❌ | ❌ |
| [android_income_sms_gateway_webhook](https://github.com/bogkonstantin/android_income_sms_gateway_webhook) | ✅ | ❌ | ❌ | ❌ |

**차별점:**
- **MMS 텍스트 포워딩** — Android의 `content://mms` ContentObserver로 MMS를 감지하고 `text/plain` 파트를 추출합니다. 기본 메시징 앱을 교체하지 않고도 동작합니다.
- **Foreground Service** — 화면이 꺼져 있어도 안정적으로 MMS를 수신합니다.
- **Slack Block Kit** — 발신자, 시간, 기기 정보가 포함된 깔끔한 Slack 메시지를 전송합니다.

<br>

## 주요 기능

- **SMS 수신 시 Slack 자동 전달** — 발신자, 내용, 시간, 기기 정보 포함
- **MMS 텍스트 전달** — MMS의 텍스트 내용만 추출하여 Slack으로 전송 (이미지/영상/파일은 미지원)
- **백그라운드 동작** — 화면이 꺼져 있어도 Foreground Service로 안정적 수신
- **포워딩 히스토리** — 전송 성공/실패 기록 확인
- **멀티 디바이스** — 기기 이름/전화번호를 설정하여 어떤 기기에서 수신된 메시지인지 구분

<br>

## 사전 준비: Slack Webhook URL 발급

앱을 사용하려면 Slack Incoming Webhook URL이 필요합니다.

### 1. Slack App 생성

1. [Slack API Apps](https://api.slack.com/apps) 페이지에 접속
2. **Create New App** > **From scratch** 선택
3. App Name 입력 (예: `SMS Forwarder`), Workspace 선택 후 **Create App**

### 2. Incoming Webhook 활성화

1. 좌측 메뉴에서 **Incoming Webhooks** 클릭
2. 상단 토글을 **On**으로 변경
3. 하단의 **Add New Webhook to Workspace** 클릭
4. 메시지를 받을 채널 선택 (예: `#sms-forwarding`) 후 **Allow**

### 3. Webhook URL 복사

생성된 URL을 복사합니다. 아래와 같은 형식입니다:

> `https://hooks.slack.com/services/T.../B.../xxxx...`

> 이 URL은 외부에 노출되지 않도록 주의하세요.

<br>

## 앱 설정 방법

### 1단계: 앱 설치 및 실행

APK를 빌드하여 Android 기기에 설치합니다.

```bash
flutter build apk --debug
```

### 2단계: Webhook URL 등록

1. 하단 탭에서 **설정** 이동
2. **Slack 연동** 섹션에서 Webhook URL 입력
3. **Webhook URL 저장** 버튼 클릭

### 3단계: 권한 허용

1. 설정 화면의 **권한** 섹션에서 **SMS 수신 권한** 허용
2. (선택) 배터리 최적화 제외 설정 — 안정적인 백그라운드 동작을 위해 권장

   > 설정 > 앱 > SMS Forwarder > 배터리 > 제한 없음

### 4단계: 포워딩 시작

1. **대시보드** 탭으로 이동
2. **SMS 포워딩** 토글을 켜기
3. 상태가 **실행 중**으로 변경되면 준비 완료

### 5단계: 테스트

설정 탭에서 **테스트 메시지 전송** 버튼을 눌러 Slack에 정상 수신되는지 확인합니다.

<br>

## SMS vs MMS 동작 차이

| | SMS | MMS |
|---|---|---|
| 수신 방식 | 시스템 브로드캐스트 (`SMS_RECEIVED`) | ContentObserver (`content://mms`) |
| 전달 내용 | 텍스트 전체 | **텍스트만** (이미지/영상/파일 미지원) |
| Slack 헤더 | `SMS 수신` | `MMS 수신` |
| 감지 지연 | 즉시 | 약 3초 (기본 메시징 앱이 MMS 다운로드 후 감지) |
| 백그라운드 | another_telephony 백그라운드 핸들러 | Foreground Service + ContentObserver |

> MMS에 텍스트 없이 이미지만 포함된 경우 전달되지 않습니다.

<br>

## MMS 포워딩 동작 원리

대부분의 SMS Forwarder가 MMS를 지원하지 않는 이유는 Android의 MMS 수신 구조 때문입니다:

- **SMS**: `SMS_RECEIVED` 브로드캐스트로 모든 앱이 수신 가능
- **MMS**: `WAP_PUSH_DELIVER` 브로드캐스트는 **기본 메시징 앱만** 수신 가능

이 앱은 기본 메시징 앱을 교체하지 않고, **ContentObserver**로 MMS 데이터베이스 변경을 감지하는 방식을 사용합니다:

```
MMS 수신 → 기본 메시징 앱이 다운로드/저장
  → ContentObserver가 content://mms 변경 감지 (3초 딜레이)
    → content://mms/{id}/part 에서 text/plain 파트 추출
      → 발신자 정보 읽기 → Slack Webhook 전송
```

**중복 방지**: 같은 MMS ID에 대해 10초 이내 중복 감지를 무시합니다.

<br>

## Slack 메시지 형식

```
┌─────────────────────────────────┐
│  SMS 수신  (또는 MMS 수신)        │
│  수신 기기: Galaxy A24 | 010-... │
├─────────────────────────────────┤
│  발신자: +8210XXXXXXXX          │
│  시간: 2026-03-25 14:30:00      │
├─────────────────────────────────┤
│  내용:                          │
│  인증번호 [123456]을 입력해주세요. │
└─────────────────────────────────┘
```

<br>

## 기술 스택

- **Flutter** (Dart) — UI 및 비즈니스 로직
- **Kotlin** — Android 네이티브 (MMS ContentObserver, Foreground Service)
- **Riverpod** — 상태 관리
- **Hive** — 로컬 히스토리 저장
- **Dio** — Slack Webhook HTTP 통신
- **another_telephony** — SMS 수신

<br>

## 프로젝트 구조

```
lib/
├── core/                    # 공통 모듈 (디자인 시스템, 라우터, 유틸)
├── features/
│   ├── dashboard/           # 대시보드 (포워딩 토글, 통계)
│   ├── history/             # 전송 히스토리
│   ├── settings/            # 설정 (Webhook URL, 기기 정보, 권한)
│   └── splash/              # 스플래시
└── shared/services/
    ├── slack_service.dart           # Slack Webhook 전송
    ├── sms_listener_service.dart    # SMS 수신 리스닝
    ├── sms_forwarding_service.dart  # SMS 포워딩 처리
    ├── mms_listener_service.dart    # MMS Foreground Service 제어
    └── mms_forwarding_service.dart  # MMS 포워딩 처리

android/.../kotlin/
├── MainActivity.kt          # EventChannel, MethodChannel 설정
├── MmsObserverService.kt    # Foreground Service + ContentObserver
├── MmsEventChannel.kt       # Flutter로 MMS 이벤트 전달
└── PendingMmsStore.kt       # 백그라운드 MMS 임시 저장
```

<br>

## 빌드

```bash
# 디버그 APK
flutter build apk --debug

# 릴리즈 APK
flutter build apk --release
```

<br>

## 알려진 제한 사항

- **Android 전용** — iOS에서는 SMS/MMS 수신 API를 지원하지 않습니다.
- **MMS 이미지/영상 미지원** — MMS의 텍스트 파트(`text/plain`)만 추출합니다.
- **제조사별 배터리 최적화** — 삼성, 샤오미 등 일부 제조사는 자체 배터리 최적화로 Foreground Service를 종료할 수 있습니다. 배터리 최적화 제외 설정을 권장합니다.
- **MMS 감지 지연** — 기본 메시징 앱이 MMS를 다운로드/저장한 후 감지하므로 약 3초 지연이 있습니다.

<br>

## 라이선스

MIT License
