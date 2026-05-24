# CoreData-TodoList-demo

<p align="center">
  <img src="https://img.shields.io/badge/Swift-5.6-orange.svg" alt="Swift 5.6">
  <img src="https://img.shields.io/badge/iOS-16.0+-blue.svg" alt="iOS 16.0+">
  <img src="https://img.shields.io/badge/Xcode-14.0+-brightgreen.svg" alt="Xcode 14.0+">
  <img src="https://img.shields.io/badge/CoreData-Core-blue.svg" alt="CoreData">
  <img src="https://img.shields.io/badge/License-MIT-green.svg" alt="MIT License">
</p>

<p align="center">
  <b>Swift + CoreData 开发的 TodoList 示例应用</b>
</p>

## 项目简介

这是一个使用 Swift 和 CoreData 框架开发的 TodoList 待办事项应用示例。本项目展示了如何使用 CoreData 进行数据持久化，包括增删改查等基本操作，以及 SwiftUI 与 CoreData 的集成使用。

## 功能特性

- 添加待办事项
- 标记完成/未完成
- 编辑待办事项
- 删除待办事项
- 数据持久化存储
- 按状态筛选任务
- 优先级设置

## 技术栈

- **编程语言**: Swift 5.6
- **UI框架**: SwiftUI
- **数据持久化**: CoreData
- **开发环境**: Xcode 14.2+
- **最低支持系统**: iOS 16.0+

## 开发环境

| 工具 | 版本 |
|------|------|
| Xcode | 14.2 |
| Swift | 5.6 |
| iOS | 16.2 |

## 安装和运行

### 环境要求

- macOS 12.0 或更高版本
- Xcode 14.0 或更高版本
- iOS 16.0+ 模拟器或真机

### 安装步骤

1. 克隆仓库

```bash
git clone https://github.com/MoonStartMan/CoreData-TodoList-demo.git
```

2. 进入项目目录

```bash
cd CoreData-TodoList-demo
```

3. 打开 Xcode 工程

```bash
open CoreData-TodoList-demo.xcodeproj
```

4. 选择目标设备或模拟器，点击运行按钮 (Cmd+R)

## 项目结构

```
CoreData-TodoList-demo/
├── CoreData-TodoList-demo.xcodeproj
├── CoreData-TodoList-demo/
│   ├── CoreData_TodoList_demoApp.swift    # 应用入口
│   ├── Persistence.swift                   # CoreData 配置
│   ├── ContentView.swift                   # 主界面
│   ├── Views/                              # 视图文件夹
│   │   ├── AddTaskView.swift              # 添加任务视图
│   │   ├── EditTaskView.swift             # 编辑任务视图
│   │   └── TaskRowView.swift              # 任务列表项
│   ├── Models/                             # 数据模型
│   │   └── Task+CoreDataClass.swift       # 任务模型
│   ├── ViewModels/                         # 视图模型
│   │   └── TaskViewModel.swift            # 任务视图模型
│   └── Resources/                          # 资源文件
│       └── Assets.xcassets
└── README.md
```

## CoreData 使用示例

### 1. 定义数据模型

```swift
import CoreData

@objc(Task)
public class Task: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var isCompleted: Bool
    @NSManaged public var priority: Int16
    @NSManaged public var createdAt: Date
    @NSManaged public var dueDate: Date?
}
```

### 2. 创建任务

```swift
func addTask(title: String, priority: Int16 = 0) {
    let newTask = Task(context: viewContext)
    newTask.id = UUID()
    newTask.title = title
    newTask.isCompleted = false
    newTask.priority = priority
    newTask.createdAt = Date()
    
    do {
        try viewContext.save()
    } catch {
        print("Error saving task: \(error)")
    }
}
```

### 3. 查询任务

```swift
@FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \Task.createdAt, ascending: false)],
    animation: .default)
private var tasks: FetchedResults<Task>
```

### 4. 更新任务

```swift
func toggleTaskCompletion(_ task: Task) {
    task.isCompleted.toggle()
    
    do {
        try viewContext.save()
    } catch {
        print("Error updating task: \(error)")
    }
}
```

### 5. 删除任务

```swift
func deleteTask(_ task: Task) {
    viewContext.delete(task)
    
    do {
        try viewContext.save()
    } catch {
        print("Error deleting task: \(error)")
    }
}
```

## 核心功能实现

### SwiftUI 与 CoreData 集成

```swift
@main
struct CoreData_TodoList_demoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
```

### 任务列表视图

```swift
struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.createdAt, ascending: false)],
        animation: .default)
    private var tasks: FetchedResults<Task>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(tasks) { task in
                    TaskRowView(task: task)
                }
                .onDelete(perform: deleteTasks)
            }
            .navigationTitle("待办事项")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddTaskView()) {
                        Label("添加", systemImage: "plus")
                    }
                }
            }
        }
    }
    
    private func deleteTasks(offsets: IndexSet) {
        withAnimation {
            offsets.map { tasks[$0] }.forEach(viewContext.delete)
            try? viewContext.save()
        }
    }
}
```

## 截图

*应用截图待添加*

## 相关文章

- [知乎 - Swift + CoreData 开发 TodoList](https://zhuanlan.zhihu.com/p/604114545)

## 学习要点

1. **CoreData 基础**: 了解 CoreData 的基本概念和架构
2. **数据模型设计**: 学习如何设计 Entity 和 Attributes
3. **CRUD 操作**: 掌握增删改查的基本实现
4. **SwiftUI 集成**: 学习 @FetchRequest 和 @Environment 的使用
5. **数据迁移**: 了解版本控制和数据迁移

## 贡献指南

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/new-feature`)
3. 提交更改 (`git commit -m 'Add: 新功能'`)
4. 推送到分支 (`git push origin feature/new-feature`)
5. 打开 Pull Request

## 许可证

本项目采用 MIT 许可证 - 详情请参阅 [LICENSE](LICENSE) 文件

## 联系方式

- GitHub: [@MoonStartMan](https://github.com/MoonStartMan)
- 知乎: [MoonStartMan](https://zhuanlan.zhihu.com/p/604114545)

---

<p align="center">如果这个项目对您有帮助，请给个 ⭐️ 支持一下！</p>
