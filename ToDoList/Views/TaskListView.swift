//
//  ContentView.swift
//  ToDoList
//
//  Created by Дарья on 07.07.2025.
//

import SwiftUICore
import SwiftUI

struct TaskListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dateHolder: DateHolder
    
    @State var selectedFilter = TaskFilter.NonCompleted
    @State private var showingIconPicker = false
    @State private var selectedTaskForIcon: TaskItem?
    
    private let accentColor = Color.blue
    private let backgroundColor = Color(.systemGroupedBackground)
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    DateScroller()
                        .padding(.horizontal)
                        .padding(.top, 8)
                        .background(Color(.systemBackground))
                    
                    if filteredTaskItems().isEmpty {
                        emptyStateView
                    } else {
                        taskList
                    }
                    
                    Spacer()
                }
                
                FloatingButton()
                    .environmentObject(dateHolder)
            }
            .navigationTitle("To Do List")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    filterPicker
                }
            }
            .sheet(isPresented: $showingIconPicker) {
                if let task = selectedTaskForIcon {
                    iconPickerView(for: task)
                }
            }
        }
        .accentColor(accentColor)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "checklist")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            
            Text("No tasks for this day")
                .font(.headline)
                .foregroundColor(.secondary)
            
            if selectedFilter != .All {
                Button(action: {
                    selectedFilter = .All
                }) {
                    Text("Show all tasks")
                        .foregroundColor(accentColor)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
    
    private var taskList: some View {
        List {
            ForEach(filteredTaskItems()) { taskItem in
                taskRow(for: taskItem)
                    .listRowBackground(Color(.systemBackground))
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            deleteTask(taskItem)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
            }
            .onDelete(perform: deleteItems)
        }
        .listStyle(.plain)
        .background(backgroundColor)
    }
    
    private func taskRow(for taskItem: TaskItem) -> some View {
        NavigationLink(
            destination: TaskEditView(
                passedTaskItem: taskItem,
                initialDate: taskItem.dueDate!
            )
            .environmentObject(dateHolder)
        ) {
            HStack(spacing: 12) {
                iconButton(for: taskItem)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(taskItem.name ?? "")
                        .font(.headline)
                        .strikethrough(taskItem.isCompleted(), color: .gray)
                        .foregroundColor(taskItem.isCompleted() ? .secondary : .primary)
                    
                    if let desc = taskItem.descript, !desc.isEmpty {
                        Text(desc)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                }
                
                Spacer()
                
                if !taskItem.isCompleted() && taskItem.scheduleTime {
                    Text(taskItem.dueDateTimeOnly())
                        .font(.subheadline)
                        .foregroundColor(taskItem.overDueColor())
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(taskItem.overDueColor().opacity(0.1))
                        )
                }
            }
            .padding(.vertical, 8)
        }
    }
    
    private func deleteTask(_ task: TaskItem) {
        withAnimation {
            viewContext.delete(task)
            dateHolder.saveContext(viewContext)
        }
    }
    

    private func iconButton(for taskItem: TaskItem) -> some View {
        Button(action: {
            selectedTaskForIcon = taskItem
            showingIconPicker.toggle()
        }) {
            Image(systemName: taskItem.icon ?? "paperclip")
                .font(.system(size: 20))
                .frame(width: 30, height: 30)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var filterPicker: some View {
        Picker("", selection: $selectedFilter.animation()) {
            ForEach(TaskFilter.allFilters, id: \.self) { filter in
                Text(filter.rawValue)
            }
        }
    }
    
    private func iconPickerView(for task: TaskItem) -> some View {
        IconPickerView(
            selectedIcon: Binding(
                get: { task.icon ?? "circle.fill" },
                set: { newValue in
                    task.icon = newValue
                    dateHolder.saveContext(viewContext)
                }
            )
        )
    }
    
    private func filteredTaskItems() -> [TaskItem] {
        switch selectedFilter {
        case .Completed:
            return dateHolder.taskItems.filter { $0.isCompleted() }
        case .NonCompleted:
            return dateHolder.taskItems.filter { !$0.isCompleted() }
        default:
            return dateHolder.taskItems
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { filteredTaskItems()[$0] }.forEach(viewContext.delete)
            dateHolder.saveContext(viewContext)
        }
    }
}

struct IconPickerView: View {
    @Binding var selectedIcon: String
    @Environment(\.presentationMode) var presentationMode
    
    let columns = [GridItem(.adaptive(minimum: 50))]
    let icons = [
        "paperclip", "flag.fill", "star.fill", "heart.fill",
        "bookmark.fill", "bell.fill", "tag.fill", "bolt.fill",
        "hourglass", "lightbulb.fill", "pencil.circle", "trash.fill",
        "folder.fill", "tray.fill", "calendar", "alarm.fill",
        "cart.fill", "gift.fill", "creditcard.fill", "house.fill"
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(icons, id: \.self) { icon in
                            iconButton(icon: icon)
                        }
                    }
                    .padding()
                }
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Закрыть")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .navigationTitle("Выберите иконку")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if selectedIcon.isEmpty {
                    selectedIcon = "paperclip"
                }
            }
        }
    }
    
    private func iconButton(icon: String) -> some View {
        Button(action: {
            selectedIcon = icon
        }) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .frame(width: 40, height: 40)
                .foregroundColor(icon == selectedIcon ? .blue : .primary)
                .padding(8)
                .background(icon == selectedIcon ? Color.blue.opacity(0.1) : Color.clear)
                .cornerRadius(8)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(DateHolder(PersistenceController.preview.container.viewContext))
    }
}
