//
//  TaskFilter.swift
//  ToDoList
//
//  Created by Дарья on 08.07.2025.
//

import SwiftUI

enum TaskFilter: String {
    static var allFilters: [TaskFilter] {
        return [.NonCompleted,.Completed, .All]
    }
    
    case All = "All"
    case NonCompleted = "To Do"
    case Completed = "Completed"
}
