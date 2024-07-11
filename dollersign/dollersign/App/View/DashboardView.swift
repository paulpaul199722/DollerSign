// DashboardView.swift

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingSettings = false

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Financial Overview")) {
                    FinancialOverview()
                }
                Section(header: Text("Summary Widgets")) {
                    SummaryWidgets()
                }
            }
            .navigationTitle("Dashboard")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingSettings = true
                    }) {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
                    .environmentObject(dataManager)
            }
        }
    }
}

struct FinancialOverview: View {
    @EnvironmentObject var dataManager: DataManager

    var body: some View {
        let specifier = dataManager.settings.decimalSpecifier

        VStack(alignment: .leading) {
            Text("Total Income: \(dataManager.transactions.filter { !$0.isExpense }.reduce(0) { $0 + $1.amount }, specifier: specifier)")
            Text("Total Expenses: \(dataManager.transactions.filter { $0.isExpense }.reduce(0) { $0 + $1.amount }, specifier: specifier)")
            Text("Current Balance: \(dataManager.transactions.reduce(0) { $0 + ($1.isExpense ? -$1.amount : $1.amount) }, specifier: specifier)")
        }
    }
}

struct SummaryWidgets: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Monthly Spending Trends")
            Text("Upcoming Bill Payments")
            Text("Budget Utilization")
        }
    }
}
