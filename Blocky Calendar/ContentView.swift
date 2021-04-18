//
//  ContentView.swift
//  Blocky Calendar
//
//  Created by Bug on 4/6/21.
//

import SwiftUI
import CoreData

struct ContentView: View, DataHanderDelegate {
    
    @Environment (\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Event.block, ascending: true)])
    var events: FetchedResults<Event>
    
    // MARK: - States
    
    @State var createMenuIsVisible = false
    @State var selectedEventBlock: Int?
    
    // MARK: - View Body
    
    var body: some View {
        ZStack {
            // Event blocks
            ScrollView(showsIndicators: false) {
                VStack(spacing: 4) {
                    Text("BLOCKY")
                        .font(.system(.largeTitle, design: .rounded))
                        .fontWeight(.black)
                        .foregroundColor(Color(UIColor.tertiaryLabel))
                        .padding(.bottom)
                    ForEach((0 ..< 72), id: \.self) { index in
                        if events.contains(where: { event -> Bool in
                            if event.block == index { return true }
                            else { return false }
                        }) {
                            EventBlock(dataHandlerDelegate: self, title: events.first(where: { $0.block == index })?.title ?? "", block: index)
                        } else {
                            EventBlock(dataHandlerDelegate: self, isEmpty: true, block: index)
                                .simultaneousGesture(TapGesture().onEnded {
                                    selectedEventBlock = index
                                    withAnimation(.spring()) {
                                        createMenuIsVisible = true
                                    }
                                })
                        }
                    }
                }
                .padding()
            }
            .scaleEffect(createMenuIsVisible ? 0.8 : 1)
            // TODO: Status bar overlay
            VStack {
                Rectangle()
                    .frame(width: UIScreen.main.bounds.size.width, height: StatusBarManager.shared.getStatusBarHeight())
                    .foregroundColor(Color(UIColor.systemBackground))
                Spacer()
            }
            .ignoresSafeArea()
            // Overlay color
            Rectangle()
                .ignoresSafeArea()
                .foregroundColor(.black)
                .opacity(createMenuIsVisible ? 0.5 : 0)
                .onTapGesture {
                    selectedEventBlock = nil
                    UIApplication.shared.endEditing()
                    withAnimation(.spring()) {
                        createMenuIsVisible = false
                    }
                }
            // Create event menu
            VStack {
                CreateMenu(dataHandlerDelegate: self, createMenuIsVisible: $createMenuIsVisible, selectedEventBlock: $selectedEventBlock)
                Spacer()
            }
            .padding(8)
            .offset(y: createMenuIsVisible ? 0 : -UIScreen.main.bounds.size.height)
        }
    }
    
    // MARK: - Functions
    
    func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved error: \(error)")
        }
    }
    
    func addEvent(title: String, block: Int) {
        withAnimation {
            let newEvent = Event(context: viewContext)
            newEvent.title = title
            newEvent.block = Int16(block)
        }
        saveContext()
    }
    
    func deleteEvent(offsets: IndexSet) {
        withAnimation {
            offsets.map { events[$0] } .forEach(viewContext.delete)
        }
        saveContext()
    }
    
    func getEventIndexFromBlock(block: Int) -> Int {
        let index = events.firstIndex { event -> Bool in
            if event.block == block { return true }
            else { return false }
        }
        return index ?? 0
    }
    
}

// MARK: - Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
