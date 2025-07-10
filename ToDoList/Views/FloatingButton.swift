//
//  FloatingButton.swift
//  ToDoList
//
//  Created by Дарья on 07.07.2025.
//

import SwiftUI

struct FloatingButton: View {
    @EnvironmentObject var dateHolder: DateHolder
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                NavigationLink(destination: TaskEditView(passedTaskItem: nil, initialDate: dateHolder.date)
                    .environmentObject(dateHolder)) {
                    HStack(spacing: 8) {
                        Image(systemName: "plus")
                        Text("New Task")
                    }
                    .font(.headline)
                    .padding(16)
                    .foregroundColor(.white)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]), startPoint: .top, endPoint: .bottom))
                    .cornerRadius(30)
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                    .padding(.trailing, 16)
                    .padding(.bottom, 8)
                }
            }
        }
    }
}
