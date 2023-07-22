//
//  TodoAppSwifftUIApp.swift
//  TodoAppSwifftUI
//
//  Created by Medeu Pazylov on 19.07.2023.
//

import SwiftUI

@main
struct TodoAppSwifftUIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(todoItems: items)
        }
    }
}

var items: [TodoItem] = [
    .init(text: "Do Homework", priority: .medium, isDone: false),
    .init(text: "Clean a room", priority: .low, isDone: false),
    .init(text: "Buy chocolate", priority: .medium, isDone: false),
    .init(text: "Go home", priority: .medium, isDone: true),
    .init(text: "Read and comment the book", priority: .high, isDone: false),
    .init(text: "Make dinner for friends", priority: .medium, isDone: true),
    .init(text: "Buy chocolate", priority: .medium, isDone: false),
    .init(text: "Go home", priority: .medium, isDone: true),
    .init(text: "Read and comment the book", priority: .high, isDone: false),
    .init(text: "Make dinner for friends", priority: .medium, isDone: true),
    .init(text: "Buy chocolate", priority: .medium, isDone: false),
    .init(text: "Go home", priority: .medium, isDone: true),
    .init(text: "Read and comment the book", priority: .high, isDone: false),
    .init(text: "Make dinner for friends", priority: .medium, isDone: true),
]
