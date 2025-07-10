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
            Button(action: toggleCompletion) {
                Image(systemName: passedTaskItem.isCompleted() ? "checkmark.circle.fill" : "circle")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(passedTaskItem.isCompleted() ? .green : .gray)
            }
            .buttonStyle(PlainButtonStyle())
        }
        
        private func toggleCompletion() {
            withAnimation(.spring()) {
                if passedTaskItem.isCompleted() {
                    passedTaskItem.completedDate = nil
                } else {
                    passedTaskItem.completedDate = Date()
                }
                dateHolder.saveContext(viewContext)
            }
        }
    }

struct CheckBoxView_Previews: PreviewProvider {
    static var previews: some View {
        CheckBoxView(passedTaskItem: TaskItem())
    }
}
