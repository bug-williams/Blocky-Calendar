//
//  ContentView.swift
//  Blocky Calendar
//
//  Created by Bug on 4/6/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    // MARK: - Variables
    
    @Environment(\.managedObjectContext)
    private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Event.block, ascending: true)])
    private var events: FetchedResults<Event>
    
    // MARK: - View Body
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    Text("BLOCKY")
                        .font(.system(.headline, design: .monospaced))
                        .fontWeight(.black)
                        .foregroundColor(Color(UIColor.tertiaryLabel))
                        .padding(.bottom)
                    ForEach((0 ..< 72), id: \.self) { index in
                        if events.contains(where: { (event) -> Bool in
                            if event.block == index { return true }
                            else { return false }
                        }) {
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 24, style: .continuous)
                                    .frame(height: 64)
                                    .foregroundColor(Color.accentColor)
                                HStack {
                                    Text(events.first(where: { $0.block == index })?.title ?? "")
                                        .font(.system(.subheadline, design: .monospaced))
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                        .lineLimit(1)
                                }
                                .padding(24)
                            }
                        } else {
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 24, style: .continuous)
                                    .frame(height: 64)
                                    .foregroundColor(Color(UIColor.secondarySystemBackground))
                                HStack {
                                    Text("empty")
                                        .font(.system(.subheadline, design: .monospaced))
                                        .fontWeight(.semibold)
                                        .foregroundColor(.secondary)
                                        .lineLimit(1)
                                }
                                .padding(24)
                            }
                            .onTapGesture {
                                addEvent(title: "Event", block: index)
                            }
                        }
                    }
                }
                .padding()
            }
        }
    }
    
    // MARK: - Functions
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved error: \(error)")
        }
    }
    
    private func addEvent(title: String, block: Int) {
        withAnimation {
            let newEvent = Event(context: viewContext)
            newEvent.title = title
            newEvent.block = Int16(block)
            saveContext()
        }
    }
    
    private func deleteEvent(offsets: IndexSet) {
        withAnimation {
            offsets.map { events[$0] } .forEach(viewContext.delete)
            saveContext()
        }
    }
    
}

// MARK: - Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
