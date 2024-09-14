//
//  CanvasState.swift
//  CodingNode
//
//  Created by hirohi on 13/09/2024.
//

import Foundation

class CanvasState: ObservableObject {
    @Published var totalSize: CGSize
    @Published var visibleSize: CGSize
    
    init(totalSize: CGSize = CGSize(width: 2000, height: 2000), visibleSize: CGSize = .zero) {
        self.totalSize = totalSize
        self.visibleSize = visibleSize
    }
}