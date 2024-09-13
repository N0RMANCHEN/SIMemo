
//这个文件的主要功能是定义一个 Node 类，
//用于表示一个代码节点。

import Foundation
import CoreGraphics

// Node 类表示一个可观察的、可识别的节点对象
class Node: ObservableObject, Identifiable {
    // 唯一标识符
    let id = UUID()
    
    // 节点的代码内容，可发布以便观察变化
    @Published var code: String
    
    // 节点在界面上的位置，可发布以便观察变化
    @Published var position: CGPoint
    
    @Published var size: CGSize  // 添加这行
    
    // 初始化方法
    // code: 节点的代码内容
    // position: 节点的初始位置，默认为 (100, 100)
    init(code: String, position: CGPoint, size: CGSize = CGSize(width: 150, height: 75)) {
        self.code = code
        self.position = position
        self.size = size  // 初始化 size
    }
}
