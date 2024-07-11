import SwiftUI

@main
struct DollerSignApp: App {
    @StateObject private var dataManager = DataManager()

      var body: some Scene {
          WindowGroup {
              ContentView()
                  .environmentObject(dataManager)
          }
      }
}
