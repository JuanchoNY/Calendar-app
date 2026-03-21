import Foundation

struct Event: Identifiable {
    let id = UUID()
    var title: String
    var date: Date
}
