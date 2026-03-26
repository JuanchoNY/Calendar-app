import SwiftUI

struct ContentView: View {
    @State private var events: [Event] = []
    @State private var newTitle: String = ""
    @State private var selectedDate = Date()

    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    private let weekdaySymbols = ["S", "M", "T", "W", "T", "F", "S"]

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                headerView
                weekdayHeader
                monthGrid

                DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                    .padding(.horizontal)

                HStack {
                    TextField("New Event", text: $newTitle)
                        .textFieldStyle(.roundedBorder)

                    Button("Add") {
                        addEvent()
                    }
                }
                .padding(.horizontal)

                if filteredEvents.isEmpty {
                    Text("No events yet")
                        .foregroundStyle(.gray)
                        .padding(.top, 4)
                }

                List(filteredEvents) { event in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(event.title)

                        Text(event.date.formatted(date: .abbreviated, time: .omitted))
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                }
            }
            .padding(.top)
        }
    }

    private var headerView: some View {
        HStack {
            Button("<") {
                moveMonth(by: -1)
            }

            Spacer()

            Text(selectedDate.formatted(.dateTime.month(.wide).year()))
                .font(.title2)

            Spacer()

            Button(">") {
                moveMonth(by: 1)
            }
        }
        .padding(.horizontal)
    }

    private var weekdayHeader: some View {
        HStack {
            ForEach(weekdaySymbols, id: \.self) { day in
                Text(day)
                    .font(.caption)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal)
    }

    private var monthGrid: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(0..<leadingBlankDays, id: \.self) { _ in
                Color.clear
                    .frame(height: 42)
            }

            ForEach(daysInMonthArray, id: \.self) { day in
                let date = dateForDay(day)

                Button {
                    selectedDate = date
                } label: {
                    VStack(spacing: 4) {
                        Text("\(day)")
                            .frame(maxWidth: .infinity)

                        Circle()
                            .frame(width: 6, height: 6)
                            .opacity(hasEvent(on: date) ? 1 : 0)
                    }
                    .frame(maxWidth: .infinity, minHeight: 42)
                    .padding(.vertical, 6)
                    .background(backgroundColor(for: date))
                    .cornerRadius(8)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal)
    }

    private var filteredEvents: [Event] {
        events.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
    }

    private var daysInMonthArray: [Int] {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: selectedDate) ?? 1..<31
        return Array(range)
    }

    private var leadingBlankDays: Int {
        let calendar = Calendar.current
        let firstOfMonth = firstDayOfMonth(for: selectedDate)
        return calendar.component(.weekday, from: firstOfMonth) - 1
    }

    private func firstDayOfMonth(for date: Date) -> Date {
        let calendar = Calendar.current
        return calendar.date(from: calendar.dateComponents([.year, .month], from: date)) ?? date
    }

    private func dateForDay(_ day: Int) -> Date {
        let calendar = Calendar.current
        let firstOfMonth = firstDayOfMonth(for: selectedDate)
        return calendar.date(byAdding: .day, value: day - 1, to: firstOfMonth) ?? firstOfMonth
    }

    private func moveMonth(by value: Int) {
        let calendar = Calendar.current
        selectedDate = calendar.date(byAdding: .month, value: value, to: selectedDate) ?? selectedDate
    }

    private func hasEvent(on date: Date) -> Bool {
        events.contains { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }

    private func backgroundColor(for date: Date) -> Color {
        let calendar = Calendar.current

        if calendar.isDate(date, inSameDayAs: selectedDate) {
            return Color.blue.opacity(0.25)
        } else if calendar.isDateInToday(date) {
            return Color.gray.opacity(0.2)
        } else {
            return Color.gray.opacity(0.08)
        }
    }

    private func addEvent() {
        let trimmed = newTitle.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmed.isEmpty else { return }

        let newEvent = Event(title: trimmed, date: selectedDate)
        events.append(newEvent)
        newTitle = ""
    }
}
