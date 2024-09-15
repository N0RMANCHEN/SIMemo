
//这个文件定义了应用程序的委托，处理一些应用级别的事件。

import Foundation
import Cocoa

// 应用程序委托类，处理应用级别的事件
class AppDelegate: NSObject, NSApplicationDelegate {
    // 当最后一个窗口关闭时终止应用程序
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}