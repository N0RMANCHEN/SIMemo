import SwiftUI
import AppKit

struct CustomTitleBar: View {
    // 自定义标题栏的高度
    private let height: CGFloat = 38
    
    // 分割线的高度
    private let dividerHeight: CGFloat = 1
    
    // 标题栏的背景颜色
    private let backgroundColor = AppColors.color02
    
    // 分割线的颜色
    private let dividerColor = AppColors.color03
    
    // 窗口内容区域的调整值（用于移除额外空间）
    private let contentHeightAdjustment: CGFloat = 0
    
    // 标准窗口按钮（红绿灯）的宽度
    private let buttonWidth: CGFloat = 14
    
    // 标准窗口按钮（红绿灯）之间的间距
    private let buttonSpacing: CGFloat = 6

    // 定义一个新的参数用于微调按钮的垂直位置
      
    private let buttonVerticalAdjustment: CGFloat = 4
            
    

    
    // 标准窗口按钮（红绿灯）距离左侧的边距
    private let buttonLeftMargin: CGFloat = 12
    
    var body: some View {
        VStack(spacing: 0) {
            Color.clear
                .frame(height: height)
                .background(backgroundColor)
            
            // 使用 Divider 添加分割线
            horizontalDivider()
        }
        .frame(height: height + dividerHeight)
        .onAppear {
            setupWindow()
        }
    }
    
    private func setupWindow() {
        guard let window = NSApplication.shared.windows.first else { return }
        
        // 设置窗口标题栏透明并使用全尺寸内容视图
        window.titlebarAppearsTransparent = true
        window.styleMask.insert(.fullSizeContentView)
        
        // 调整窗口大小以移除额外空间
        window.setContentSize(NSSize(width: window.frame.width, height: window.frame.height - contentHeightAdjustment))
        window.contentView?.setFrameOrigin(NSPoint(x: 0, y: 0))

        repositionStandardWindowButtons(for: window)
    }

    // 标准窗口按钮位置she
    private func repositionStandardWindowButtons(for window: NSWindow) {
        let buttonTypes: [NSWindow.ButtonType] = [.closeButton, .miniaturizeButton, .zoomButton]
        
        guard let titlebarView = window.contentView?.superview?.subviews.first(where: { $0.className == "NSTitlebarContainerView" }) else { return }
        
        for (index, buttonType) in buttonTypes.enumerated() {
            guard let button = window.standardWindowButton(buttonType) else { continue }
            
            let xPosition = buttonLeftMargin + CGFloat(index) * (buttonWidth + buttonSpacing)
            
            button.translatesAutoresizingMaskIntoConstraints = false
            titlebarView.addSubview(button)
            

            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: titlebarView.leadingAnchor, constant: xPosition),
                button.centerYAnchor.constraint(equalTo: titlebarView.centerYAnchor, constant: buttonVerticalAdjustment),
                button.widthAnchor.constraint(equalToConstant: buttonWidth)
                // 移除了高度约束，允许按钮保持其固有高度
            ])
        }
        
        // 移除窗口大小改变的观察者，因为不再需要重新定位按钮
        NotificationCenter.default.removeObserver(self, name: NSWindow.didResizeNotification, object: window)
    }
}
