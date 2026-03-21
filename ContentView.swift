import SwiftUI

struct ContentView: View {
    
    @State private var events: [Event] = []
    @State private var newTitle: String = ""

    @State private var selectedDate = Date()
    var body: some View {
        NavigationStack {
            VStack {

                DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                    .padding()

                   TextField("New Event", text: $newTitle)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                
                Button("Add Event") {
                    let newEvent = Event(title: newTitle, date: Date())
                    events.append(newEvent)
                    newTitle = ""
                }
                
                List(events) { event in
                    Text(event.title)
                }
            }
            .navigationTitle("My Calendar")
        }
    }
}
 
