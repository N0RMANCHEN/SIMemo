
//这个文件定义了应用程序使用的颜色主题。

import SwiftUI
import AppKit

// 定义颜色色卡
struct AppColors {
    static let black00 = Color(hex: "#000000")  // Black_00
    static let black0 = Color(hex: "#1E1E1E")  // Black_0
    static let black1 = Color(hex: "#262626")  // Black_1
    static let black2 = Color(hex: "#363636")  // Black_2
    static let gray0 = Color(hex: "#5A5A5A")  // Gray_0
    static let gray1 = Color(hex: "#9E9E9E")  // Gray_1
    static let white0 = Color(hex: "#DADADA") // White_0
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
