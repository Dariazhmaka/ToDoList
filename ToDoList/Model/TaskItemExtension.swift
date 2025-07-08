//
//  TaskItemExtension.swift
//  ToDoList
//
//  Created by Дарья on 08.07.2025.
//

import SwiftUI

extension TaskItem
{
    
    func isCompleted() -> Bool
    {
        return completedDate != nil
    }
    
    func isOverdue() -> Bool
    {
        if let due = dueDate
        {
            return !isCompleted() && scheduleTime && due < Date()
        }
        return false
    }
    
    func overDueColor() -> Color
    {
        return isOverdue() ? .red : .black
    }
    
    
    func dueDateTimeOnly() -> String
    {
        if let due = dueDate
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            return dateFormatter.string(from: due)
        }
        
        return ""
    }
}
