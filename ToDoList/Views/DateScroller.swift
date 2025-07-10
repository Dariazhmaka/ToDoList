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
    
    private let buttonSize: CGFloat = 40
    
    var body: some View {
        HStack {
            dateNavigationButton(icon: "chevron.left", action: moveBack)
            
            Spacer()
            
            dateDisplayButton
            
            Spacer()
            
            dateNavigationButton(icon: "chevron.right", action: moveForward)
        }
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
        .sheet(isPresented: $showingDatePicker) {
            datePickerView()
        }
    }
    
    private var dateDisplayButton: some View {
        Button(action: { showingDatePicker.toggle() }) {
            VStack(alignment: .center, spacing: 2) {
                Text(dayOfWeekFormatted().uppercased())
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
                
                Text(dayAndMonthFormatted())
                    .font(.system(size: 20, weight: .semibold))
                
                Text(yearFormatted())
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 20)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
            )
        }
    }
    
    private func dateNavigationButton(icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .bold))
                .frame(width: buttonSize, height: buttonSize)
                .background(Color.blue.opacity(0.2))
                .foregroundColor(.blue)
                .clipShape(Circle())
        }
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
            
            Button(action: {
                showingDatePicker = false
            }) {
                Text("Done")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
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
