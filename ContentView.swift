import SwiftUI


struct ContentView: View {

    @State private var events: [Event] = []
    @State private var newTitle: String = ""
    @State private var selectedDate = Date()

    var body: some View {
        NavigationStack {
            VStack {

                HStack {
                    Button("<") {
                        selectedDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate) ?? selectedDate
                    }

                    Spacer()

                    Text(selectedDate.formatted(.dateTime.month(.wide).year()))
                        .font(.title)
                        .padding(.top)

                    Spacer()

                    Button(">") {
                        selectedDate = Calendar.current.date(byAdding: .month, value: 1, to: selectedDate) ?? selectedDate
                    }
                }

                DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                    .padding()

                TextField("New Event", text: $newTitle)
                    .padding(.horizontal)
                    .textFieldStyle(.roundedBorder)
                    .padding()

                Spacer()

                Button("Add Event") {
                    guard !newTitle.trimmingCharacters(in: .whitespaces).isEmpty else { return }

                    let newEvent = Event(title: newTitle, date: selectedDate)
                    events.append(newEvent)
                    newTitle = ""
                }

                if events.filter({ Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }).isEmpty {
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
        }
    }
}
