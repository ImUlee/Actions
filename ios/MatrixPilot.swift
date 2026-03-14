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
            // iOS 26 液态背景效果
            if #available(iOS 26.0, *) {
                iOS26LiquidBackground()
            } else {
                FallbackLiquidBackground()
            }
            
            WebViewRepresentable(url: URL(string: "https://log.ppia.me:7777")!)
                .ignoresSafeArea()
        }
    }
}

// iOS 26 液态背景 - 使用正确的 MeshGradient API
@available(iOS 26.0, *)
struct iOS26LiquidBackground: View {
    @State private var animate = false
    
    var body: some View {
        MeshGradient(
            width: 3,
            height: 3,
            points: [
                .init(0, 0): .blue,
                .init(0.5, 0): .cyan,
                .init(1, 0): .blue,
                .init(0, 0.5): .indigo,
                .init(0.5, 0.5): .white.opacity(0.3),
                .init(1, 0.5): .indigo,
                .init(0, 1): .purple,
                .init(0.5, 1): .blue,
                .init(1, 1): .purple,
            ],
            colors: [
                .blue, .cyan, .blue,
                .indigo, .white, .indigo,
                .purple, .blue, .purple
            ]
        )
        .ignoresSafeArea()
        .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: animate)
        .onAppear { animate = true }
    }
}

// 备用液态背景
struct FallbackLiquidBackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.blue.opacity(0.8), .purple.opacity(0.8), .pink.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ForEach(0..<5, id: \.self) { index in
                Circle()
                    .fill(.white.opacity(0.2))
                    .frame(width: 150 + CGFloat(index * 30), height: 150 + CGFloat(index * 30))
                    .position(
                        x: CGFloat(150 + index * 60) + (animate ? CGFloat.random(in: -30...30) : 0),
                        y: CGFloat(200 + index * 50) + (animate ? CGFloat.random(in: -30...30) : 0)
                    )
                    .blur(radius: 30)
            }
        }
        .onAppear { animate = true }
        .animation(.easeInOut(duration: 4).repeatForever(autoreverses: true), value: animate)
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
