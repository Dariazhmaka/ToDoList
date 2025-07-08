//
//  CheckBox.swift
//  ToDoList
//
//  Created by Дарья on 08.07.2025.
//

import SwiftUI

struct CheckBoxView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dateHolder: DateHolder
    @ObservedObject var passedTaskItem: TaskItem
    
    var body: some View {
        Image(systemName: passedTaskItem.isCompleted() ? "checkmark.circle.fill" : "circle")
            .foregroundColor(passedTaskItem.isCompleted() ? .green : .secondary)
            .onTapGesture {
                withAnimation {
                    guard !passedTaskItem.isCompleted() else {
                        passedTaskItem.completedDate = Date()
                    return dateHolder.saveContext(viewContext)
                    }
                }
            }
    }
}

struct CheckBoxView_Previews: PreviewProvider {
    static var previews: some View {
        CheckBoxView(passedTaskItem: TaskItem())
    }
}
