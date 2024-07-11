import SwiftUI
import Foundation

struct TransactionsView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingAddTransaction = false
    @State private var showingEditTransaction = false
    @State private var transactionToEdit: Transaction?
    @State private var transactionToDelete: Transaction?
    @State private var showingDeleteConfirmation = false

    var body: some View {
        NavigationView {
            List {
                ForEach(dataManager.transactions) { transaction in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(transaction.category)
                            Text("Date: \(transaction.date, formatter: DateFormatter.shortDate)")
                            Text(transaction.isExpense ? "Expense" : "Income")
                        }
                        Spacer()
                        Text(transaction.isExpense ? "-$\(transaction.amount,specifier: dataManager.settings.decimalSpecifier)" : "+$\(transaction.amount,specifier: dataManager.settings.decimalSpecifier)")
                            .foregroundColor(transaction.isExpense ? .red : .green)
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            transactionToDelete = transaction
                            showingDeleteConfirmation = true
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        
                        Button {
                            transactionToEdit = transaction
                            showingEditTransaction = true
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.blue)
                    }
                }
            }
            .alert("Confirm Delete", isPresented: $showingDeleteConfirmation) {
                Button("Delete", role: .destructive) {
                    if let transaction = transactionToDelete {
                        withAnimation {
                            dataManager.deleteTransaction(transaction)
                        }
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Are you sure you want to delete this transaction?")
            }
            .navigationTitle("Transactions")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        showingAddTransaction = true
                    }) {
                        Label("Add Transaction", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddTransaction) {
                AddTransactionView()
                    .environmentObject(dataManager)
            }
            .sheet(item: $transactionToEdit) { transaction in
                EditTransactionView(transaction: transaction)
                    .environmentObject(dataManager)
            }
        }
    }
}


extension DateFormatter {
    static var shortDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
}
