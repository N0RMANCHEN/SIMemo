//这是应用程序的主视图。
//它组织了整个界面的布局，包括自定义标题栏、文件导航、节点画布和代码画布。

import SwiftUI
import AppKit

// 布局和颜色参数
struct ViewParameters {
    // 布局参数
    
    /// 主视图的最小宽度
    /// 这个值确保主视图不会变得太窄,以保持可用性
    static let minMainWidth: CGFloat = 400
    /// 主视图的最小高度
    /// 这个值确保主视图不会变得太矮,以保持可用性
    static let minMainHeight: CGFloat = 300
    
    /// 文件导航栏的最小宽度
    /// 这个值确保文件导航栏不会变得太窄,以保持可用性
    static let minNavigationWidth: CGFloat = 100
    /// 代码画布的最小宽度
    /// 这个值确保代码画布有足够的空间显示代码
    static let minCodeCanvasWidth: CGFloat = 100
    
    /// 分隔线的宽度
    /// 这个值定义了可拖动分隔线的宽度
    static let dividerWidth: CGFloat = 1


    // 颜色选择参数
    
    /// 主背景颜色
    /// 用于整个应用的主要背景色
    static let mainBackgroundColor = AppColors.color01
    
    /// 侧边栏背景颜色
    /// 用于文件导航栏的背景色
    static let sidebarBackgroundColor = AppColors.color02
    
    /// 节点画布背景颜色
    /// 用于中央节点画布区域的背景色
    static let nodeCanvasBackgroundColor = AppColors.color02
    
    /// 代码画布背景颜色
    /// 用于右侧代码预览区域的背景色
    static let codeCanvasBackgroundColor = AppColors.color01
    
    /// 分隔线颜色
    /// 用于可拖动分隔线的颜色
    static let dividerColor = AppColors.color02
}

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: 0) {
            // 自定义标题栏
            CustomTitleBar()
            
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    // 文件导航视图
                    FileNavigationView(title: "Memo Pages")
                        .frame(width: appState.navigationWidth)
                        .background(ViewParameters.sidebarBackgroundColor)
                    // 可拖动的分隔线，用于调整文件导航宽度
                    verticalDivider()
                    DragDivider(size: $appState.navigationWidth,
                                minSize: ViewParameters.minNavigationWidth,
                                maxSize: geometry.size.width / 2,
                                isVertical: true)


                    
                    // 节点画布视图
                    NodeCanvasView()
                        .frame(maxWidth: .infinity)
                        .background(ViewParameters.nodeCanvasBackgroundColor)
                    
                    // 可拖动的分隔线，用于调整代码预览宽度
                    DragDivider(size: $appState.codeCanvasWidth,
                                minSize: ViewParameters.minCodeCanvasWidth,
                                maxSize: geometry.size.width / 2,
                                isVertical: true, isReversed: true)
                    verticalDivider()


                    
                    // 代码预览视图
                    CodeCanvasView()
                        .frame(width: appState.codeCanvasWidth)
                        .background(ViewParameters.codeCanvasBackgroundColor)
                }
            }
            .background(ViewParameters.mainBackgroundColor)
            .frame(minWidth: ViewParameters.minMainWidth, minHeight: ViewParameters.minMainHeight)
            .edgesIgnoringSafeArea(.all) // 添加这一行
        }
    }
    
}
