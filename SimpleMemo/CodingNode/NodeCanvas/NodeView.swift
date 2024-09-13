import SwiftUI
import AppKit  // 添加这行以使用 NSCursor

// 定义视图样式和可调节参数
struct NodeViewStyle {
    // Node的最小尺寸
    static let minNodeWidth: CGFloat = 150
    static let minNodeHeight: CGFloat = 75
    
    // 颜色设置
    static let backgroundColor = AppColors.black0
    static let selectedColor = AppColors.black1
    static let borderColor = AppColors.black2
    static let shadowColor = AppColors.black00.opacity(0.3)
    static let textColor = AppColors.white0
    
    // 布局参数
    static let padding: CGFloat = 10
    static let cornerRadius: CGFloat = 5
    static let shadowRadius: CGFloat = 4
    static let borderWidth: CGFloat = 1
    
    // 阴影偏移
    static let shadowOffsetX: CGFloat = 3
    static let shadowOffsetY: CGFloat = 3
}

// 定义一个自定义的 ViewModifier 用于实现可调整大小的功能
struct ResizableNodeModifier: ViewModifier {
    @Binding var size: CGSize
    let minSize: CGSize
    @GestureState private var dragOffset: CGSize = .zero
    
    func body(content: Content) -> some View {
        content
            .frame(width: max(size.width, minSize.width),
                   height: max(size.height, minSize.height))
            .overlay(
                GeometryReader { geometry in
                    Color.clear
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture()
                                .updating($dragOffset) { value, state, _ in
                                    state = value.translation
                                }
                                .onEnded { value in
                                    self.size = CGSize(
                                        width: max(size.width + value.translation.width, minSize.width),
                                        height: max(size.height + value.translation.height, minSize.height)
                                    )
                                }
                        )
                }
            )
    }
}

// 扩展 View 以添加一个方便的修饰符函数
extension View {
    func resizableNode(size: Binding<CGSize>, minSize: CGSize) -> some View {
        self.modifier(ResizableNodeModifier(size: size, minSize: minSize))
    }
}

// NodeView: 表示画布上单个节点的视图
struct NodeView: View {
    @ObservedObject var viewModel: NodeViewModel
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var canvasState: CanvasState
    @State private var dragState = DragState.inactive
    @State private var dragOffset: CGSize = .zero
    @State private var isOverlapping: Bool = false

    var body: some View {
        VStack {
            Text(viewModel.node.code)
                .foregroundColor(NodeViewStyle.textColor)
                .padding(NodeViewStyle.padding)
        }
        .frame(width: viewModel.node.size.width, height: viewModel.node.size.height)
        .background(backgroundColor)
        .cornerRadius(NodeViewStyle.cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: NodeViewStyle.cornerRadius)
                .stroke(NodeViewStyle.borderColor, lineWidth: NodeViewStyle.borderWidth)
        )
        .shadow(color: NodeViewStyle.shadowColor, 
                radius: NodeViewStyle.shadowRadius, 
                x: NodeViewStyle.shadowOffsetX, 
                y: NodeViewStyle.shadowOffsetY)
        .position(
            x: min(max(viewModel.node.position.x, viewModel.node.size.width / 2), canvasState.visibleSize.width - viewModel.node.size.width / 2) + dragOffset.width,
            y: min(max(viewModel.node.position.y, viewModel.node.size.height / 2), canvasState.visibleSize.height - viewModel.node.size.height / 2) + dragOffset.height
        )
        .gesture(dragGesture)
        .opacity(isOverlapping ? 0.5 : 1.0)
    }

    private var backgroundColor: Color {
        switch dragState {
        case .inactive:
            return viewModel.isSelected ? NodeViewStyle.selectedColor : NodeViewStyle.backgroundColor
        case .dragging:
            return NodeViewStyle.selectedColor
        }
    }

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                if case .inactive = dragState {
                    dragState = .dragging(translation: .zero)
                    appState.selectNode(viewModel)
                }
                let newPosition = CGPoint(
                    x: viewModel.node.position.x + value.translation.width,
                    y: viewModel.node.position.y + value.translation.height
                )
                let limitedPosition = limitPositionToCanvas(newPosition)
                
                dragOffset = CGSize(
                    width: limitedPosition.x - viewModel.node.position.x,
                    height: limitedPosition.y - viewModel.node.position.y
                )
                
                // 检查是否与其他节点重叠
                isOverlapping = checkOverlapping(at: limitedPosition)
            }
            .onEnded { _ in
                dragState = .inactive
                viewModel.node.position = CGPoint(
                    x: viewModel.node.position.x + dragOffset.width,
                    y: viewModel.node.position.y + dragOffset.height
                )
                dragOffset = .zero
                isOverlapping = false  // 重置重叠状态
            }
    }

    private func limitPositionToCanvas(_ position: CGPoint) -> CGPoint {
        let nodeSize = viewModel.node.size
        return CGPoint(
            x: max(nodeSize.width / 2, min(position.x, canvasState.visibleSize.width - nodeSize.width / 2)),
            y: max(nodeSize.height / 2, min(position.y, canvasState.visibleSize.height - nodeSize.height / 2))
        )
    }

    private func checkOverlapping(at position: CGPoint) -> Bool {
        for otherViewModel in appState.nodeViewModels where otherViewModel.id != viewModel.id {
            if nodesOverlap(node1: (position, viewModel.node.size), node2: (otherViewModel.node.position, otherViewModel.node.size)) {
                return true
            }
        }
        return false
    }

    private func nodesOverlap(node1: (position: CGPoint, size: CGSize), node2: (position: CGPoint, size: CGSize)) -> Bool {
        let left1 = node1.position.x - node1.size.width / 2
        let right1 = node1.position.x + node1.size.width / 2
        let top1 = node1.position.y - node1.size.height / 2
        let bottom1 = node1.position.y + node1.size.height / 2

        let left2 = node2.position.x - node2.size.width / 2
        let right2 = node2.position.x + node2.size.width / 2
        let top2 = node2.position.y - node2.size.height / 2
        let bottom2 = node2.position.y + node2.size.height / 2

        return !(left1 > right2 || right1 < left2 || top1 > bottom2 || bottom1 < top2)
    }
}

enum DragState {
    case inactive
    case dragging(translation: CGSize)

    var translation: CGSize {
        switch self {
        case .inactive:
            return .zero
        case .dragging(let translation):
            return translation
        }
    }

    var isActive: Bool {
        switch self {
        case .inactive:
            return false
        case .dragging:
            return true
        }
    }
}
