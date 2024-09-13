//这个组件可以很方便地集成到需要可调整大小的界面中，
//比如分割面板或可调整宽度的侧边栏等。

import SwiftUI
import AppKit

// 添加私有结构体来定义颜色
private struct DividerColors {
    static let background = AppColors.black2
}

// DragDivider 是一个可拖动的分隔线视图
struct DragDivider: View {
    @Binding var size: CGFloat  // 绑定的宽度值，可以在拖动时更新
    let minSize: CGFloat        // 最小宽度限制
    let maxSize: CGFloat        // 最大宽度限制
    var isVertical: Bool         // 是否是竖直分割线
    var isReversed: Bool = false // 是否反转拖动方向
    
    @State private var isHovering = false
    
    var body: some View {
        Rectangle()
            .fill(Color.black.opacity(0))
            .frame(width: isVertical ? 10 : nil, height: isVertical ? nil : 10)
            .contentShape(Rectangle())
        .gesture(
            DragGesture(minimumDistance: 1)
                .onChanged { gesture in
                    let delta = isVertical
                        ? (isReversed ? -gesture.translation.width : gesture.translation.width)
                        : (isReversed ? -gesture.translation.height : gesture.translation.height)
                    size = max(minSize, min(maxSize, size + delta))
                }
        )
        .onHover { hovering in
            if hovering {
                if isVertical {
                    NSCursor.resizeLeftRight.set()
                } else {
                    NSCursor.resizeUpDown.set()
                }
            } else {
                NSCursor.arrow.set()
            }
        }
    }
}

// 添加这些扩展
public extension View {
    // 竖直分割线函数
    func verticalDivider() -> some View {
        Divider()
            .background(DividerColors.background)
            .frame(width: 1)
    }
    
    // 水平分割线函数
    func horizontalDivider() -> some View {
        Divider()
            .background(DividerColors.background)
            .frame(height: 1)
    }
}