import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TodoViewModel()
    @State private var newTaskTitle = ""
    @State private var isEditing = false
    @State private var editingTask: TodoItem?

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Enter new task", text: $newTaskTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: {
                        if isEditing {
                            if let editingTask = editingTask {
                                viewModel.editItem(item: editingTask, newTitle: newTaskTitle)
                                self.isEditing = false
                            }
                        } else {
                            viewModel.addItem(title: newTaskTitle)
                        }
                        newTaskTitle = ""
                    }) {
                        Text(isEditing ? "Save" : "Add")
                    }
                    .padding(.leading, 8)
                    .disabled(newTaskTitle.isEmpty)
                }
                .padding()

                List {
                    ForEach(viewModel.items) { item in
                        HStack {
                            Text(item.title)
                            Spacer()
                            if item.isCompleted {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            } else {
                                Image(systemName: "circle")
                                    .foregroundColor(.gray)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.toggleCompletion(for: item)
                        }
                        .onLongPressGesture {
                            editingTask = item
                            newTaskTitle = item.title
                            isEditing = true
                        }
                    }
                    .onDelete(perform: viewModel.deleteItem)
                }
            }
            .navigationTitle("To-Do List")
            .toolbar {
                Button(action: {
                    if let index = viewModel.items.firstIndex(where: { $0.title == newTaskTitle }) {
                        viewModel.deleteItem(at: IndexSet(integer: index))
                    }
                }) {
                    Image(systemName: "trash")
                }
                .disabled(newTaskTitle.isEmpty)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
