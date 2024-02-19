//
//  ContentView.swift
//  JustNote
//
//  Created by Левон Михаелян on 19.02.2024.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showingAddNoteView = false
    @State private var newNoteTitle = ""
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: NoteModel.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \NoteModel.dateCreated, ascending: true)]
    ) var notes: FetchedResults<NoteModel>

    var body: some View {
        NavigationView {
            List {
                ForEach(notes, id: \.self) { note in
                    HStack {
                        NavigationLink(destination: NoteDetailView(note: note)) {
                            Text(note.title ?? "Без названия").font(.headline)
                        }
                        Spacer()
                        Button(action: {
                            deleteNoteSpecific(note: note)
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .onDelete(perform: deleteNote)
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        self.showingAddNoteView = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddNoteView) {
                VStack {
                    TextField("Заголовок", text: $newNoteTitle)
                    Button("Сохранить") {
                        addNote()
                        self.showingAddNoteView = false
                    }
                    .disabled(newNoteTitle.isEmpty)
                }
                .padding()
            }
        }
//        .navigationTitle("Заметки")
    }

    private func addNote() {
        let newNote = NoteModel(context: managedObjectContext)
        newNote.id = UUID()
        newNote.title = newNoteTitle
        newNote.body = ""
        newNote.dateCreated = Date()
        newNote.dateModified = Date()
        newNote.isFavorited = false

        do {
            try managedObjectContext.save()
            print("Добавлена заметка: \(newNote.title ?? "нет заголовка"), \(newNote.body ?? "нет тела")")
            newNoteTitle = ""
        } catch {
            print("Не удалось сохранить заметку: \(error)")
        }
        saveContext()
    }

    private func deleteNote(at offsets: IndexSet) {
        for index in offsets {
                   let noteToDelete = notes[index]
                   managedObjectContext.delete(noteToDelete)
               }

               do {
                   try managedObjectContext.save()
               } catch {
                   print("Не удалось удалить заметку: \(error)")
               }
    }
    private func deleteNoteSpecific(note: NoteModel) {
        managedObjectContext.delete(note)
        saveContext()
    }

    private func saveContext() {
        do {
            try managedObjectContext.save()
        } catch {
            print("Не удалось сохранить изменения: \(error)")
        }
    }

}

#Preview {
    ContentView()
}
