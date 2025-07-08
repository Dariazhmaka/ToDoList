//
//  DateScroller.swift
//  ToDoList
//
//  Created by Дарья on 08.07.2025.
//

import SwiftUI

struct DateScroller: View {
    @EnvironmentObject var dateHolder: DateHolder
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showingDatePicker = false
    
    var body: some View {
        HStack {
            Button(action: moveBack) {
                Image(systemName: "chevron.left")
                    .padding(10)
                    .background(Color.blue.opacity(0.2))
                    .clipShape(Circle())
                    .foregroundColor(.blue)
            }
            
            Spacer()
            
            Button(action: { showingDatePicker.toggle() }) {
                VStack(alignment: .center, spacing: 4) {
                    Text(dayOfWeekFormatted())
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                    Text(dayAndMonthFormatted())
                        .font(.system(size: 18, weight: .semibold))
                    Text(yearFormatted())
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                )
            }
            .sheet(isPresented: $showingDatePicker) {
                datePickerView()
            }
            
            Spacer()
            
            Button(action: moveForward) {
                Image(systemName: "chevron.right")
                    .padding(10)
                    .background(Color.blue.opacity(0.2))
                    .clipShape(Circle())
                    .foregroundColor(.blue)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
    
    private func datePickerView() -> some View {
        VStack {
            DatePicker(
                "Select Date",
                selection: $dateHolder.date,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            .padding()
            .onChange(of: dateHolder.date) {
                dateHolder.refreshTaskItems(viewContext)
                showingDatePicker = false
            }
            
            Button("Done") {
                showingDatePicker = false
            }
            .padding()
        }
        .presentationDetents([.medium])
    }
    
    func dayOfWeekFormatted() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: dateHolder.date)
    }
    
    func dayAndMonthFormatted() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        return dateFormatter.string(from: dateHolder.date)
    }
    
    func yearFormatted() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: dateHolder.date)
    }
    
    func moveBack() {
        withAnimation(.easeInOut(duration: 0.2)) {
            dateHolder.moveDate(-1, viewContext)
        }
    }
    
    func moveForward() {
        withAnimation(.easeInOut(duration: 0.2)) {
            dateHolder.moveDate(1, viewContext)
        }
    }
}
