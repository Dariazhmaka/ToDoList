//
//  TaskEditView.swift
//  ToDoList
//
//  Created by Дарья on 07.07.2025.
//

import SwiftUI

struct TaskEditView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dateHolder: DateHolder
    
    @State private var selectedTaskItem: TaskItem?
    @State private var name: String
    @State private var descript: String
    @State private var dueDate: Date
    @State private var scheduleTime: Bool
    
    init(passedTaskItem: TaskItem?, initialDate: Date) {
        let noData = ""
        if let taskItem = passedTaskItem {
            _selectedTaskItem = State(initialValue: taskItem)
            _name = State(initialValue: taskItem.name ?? noData)
            _descript = State(initialValue: taskItem.descript ?? noData)
            _dueDate = State(initialValue: taskItem.dueDate ?? initialDate)
            _scheduleTime = State(initialValue: taskItem.scheduleTime)
        }
        else {
            _name = State(initialValue: noData)
            _descript = State(initialValue: noData)
            _dueDate = State(initialValue: initialDate)
            _scheduleTime = State(initialValue: false)
        }
    }
    
    var body: some View {
        Form {
            Section(header: Text("Task Details").font(.headline)) {
                TextField("Task Name", text: $name)
                    .font(.body)
                TextField("Description", text: $descript)
                    .font(.body)
            }
            
            Section(header: Text("Due Date").font(.headline)) {
                Toggle("Include Time", isOn: $scheduleTime)
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                DatePicker(
                    "Due Date",
                    selection: $dueDate,
                    displayedComponents: displayComps()
                )
                .datePickerStyle(.graphical)
            }
            
            if selectedTaskItem != nil {
                Section {
                    Button(action: toggleCompletion) {
                        HStack {
                            Spacer()
                            Text(selectedTaskItem?.isCompleted() ?? false ? "Mark as Incomplete" : "Mark as Complete")
                                .font(.headline)
                                .bold()
                            Spacer()
                        }
                    }
                    .tint(selectedTaskItem?.isCompleted() ?? false ? .orange : .green)
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
                .listRowBackground(Color.clear)
            }
            
            Section {
                Button(action: saveAction) {
                    HStack {
                        Spacer()
                        Text("Save Task")
                            .font(.headline)
                            .bold()
                        Spacer()
                    }
                }
                .tint(.blue)
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            .listRowBackground(Color.clear)
        }
        .navigationTitle(selectedTaskItem == nil ? "New Task" : "Edit Task")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func toggleCompletion() {
        withAnimation {
            if let task = selectedTaskItem {
                if task.isCompleted() {
                    task.completedDate = nil
                } else {
                    task.completedDate = Date()
                }
                dateHolder.saveContext(viewContext)
            }
        }
    }
    
    func displayComps() -> DatePickerComponents {
        return scheduleTime ? [.hourAndMinute, .date] : [.date]
    }
    
    func saveAction() {
        withAnimation {
            if selectedTaskItem == nil {
                selectedTaskItem = TaskItem(context: viewContext)
            }
            
            selectedTaskItem?.created = Date()
            selectedTaskItem?.name = name
            selectedTaskItem?.descript = descript
            selectedTaskItem?.dueDate = dueDate
            selectedTaskItem?.scheduleTime = scheduleTime
            
            dateHolder.saveContext(viewContext)
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    struct TaskEditView_Previews: PreviewProvider {
        static var previews: some View {
            TaskEditView(passedTaskItem: TaskItem(), initialDate: Date())
        }
    }
}
