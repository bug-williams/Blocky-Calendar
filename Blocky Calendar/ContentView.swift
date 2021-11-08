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
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // MARK: - States
    
    @State var date: Date = Date()
    
    @State var createMenuIsVisible = false
    @State var selectedEventBlock: Int?
    
    @State var lastDay: Date = Date()
    @State var isToday = false
    @State var selectedTime = 0  // 24 hour clock
    
    @State var isShowingClearCalendarAlert = false
    @State var showSettingsPage = false
    
    // MARK: - View Body
    
    var body: some View {
        ZStack {
            // Event blocks
            VStack(spacing: 0) {
                HStack(alignment: .center, spacing: 16) {
                    Image(systemName: "calendar")
                        .font(.system(size: 32, weight: .semibold))
                    VStack(alignment: .leading) {
                        Text("\(date.day)")
                            .font(.system(.headline, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(Color.primary)
                            .lineLimit(1)
                        Text("\(date.month) \(date.dayOfMonth), \(date.year)")
                            .font(.system(.subheadline, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(Color.secondary)
                            .lineLimit(1)
                    }
                    Spacer()
                    Menu {
                        Button(action: {
                            isShowingClearCalendarAlert.toggle()
                        }) {
                            HStack {
                                Text("Clear Calendar")
                                Image(systemName: "clear")
                            }
                        }
                        Button(action: {
                            showSettingsPage.toggle()
                        }) {
                            HStack {
                                Text("Settings")
                                Image(systemName: "gearshape")
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle.fill")
                            .font(.system(size: 28, weight: .bold))
                    }
                    .alert(isPresented: $isShowingClearCalendarAlert) {
                        Alert(
                            title: Text("Are you sure you want to clear the calendar?"),
                            message: Text("There is no way to undo this action."),
                            primaryButton: .destructive(Text("Clear")) {
                                clearEvents()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
                .padding()
                Divider()
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 4) {
                        ForEach((0 ..< 72), id: \.self) { index in
                            if getCurrentBlock() == index {
                                HStack(alignment: .center, spacing: 16) {
                                    Text("Now")
                                        .font(.system(.caption, design: .rounded))
                                        .fontWeight(.bold)
                                        .foregroundColor(.accentColor)
                                        .lineLimit(1)
                                        .frame(width: 52, height: 0)
                                        .padding(.horizontal, -8)
                                    VStack {
                                        Divider()
                                            .frame(height: 2)
                                            .background(Color.accentColor)
                                            .cornerRadius(1)
                                    }
                                }
                                .padding(.vertical, 12)
                            }
                            if events.contains(where: { event -> Bool in
                                if event.block == index { return true }
                                else { return false }
                            }) {
                                if getCurrentBlock() <= index {
                                    EventBlock(
                                        dataHandlerDelegate: self,
                                        title: getFirstInstanceOfEvent(index: index)?.title ?? "",
                                        block: index,
                                        color: Int(getFirstInstanceOfEvent(index: index)?.color ?? 0)
                                    )
                                } else {
                                    EventBlock(
                                        dataHandlerDelegate: self,
                                        hasPassed: true,
                                        title: getFirstInstanceOfEvent(index: index)?.title ?? "",
                                        block: index,
                                        color: Int(getFirstInstanceOfEvent(index: index)?.color ?? 0)
                                    )
                                }
                            } else {
                                if getCurrentBlock() <= index {
                                    Button(action: {
                                        selectedEventBlock = index
                                        withAnimation(.spring()) {
                                            createMenuIsVisible = true
                                        }
                                    }, label: {
                                        EventBlock(
                                            dataHandlerDelegate: self,
                                            isEmpty: true,
                                            block: index
                                        )
                                    })
                                }
                            }
                        }
                    }
                    .padding()
                }
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
                Spacer()
                CreateMenu(dataHandlerDelegate: self, createMenuIsVisible: $createMenuIsVisible, selectedEventBlock: $selectedEventBlock)
            }
            .padding(8)
            .offset(y: createMenuIsVisible ? 0 : UIScreen.main.bounds.size.height)
        }
        .sheet(isPresented: $showSettingsPage) {
            SettingsPage(showSettingsPage: $showSettingsPage)
        }
        .onReceive(timer) { _ in
            withAnimation(.spring()) {
                date = Date()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            // store the date whenever you go into background
            UserDefaults.standard.set(Date(), forKey: "lastDay")
            isToday = false
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            // try to retrieve the date when you come back from background
            if let tempDate = UserDefaults.standard.object(forKey: "lastDay") {
                self.lastDay = tempDate as! Date
                if Calendar.current.isDate(Date(), inSameDayAs: self.lastDay) {
                    self.isToday = true
                }
                if let thisHour = Calendar.current.dateComponents([.hour], from: Date()).hour {
                    if !isToday && thisHour >= self.selectedTime {
                        clearEvents()
                    }
                }
            }
            // update view
            withAnimation(.spring()) {
                date = Date()
            }
        }
    }
    
    // MARK: - Utility Functions
    
    func getCurrentBlock() -> Int {
        let currentHour = Calendar.current.component(.hour, from: Date())
        let currentMinute = Calendar.current.component(.minute, from: Date())
        let currentBlock: Int = (currentHour * 3) + currentMinute / 20
        return currentBlock
    }
    
    func getFirstInstanceOfEvent(index: Int) -> Event? {
        return events.first(where: { $0.block == index })
    }
    
    // MARK: - dataHandlerDelegate Functions
    
    func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved error: \(error)")
        }
    }
    
    func addEvent(title: String, block: Int, color: Int) {
        withAnimation {
            let newEvent = Event(context: viewContext)
            newEvent.title = title
            newEvent.block = Int16(block)
            newEvent.color = Int16(color)
        }
        saveContext()
    }
    
    func deleteEvent(offsets: IndexSet) {
        withAnimation {
            offsets.map { events[$0] } .forEach(viewContext.delete)
        }
        saveContext()
    }
    
    func clearEvents() {
        withAnimation {
            events.forEach(viewContext.delete)
        }
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
