#!/bin/bash
# MatrixPilot iOS 打包脚本

set -e

echo "📦 MatrixPilot iOS 打包工具"
echo "=============================="

# 检查 Xcode
if ! command -v xcodegen &> /dev/null; then
    echo "❌ xcodegen 未安装"
    echo "   安装: brew install xcodegen"
    exit 1
fi

# 进入 ios 目录
cd "$(dirname "$0")"

# 生成项目
echo "🔧 生成 Xcode 项目..."
xcodegen generate 2>/dev/null || echo "项目已存在"

# 编译
echo "🏗️ 编译中..."
xcodebuild -project MatrixPilot.xcodeproj \
  -scheme MatrixPilot \
  -configuration Debug \
  -destination 'generic/platform=iOS Simulator' \
  CODE_SIGN_IDENTITY="" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGNING_ALLOWED=NO \
  build

echo "✅ 编译完成!"
echo ""
echo "📱 运行方式:"
echo "   1. 打开 Xcode"
echo "   2. 导入 ios/MatrixPilot.xcodeproj"
echo "   3. 连接 iPhone/iPad"
echo "   4. 点击运行"
