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
            .padding(.horizontal)
            .textFieldStyle(.roundedBorder)
            .padding()

        Spacer()

        Button("Add Event") {
            let newEvent = Event(title: newTitle, date: selectedDate)
            events.append(newEvent)
            newTitle = ""
        }

        if events.isEmpty {
            Text("No events yet")
                .foregroundStyle(.gray)
}
            List(events.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }) { event in
                VStack(alignment: .leading) {
                    Text(event.title)
                    Text(event.date.formatted(date: .abbreviated, time: .omitted))
                        .font(.caption)
                        .foregroundStyle(.gray)
            }
        }
    }
    .navigationTitle("My Calendar")
}
