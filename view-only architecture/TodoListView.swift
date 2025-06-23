//
//  TodoListView.swift
//  Prototypes
//
//  Created by Sajjad Abedi on 03.06.2025.
//

import SwiftUI

struct TodoListView: View {
    @Environment(TodoList.self) private var model
    @State private var newTask = ""
    var body: some View {
        NavigationStack {
            List {
                ForEach(model.todos) { todo in
                    TodoRowView(todo: todo) {
                        model.toggle(todo)
                    }
                }
            }
            .navigationTitle("Todo List")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        TextField("New Task", text: $newTask)
                            .textFieldStyle(.roundedBorder)
                        Button("Add") {
                            model.addTodo(newTask)
                            newTask = ""
                        }

                    }
                }
            }
        }
    }
}

struct TodoRowView: View {
    let todo: TodoItem
    let onToggle: () -> Void
    var body: some View {
        HStack {
            Image(systemName: todo.isDone ? "checkmark.circle.fill" : "circle")
                .onTapGesture {
                    onToggle()
                }
            Text(todo.title)
                .strikethrough(todo.isDone)
        }
    }
}

#Preview {
    TodoListView()
        .environment(TodoList())
}
