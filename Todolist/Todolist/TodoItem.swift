// TodoItem.swift
import Foundation

struct TodoItem: Identifiable, Codable {
    let id = UUID()
    var title: String
    var isCompleted: Bool = false
}
