import SwiftUI
import AppKit
// 全局常量，用于选择当前主题
let CURRENT_THEME: ColorTheme = .custom("light")
// 定义颜色主题
enum ColorTheme {
    case dark
    case light
    case custom(String)
}

struct AppColors {
    static var currentTheme: ColorTheme = CURRENT_THEME
    
    static var color00: Color { getColor(for: .color00) }//阴影
    static var color01: Color { getColor(for: .color01) }//背景色1
    static var color02: Color { getColor(for: .color02) }//背景色2
    static var color03: Color { getColor(for: .color03) }
    static var color04: Color { getColor(for: .color04) }
    static var color05: Color { getColor(for: .color05) }
    static var color06: Color { getColor(for: .color06) }
    static var color07: Color { getColor(for: .color07) }
    static var color08: Color { getColor(for: .color08) }

    private enum ColorKey {
        case color00, color01, color02, color03, color04, color05, color06, color07, color08
    }

    private static func getColor(for key: ColorKey) -> Color {
        print("Current theme: \(currentTheme)") // 保留此行用于调试
        switch currentTheme {
        case .dark:
            return getDarkColor(for: key)
        case .light:
            print("Entering light theme") // 保留此行用于调试
            return getLightColor(for: key)
        case .custom(let name):
            if name == "light" {
                return getLightColor(for: key)
            } else if name == "dark" {
                return getDarkColor(for: key)
            } else {
                return getCustomColor(for: key, themeName: name)
            }
        }
    }

    private static func getDarkColor(for key: ColorKey) -> Color {
        switch key {
        case .color00: return Color(hex: "#000000")  // 深黑色（阴影）
        case .color01: return Color(hex: "#1E1E1E")  // 主背景色
        case .color02: return Color(hex: "#262626")  // 次要背景色
        case .color03: return Color(hex: "#363636")  // 三级背景色
        case .color04: return Color(hex: "#5A5A5A")  // 暗灰色（次要文本）
        case .color05: return Color(hex: "#9E9E9E")  // 中灰色（占位符文本）
        case .color06: return Color(hex: "#DADADA")  // 浅灰色（主要文本）
        case .color07: return Color(hex: "#262626")  // 按钮特殊色1
        case .color08: return Color(hex: "#5A5A5A")  // 按钮特殊色2
        }
    }

    private static func getLightColor(for key: ColorKey) -> Color {
        switch key {
        case .color00: return Color(hex: "#E5E5E5")  // 浅灰色（阴影）
        case .color01: return Color(hex: "#FFFFFF")  // 主背景色
        case .color02: return Color(hex: "#F5F5F5")  // 次要背景色
        case .color03: return Color(hex: "#EAEAEA")  // 三级背景色
        case .color04: return Color(hex: "#9E9E9E")  // 中灰色（次要文本）
        case .color05: return Color(hex: "#363636")  // 深灰色（主要文本，带透明度）
        case .color06: return Color(hex: "#1E1E1E")  // 黑色（主要文本）
        case .color07: return Color(hex: "#FAFAFA")  // 按钮特殊色1
        case .color08: return Color(hex: "#9E9E9E")  // 按钮特殊色2
        }
    }

    private static func getCustomColor(for key: ColorKey, themeName: String) -> Color {
        if themeName == "Nature" {
            switch key {
            case .color00: return Color(hex: "#001F3F")
            case .color01: return Color(hex: "#003366")
            case .color02: return Color(hex: "#004080")
            case .color03: return Color(hex: "#0059B3")
            case .color04: return Color(hex: "#66A3D2")
            case .color05: return Color(hex: "#99C2E1")
            case .color06: return Color(hex: "#E6F2FF")
            case .color07: return Color(hex: "#004080")
            case .color08: return Color(hex: "#66A3D2")
            }
        }
        return getDarkColor(for: key)
    }
}


// SwiftUI 的 Color 扩展，支持从 Hex 转换为 Color
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 6:
            (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: 1
        )
    }
}

// AppKit 的 NSColor 扩展，支持从 Hex 转换为 NSColor
extension NSColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 6:
            (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (0, 0, 0)
        }
        self.init(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: 1.0
        )
    }
}
