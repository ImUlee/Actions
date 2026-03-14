# MatrixPilot iOS App

## 构建方式

### 方式 1: Xcode (推荐)

1. 打开终端，进入 ios 目录：
```bash
cd ios
```

2. 生成 Xcode 项目：
```bash
xcodebuild -project MatrixPilot.xcodeproj -scheme MatrixPilot -configuration Debug -destination 'generic/platform=iOS Simulator' build
```

3. 或者用 Xcode 打开 `MatrixPilot.xcodeproj`

### 方式 2: 命令行编译

```bash
xcodebuild -project MatrixPilot.xcodeproj \
  -scheme MatrixPilot \
  -configuration Debug \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  CODE_SIGN_IDENTITY="-" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGNING_ALLOWED=NO \
  build
```

### 方式 3: CI/CD 自动构建

使用 GitHub Actions 自动构建：

1. Fork 项目
2. 添加 `.github/workflows/ios.yml`
3. 自动生成 .ipa

---

## 服务器地址

```swift
let SERVER_URL = "https://log.ppia.me:7777"
```

如需修改，编辑 `MatrixPilot.swift` 第 24 行。

---

## 功能特性

- ✅ iOS 26 液态背景效果
- ✅ 全屏 WebView 加载网页
- ✅ 支持横竖屏
- ✅ 安全区域适配

---

## 签名

需要在 Apple Developer 账号中：
1. 创建 App ID
2. 配置签名证书
3. 在 Xcode 中选择 Team
