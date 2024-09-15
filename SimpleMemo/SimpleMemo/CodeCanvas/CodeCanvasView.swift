//总的来说，这个文件定义了应用程序中用于代码预览的用户界面组件。
//它是整个应用程序中负责显示选中节点代码内容的部分。

import SwiftUI

// 输入文本
private struct InputText {
    /// 标题文本
    static let title = "Memo Details"
    
    /// 未选中节点时的提示文本
    static let placeholder = "Select a memo to view details"
}

// 定义视图样式
private struct ViewStyle {
    // 布局
    /// 标题区域的内边距，定义了标题文本周围的空间
    static let titlePadding: EdgeInsets = .init(top: 12, leading: 12, bottom: 12, trailing: 12)
    
    /// 代码预览区域的内边距，定义了代码文本周围的空间
    static let codePadding: EdgeInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
    
    // 颜色
    /// 标题文字的颜色
    static let titleColor = AppColors.color05
    
    /// 标题背景的颜色
    static let titleBackgroundColor = AppColors.color02
    
    /// 代码文本的颜色
    static let codeColor = AppColors.color06
    
    /// 代码预览区域的背景颜色
    static let codeBackgroundColor = AppColors.color01
    
    /// 未选中节点时显示的提示文本颜色
    static let placeholderColor = AppColors.color05
}

// 字体设置
private struct ViewFont {
    /// 标题字体
    static let headerFont = FontManager.titleFont
    
    /// 代码内容字体
    static let codeContentFont = FontManager.codeFont
    
    /// 空状态提示字体
    static let emptyStateFont = FontManager.titleFont
}

// CodeCanvasView 结构体:用于显示选中节点的代码预览
struct CodeCanvasView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(spacing: 0) {
            // 标题栏
            Text(InputText.title)
                .font(ViewFont.headerFont)
                .foregroundColor(ViewStyle.titleColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(ViewStyle.titlePadding)
                .background(ViewStyle.titleBackgroundColor)
            
            horizontalDivider()
            
            // 代码预览区域
            if let viewModel = appState.selectedNodeViewModel {
                ScrollView {
                    Text(viewModel.node.code)
                        .padding(ViewStyle.codePadding)
                        .foregroundColor(ViewStyle.codeColor)
                        .font(ViewFont.codeContentFont)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .background(ViewStyle.codeBackgroundColor)
            } else {
                // 未选中节点时显示的提示文本
                Text(InputText.placeholder)
                    .font(ViewFont.emptyStateFont)
                    .foregroundColor(ViewStyle.placeholderColor)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(ViewStyle.codeBackgroundColor)
            }
        }
    }
}

