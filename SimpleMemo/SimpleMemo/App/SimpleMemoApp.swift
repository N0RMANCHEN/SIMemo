//这是应用程序的入口点。它设置了主窗口的最小尺寸，并使用了隐藏标题栏的窗口样式。

import SwiftUI

@main
struct SimpleMemoApp: App {
    @StateObject private var appState = AppState()
    
    // 应用程序的主体结构
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                // 设置主窗口的最小尺寸
                .ignoresSafeArea(.all, edges: .top) // 忽略顶部安全区域
        }
        // 使用隐藏标题栏的窗口样式
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .defaultSize(width: 1060, height: 600)
        .windowToolbarStyle(.unifiedCompact) // 使用紧凑的工具栏样式
    } 
}
