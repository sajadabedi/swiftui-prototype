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
                    HStack {
                        Image(systemName: todo.isDone ? "checkmark.circle.fill" : "circle")
                            .onTapGesture {
                                model.toggle(todo)
                            }
                        Text(todo.title)
                            .strikethrough(todo.isDone)
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

#Preview {
    TodoListView()
        .environment(TodoList())
}
