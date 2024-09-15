import SwiftUI

struct FontManager {
        /// 标题字体
        static let titleFont = Font.custom("SF Pro", size: 14)
        
        /// 代码字体
        static let codeFont = Font.system(.body, design: .monospaced)
    }
    
    // 可以在这里添加其他视图的字体设置
    // 例如：
    // struct MainView { ... }
    // struct SettingsView { ... }

