//
//  NodeViewModel.swift
//  CodingNode
//
//  Created by 陈博飞 on 2024/9/12.
//
import SwiftUI
import AppKit  // 添加这行以使用 NSCursor

import Foundation

class NodeViewModel: ObservableObject, Identifiable {
    let id = UUID()  // 添加这行来满足 Identifiable 协议
    @Published var node: Node
    @Published var isSelected: Bool = false
    @Published var isResizing: Bool = false
    
    // 添加对最小尺寸的引用
    let minNodeWidth: CGFloat
    let minNodeHeight: CGFloat

    init(node: Node, minNodeWidth: CGFloat = 150, minNodeHeight: CGFloat = 75) {
        self.node = node
        self.minNodeWidth = minNodeWidth
        self.minNodeHeight = minNodeHeight
    }

    var position: Binding<CGPoint> {
        Binding(
            get: { self.node.position },
            set: { self.node.position = $0 }
        )
    }

    var size: Binding<CGSize> {
        Binding(
            get: { self.node.size },
            set: { self.node.size = $0 }
        )
    }

    func updatePosition(_ newPosition: CGPoint) {
        node.position = newPosition
    }

    func updateSize(_ newSize: CGSize) {
        node.size = CGSize(
            width: max(newSize.width, minNodeWidth),
            height: max(newSize.height, minNodeHeight)
        )
    }

    func select() {
        isSelected = true
    }

    func deselect() {
        isSelected = false
    }

    func startResizing() {
        isResizing = true
    }

    func stopResizing() {
        isResizing = false
    }
}