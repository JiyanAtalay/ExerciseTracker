//
//  DetailsView.swift
//  ExerciseTracker
//
//  Created by Mehmet Jiyan Atalay on 22.07.2024.
//

import SwiftUI
import SwiftData

struct DetailsView: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var exercises: [Exercises] = [Exercises(minute: 0, exerciseName: "", day: 0)]
    
    @FocusState private var isInputActive: Bool
    
    var item : Item
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Text("\(item.getMonthName() ?? "") Egzersizleri")
                        .font(.largeTitle)
                        .padding()
                    
                    Text("Toplam : \(item.totalMinute)dk")
                        .font(.title2)
                    
                    ForEach(0..<exercises.count, id: \.self) { index in
                        GroupBox {
                            VStack {
                                HStack {
                                    TextField("Enter exercise", text: $exercises[index].exerciseName)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .focused($isInputActive)
                                }.padding(.vertical, 5)
                                
                                HStack {
                                    TextField("Enter minute", text: Binding(get: {
                                        String(exercises[index].minute)
                                    }, set: {
                                        if let value = Int($0) {
                                            exercises[index].minute = value
                                        }
                                    }))
                                    .keyboardType(.numberPad)
                                    .focused($isInputActive)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .onChange(of: exercises[index].minute) {
                                        item.totalMinute = exercises.reduce(0) { $0 + $1.minute}
                                    }
                                    
                                    Picker("", selection: $exercises[index].day) {
                                        ForEach(Array(stride(from: 0, through: 30, by: 1)), id: \.self) { i in
                                            Text("Day \(i)").tag(i)
                                        }
                                    }
                                    .frame(width: 100)
                                    .clipped()
                                    
                                    Button(action: {
                                        withAnimation {
                                            exercises.remove(at: index)
                                            item.totalMinute = exercises.reduce(0) { $0 + $1.minute}
                                        }
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                        }
                    }.padding(.horizontal)
                    
                    HStack {
                        Button(action: {
                            withAnimation {
                                exercises.append(Exercises(minute: 0, exerciseName: "", day: 0))
                            }
                        }) {
                            Image(systemName: "plus")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }
                        .padding()
                        
                        Button(action: {
                            
                            item.exercises = exercises
                            
                            do {
                                try context.save()
                            } catch {
                                print(error.localizedDescription)
                            }
                            
                            dismiss()
                            
                        }, label: {
                            Text("Save")
                                .padding()
                                .foregroundColor(.blue)
                                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 2))
                        })
                    }
                    
                    Spacer()
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        isInputActive = false
                    }
                }
            }
        }
        .onAppear {
            self.exercises = self.item.exercises
        }
    }
}

#Preview {
    DetailsView(item: Item(month: 7, year: 2024))
}
