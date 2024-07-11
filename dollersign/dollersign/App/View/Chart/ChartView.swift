import SwiftUI
import Charts

struct ChartView: View {
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Spending Trends")) {
                    SpendingTrendChart()
                }
                
                Section(header: Text("Budget Utilization")) {
                    BudgetUtilizationChart()
                }
            }
            .navigationTitle("Charts")
        }
    }
}

struct SpendingTrendChart: View {
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        Chart {
            ForEach(dataManager.transactions) { transaction in
                LineMark(
                    x: .value("Date", transaction.date),
                    y: .value("Amount", transaction.amount)
                )
                .foregroundStyle(transaction.isExpense ? .red : .green)
            }
        }
        .frame(height: 300)
    }
}

struct BudgetUtilizationChart: View {
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        Chart {
            ForEach(dataManager.budgets) { budget in
                BarMark(
                    x: .value("Category", budget.category),
                    y: .value("Amount", budget.usedAmount)
                )
                .foregroundStyle(budget.usedAmount > budget.amount ? .red : .green)
            }
        }
        .frame(height: 300)
    }
}
