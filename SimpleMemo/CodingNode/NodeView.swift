import SwiftUI  // 导入SwiftUI框架，用于构建用户界面

struct NodeView: View {  // 定义一个名为NodeView的结构体，遵循View协议
    @ObservedObject var node: Node  // 声明一个可观察对象属性，用于存储节点数据
    @Binding var selectedNode: Node?  // 声明一个绑定属性，用于跟踪选中的节点

    var body: some View {  // 定义视图的主体
        VStack {  // 创建一个垂直堆栈
            Text(node.code)  // 显示节点的代码文本
                .padding()  // 为文本添加内边距
                .background(Color.gray)  // 设置灰色背景
                .cornerRadius(10)  // 添加圆角
                .shadow(radius: 5)  // 添加阴影效果
        }
        .onTapGesture {  // 添加点击手势
            selectedNode = node  // 当节点被点击时，更新选中的节点
        }
        .position(x: node.position.x, y: node.position.y)  // 设置节点的位置
        .gesture(  // 添加拖动手势
            DragGesture()
                .onChanged { value in  // 当拖动发生变化时
                    node.position = value.location  // 更新节点位置
                }
        )
    }
}
