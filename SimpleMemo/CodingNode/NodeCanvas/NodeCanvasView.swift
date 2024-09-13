//这个视图可能是一个图形化编辑器或可视化工具的一部分，
//用于展示和操作多个相互关联的节点。
//它利用@EnvironmentObject来访问共享的应用状态，
//从而实现节点的动态管理和更新。

import SwiftUI

// 定义视图样式
private struct ViewStyle {
    // 颜色
    /// 画布背景颜色
    static let backgroundColor = AppColors.black0
    
    // 布局
    /// 节点之间的间距
    static let nodeSpacing: CGFloat = 20
    
    // 网格相关的样式
    static let gridSpacing: CGFloat = 30
    static let gridDotRadius: CGFloat = 1
    static let gridDotColor = AppColors.gray1.opacity(0.3) // 设置点的颜色和不透明度
    static let gridOffset: CGFloat = gridSpacing / 2 // 添加这行来定义偏移量
}

// NodeCanvasView 定义
struct NodeCanvasView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var canvasState = CanvasState()
    
    var body: some View {
        GeometryReader { geometry in
            // 使用ZStack来叠加多个视图层
            ZStack {
                // 设置背景颜色并忽略安全区域
                ViewStyle.backgroundColor
                    .edgesIgnoringSafeArea(.all)
                
                // 添加网格背景视图并忽略安全区域
                GridBackgroundView()
                    .edgesIgnoringSafeArea(.all)

                // 遍历并显示所有节点视图模型
                ForEach(appState.nodeViewModels) { viewModel in
                    NodeView(viewModel: viewModel)
                }
            }
            // 添加手势识别器
            .gesture(
                // 使用TapGesture来处理点击事件
                TapGesture()
                    .onEnded { _ in
                        appState.deselectAllNodes()
                    }
            )
            .onAppear {
                canvasState.visibleSize = geometry.size
            }
            .onChange(of: geometry.size) { newSize in
                canvasState.visibleSize = newSize
            }
        }
        .environmentObject(canvasState)
    }
}

// 修改背景网格视图，加入偏移并隐藏超出画布的点
struct GridBackgroundView: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                for x in stride(from: -ViewStyle.gridOffset, 
                                to: geometry.size.width + ViewStyle.gridOffset, 
                                by: ViewStyle.gridSpacing) {
                    for y in stride(from: -ViewStyle.gridOffset, 
                                    to: geometry.size.height + ViewStyle.gridOffset, 
                                    by: ViewStyle.gridSpacing) {
                        // 检查点是否在画布范围内
                        if x >= 0 && x <= geometry.size.width &&
                           y >= 0 && y <= geometry.size.height {
                            let center = CGPoint(x: x, y: y)
                            path.addArc(center: center, 
                                        radius: ViewStyle.gridDotRadius, 
                                        startAngle: .degrees(0), 
                                        endAngle: .degrees(360), 
                                        clockwise: true)
                        }
                    }
                }
            }
            .fill(ViewStyle.gridDotColor)
        }
    }
}


