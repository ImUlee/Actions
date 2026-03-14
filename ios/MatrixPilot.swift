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
    @State private var isLoading = true
    
    var body: some View {
        ZStack {
            // iOS 26 液态背景效果
            LiquidBackground()
            
            WebViewRepresentable(url: URL(string: "https://log.ppia.me:7777")!)
                .ignoresSafeArea()
        }
        .statusBarHidden(false)
    }
}

// iOS 26 液态背景效果
struct LiquidBackground: View {
    @State private var animate = false
    
    var body: some View {
        MeshGradient(
            width: 3,
            height: 3,
            points: [
                .init(0, 0): animate ? .blue : .purple,
                .init(0.5, 0): animate ? .cyan : .blue,
                .init(1, 0): animate ? .blue : .purple,
                .init(0, 0.5): animate ? .indigo : .pink,
                .init(0.5, 0.5): animate ? .white.opacity(0.3) : .white.opacity(0.2),
                .init(1, 0.5): animate ? .indigo : .pink,
                .init(0, 1): animate ? .purple : .blue,
                .init(0.5, 1): animate ? .blue : .cyan,
                .init(1, 1): animate ? .purple : .blue,
            ],
            colors: [
                .blue, .cyan, .blue,
                .indigo, .white, .indigo,
                .purple, .blue, .purple
            ]
        )
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }
}

// WKWebView 包装
struct WebViewRepresentable: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.preferences.javaScriptEnabled = true
        
        // iOS 26 新特性支持
        if #available(iOS 26.0, *) {
            config.liquidPreferences.enabled = true
            config.liquidPreferences.contentSize = .full
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
