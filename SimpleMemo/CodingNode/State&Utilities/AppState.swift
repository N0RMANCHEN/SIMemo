//这个文件定义了应用程序的状态。
//它是一个可观察对象，包含了应用程序的核心数据，
//如节点列表、选中的节点、根目录、展开的项目以及界面的宽度设置等。
//它作为整个应用的数据中心。

import SwiftUI
import Combine

// AppState 类负责管理整个应用程序的状态
class AppState: ObservableObject {

    @Published var nodeViewModels: [NodeViewModel] = []
    @Published var selectedNodeViewModel: NodeViewModel?

    // 保留这些属性
    @Published var rootDirectories: [URL] = []
    @Published var expandedItems: Set<URL> = []
    @Published var navigationWidth: CGFloat = 200
    @Published var codeCanvasWidth: CGFloat = 350

    init() {
        // 初始化 nodeViewModels
        self.nodeViewModels = [
            NodeViewModel(node: Node(code: "def add(a, b):\n    return a + b", position: CGPoint(x: 200, y: 200))),
            NodeViewModel(node: Node(code: "def subtract(a, b):\n    return a - b", position: CGPoint(x: 100, y: 100)))
        ]
        loadRootDirectories()
    }

    func selectNode(_ viewModel: NodeViewModel) {
        selectedNodeViewModel?.deselect()
        viewModel.select()
        selectedNodeViewModel = viewModel
    }
    
    func deselectAllNodes() {
        selectedNodeViewModel?.deselect()
        selectedNodeViewModel = nil
    }

    private func loadRootDirectories() {
        if let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            rootDirectories = [documentsURL]
            print("Root directory loaded: \(documentsURL.path)")
        }
    }
}