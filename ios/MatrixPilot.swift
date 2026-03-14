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
            // 液态背景效果 (iOS 15+)
            LiquidBackground()
            
            WebViewRepresentable(url: URL(string: "https://log.ppia.me:7777")!)
                .ignoresSafeArea()
        }
    }
}

// 液态背景效果
struct LiquidBackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            // 渐变背景
            LinearGradient(
                colors: [
                    animate ? Color.blue.opacity(0.9) : Color.purple.opacity(0.9),
                    animate ? Color.cyan.opacity(0.7) : Color.blue.opacity(0.7),
                    animate ? Color.indigo.opacity(0.8) : Color.pink.opacity(0.8),
                    animate ? Color.purple.opacity(0.8) : Color.blue.opacity(0.8)
                ],
                startPoint: animate ? .topLeading : .bottomLeading,
                endPoint: animate ? .bottomTrailing : .topTrailing
            )
            .ignoresSafeArea()
            
            // 浮动圆形模拟液态
            ForEach(0..<6, id: \.self) { index in
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.white.opacity(0.4), .clear],
                            center: .center,
                            startRadius: 0,
                            endRadius: 80
                        )
                    )
                    .frame(width: CGFloat(120 + index * 40), height: CGFloat(120 + index * 40))
                    .blur(radius: 20)
                    .position(
                        x: animate ? CGFloat(180 + index * 50) : CGFloat(100 + index * 70),
                        y: animate ? CGFloat(350 + index * 30) : CGFloat(250 + index * 60)
                    )
                    .animation(
                        Animation.easeInOut(duration: Double(4 + index))
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.3),
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
        
        if #available(iOS 16.0, *) {
            config.defaultWebpagePreferences.allowsContentJavaScript = true
        }
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.scrollView.contentInsetAdjustmentBehavior = .automatic
        webView.allowsBackForwardNavigationGestures = true
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        webView.load(URLRequest(url: url))
    }
}
