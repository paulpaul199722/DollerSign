import SwiftUI
struct ContentView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")
                }
            
            BudgetView()
                .tabItem {
                    Label("Budgets", systemImage: "chart.pie.fill")
                }
            
            ChartView()
                .tabItem {
                    Label("Charts", systemImage: "chart.bar.fill")
                }
            
            CategoryView()
                .tabItem {
                    Label("Categories", systemImage: "list.bullet")
                }

            TransactionsView()
                .tabItem {
                    Label("Transactions", systemImage: "tray.full")
                }

        }
    }
}
