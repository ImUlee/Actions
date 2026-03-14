import SwiftUI
import WebKit
import UIKit

@main
struct MatrixPilotApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        ZStack {
            // 兼容的液态背景效果 (iOS 15+)
            LiquidBackground()
            
            WebViewRepresentable(url: URL(string: "https://log.ppia.me:7777")!)
                .ignoresSafeArea()
        }
        .statusBarHidden(false)
    }
}

// 兼容的液态背景效果
struct LiquidBackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            // 渐变背景
            LinearGradient(
                colors: [
                    animate ? Color.blue.opacity(0.8) : Color.purple.opacity(0.8),
                    animate ? Color.cyan.opacity(0.6) : Color.blue.opacity(0.6),
                    animate ? Color.indigo.opacity(0.8) : Color.pink.opacity(0.8)
                ],
                startPoint: animate ? .topLeading : .bottomLeading,
                endPoint: animate ? .bottomTrailing : .topTrailing
            )
            .ignoresSafeArea()
            
            // 浮动圆形模拟液态
            ForEach(0..<5, id: \.self) { index in
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.white.opacity(0.3), .clear],
                            center: .center,
                            startRadius: 0,
                            endRadius: 100
                        )
                    )
                    .frame(width: CGFloat(100 + index * 50), height: CGFloat(100 + index * 50))
                    .position(
                        x: animate ? CGFloat(200 + index * 80) : CGFloat(100 + index * 60),
                        y: animate ? CGFloat(300 + index * 40) : CGFloat(200 + index * 80)
                    )
                    .animation(
                        Animation.easeInOut(duration: Double(3 + index))
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.5),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate = true
        }
    }
}

// WKWebView 包装
struct WebViewRepresentable: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        
        // 启用 JavaScript
        if #available(iOS 16.0, *) {
            config.defaultWebpagePreferences.allowsContentJavaScript = true
        }
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.scrollView.contentInsetAdjustmentBehavior = .automatic
        webView.allowsBackForwardNavigationGestures = true
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
