import Foundation

class TodoViewModel: ObservableObject {
    @Published var items: [TodoItem] = [] {
        didSet {
            saveItems()
        }
    }

    private let itemsKey = "todo_items"

    init() {
        loadItems()
    }

    func addItem(title: String) {
        let newItem = TodoItem(title: title)
        items.append(newItem)
    }

    func toggleCompletion(for item: TodoItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isCompleted.toggle()
        }
    }

    func deleteItem(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }

    func editItem(item: TodoItem, newTitle: String) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].title = newTitle
        }
    }

    private func saveItems() {
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: itemsKey)
        }
    }

    private func loadItems() {
        if let data = UserDefaults.standard.data(forKey: itemsKey),
           let savedItems = try? JSONDecoder().decode([TodoItem].self, from: data) {
            items = savedItems
        }
    }
}
