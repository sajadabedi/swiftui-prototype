//
//  Todo.swift
//  Prototypes
//
//  Created by Sajjad Abedi on 03.06.2025.
//
import SwiftUI
import Observation

struct TodoItem: Identifiable, Equatable {
    let id = UUID()
    let title: String
    var isDone: Bool = false
}

@Observable
class TodoList {
    var todos: [TodoItem] = []
    
    func addTodo(_ title: String) {
        guard !title.isEmpty else { return }
        todos.append(.init(title: title))
    }
    
    func toggle(_ todo: TodoItem) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index].isDone.toggle()
        }
    }
    
    func delete(at offsets: IndexSet) {
        todos.remove(atOffsets: offsets)
    }
}
