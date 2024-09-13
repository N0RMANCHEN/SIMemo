//这个文件的主要功能是实现一个文件导航视图，
//用于显示和管理文件系统的目录结构

import SwiftUI

// 定义视图样式
private struct ViewStyle {
    // 布局
    /// 导航标题栏的内边距
    static let titleBarPadding: EdgeInsets = .init(top: 8, leading: 12, bottom: 8, trailing: 12)
    
    /// 文件项的内边距
    static let fileItemPadding: EdgeInsets = .init(top: 4, leading: 8, bottom: 4, trailing: 8)
    
    /// 子项的左侧缩进
    static let childItemIndent: CGFloat = 16
    
    // 颜色
    /// 导航标题文字颜色
    static let titleColor = AppColors.gray1
    
    /// 导航背景颜色
    static let backgroundColor = AppColors.black1
    
    /// 分隔线颜色
    static let dividerColor = AppColors.black2
    
    /// 文件项文字颜色
    static let fileItemTextColor = AppColors.gray1
    
    /// 文件项图标颜色
    static let fileItemIconColor = AppColors.gray0
    
    // 尺寸
    /// 分隔线高度
    static let dividerHeight: CGFloat = 1
    
    /// 添加目录按钮的圆角半径
    static let addButtonCornerRadius: CGFloat = 4
    
    /// 添加目录按钮的描边宽度
    static let addButtonBorderWidth: CGFloat = 1
    
    /// 添加目录按钮的内边距
    static let addButtonPadding: CGFloat = 4
}

// 字体设置
private struct ViewFont {
    /// 导航标题字体
    static let navigationTitleFont = FontManager.titleFont
    
    /// 文件项字体
    static let fileItemFont = FontManager.titleFont
    
    /// 展开/折叠图标字体
    static let chevronFont = FontManager.titleFont
}

// 文件导航视图
struct FileNavigationView: View {
    @EnvironmentObject var appState: AppState
    
    var title: String
    
    var body: some View {
        VStack(spacing: 0) {
            // 文件导航标题栏
            HStack {
                Text(title)
                    .font(ViewFont.navigationTitleFont)
                    .foregroundColor(ViewStyle.titleColor)
                Spacer()
                // 添加目录按钮
                Button(action: addDirectory) {
                    Image(systemName: "plus")
                        .foregroundColor(ViewStyle.titleColor)
                        .padding(ViewStyle.addButtonPadding)
                }
                .background(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: ViewStyle.addButtonCornerRadius)
                        .stroke(ViewStyle.titleColor, lineWidth: ViewStyle.addButtonBorderWidth)
                )
                .buttonStyle(PlainButtonStyle()) // 使用PlainButtonStyle
            }
            .padding(ViewStyle.titleBarPadding)
            .background(ViewStyle.backgroundColor)

            // 分隔线
            horizontalDivider()

            // 文件列表
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(appState.rootDirectories, id: \.self) { directory in
                        FileItemView(url: directory, expandedItems: $appState.expandedItems)
                    }
                }
            }
            .background(ViewStyle.backgroundColor)
        }
        .background(ViewStyle.backgroundColor)
    }
    
    // 添加目录的方法（待实现）
    private func addDirectory() {
        // 实现添加目录的逻辑
    }
}

// 文件项视图
struct FileItemView: View {
    let url: URL
    @Binding var expandedItems: Set<URL>
    @State private var children: [URL]?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 文件/文件夹行
            HStack {
                Image(systemName: url.hasDirectoryPath ? "folder" : "doc")
                    .foregroundColor(ViewStyle.fileItemIconColor)
                Text(url.lastPathComponent)
                    .font(ViewFont.fileItemFont)
                    .foregroundColor(ViewStyle.fileItemTextColor)
                Spacer()
                if url.hasDirectoryPath {
                    Image(systemName: expandedItems.contains(url) ? "chevron.down" : "chevron.right")
                        .foregroundColor(ViewStyle.fileItemIconColor)
                        .font(ViewFont.chevronFont)
                }
            }
            .padding(ViewStyle.fileItemPadding)
            .contentShape(Rectangle())
            .onTapGesture {
                if url.hasDirectoryPath {
                    toggleExpansion()
                }
            }

            // 展开的子项
            if url.hasDirectoryPath && expandedItems.contains(url) {
                ForEach(children ?? [], id: \.self) { childURL in
                    FileItemView(url: childURL, expandedItems: $expandedItems)
                        .padding(.leading, ViewStyle.childItemIndent)
                }
            }
        }
        .background(ViewStyle.backgroundColor) // 添加背景色
        .onAppear {
            print("FileItemView appeared for: \(url.lastPathComponent)")
        }
    }

    // 切换展开/折叠状态
    private func toggleExpansion() {
        if expandedItems.contains(url) {
            expandedItems.remove(url)
        } else {
            expandedItems.insert(url)
            loadChildren()
        }
    }

    // 加载子项
    private func loadChildren() {
        DispatchQueue.global(qos: .background).async {
            let fileManager = FileManager.default
            if let enumerator = fileManager.enumerator(at: url, includingPropertiesForKeys: [.isDirectoryKey], options: [.skipsHiddenFiles]) {
                let children = enumerator.compactMap { $0 as? URL }
                DispatchQueue.main.async {
                    self.children = children
                }
            }
        }
    }
}

