import SwiftUI

struct EditTransactionView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    var transaction: Transaction
    
    @State private var amount: String
    @State private var date: Date
    @State private var description: String
    @State private var isExpense: Bool
    @State private var recurring: Bool
    @State private var selectedCategory: Category?
    @State private var showAddCategoryView = false
    
    init(transaction: Transaction) {
        self.transaction = transaction
        _amount = State(initialValue: "\(transaction.amount)")
        _date = State(initialValue: transaction.date)
        _description = State(initialValue: transaction.description)
        _isExpense = State(initialValue: transaction.isExpense)
        _recurring = State(initialValue: transaction.recurring)
        _selectedCategory = State(initialValue: nil)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Transaction Details")) {
                        TextField("Amount", text: $amount)
                            .keyboardType(.decimalPad)
                        DatePicker("Date", selection: $date, displayedComponents: .date)
                        TextField("Description", text: $description)
                        Toggle("Expense", isOn: $isExpense)
                        Toggle("Recurring", isOn: $recurring)
                    }
                    
                    Section(header: Text("Category")) {
                        List {
                            ForEach(dataManager.categories, id: \.self) { category in
                                HStack {
                                    Text(category.icon) // Display icon
                                    Text(category.name)
                                    Spacer()
                                    if selectedCategory == category {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.blue)
                                    }
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    selectedCategory = category
                                }
                            }
                            Button(action: {
                                showAddCategoryView = true
                            }) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(.blue)
                                    Text("Add New Category")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
                
                // Save Button outside the Form
                Button(action: {
                    saveTransaction()
                }) {
                    Text("Save Changes")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(amount.isEmpty || selectedCategory == nil ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                .disabled(amount.isEmpty || selectedCategory == nil)
            }
            .navigationTitle("Edit Transaction")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .sheet(isPresented: $showAddCategoryView) {
                AddCategoryView()
                    .environmentObject(dataManager)
            }
            .onAppear {
                initializeFields()
            }
        }
    }
    
    private func initializeFields() {
        selectedCategory = dataManager.categories.first(where: { $0.name == transaction.category })
    }
    
    func saveTransaction() {
        guard let selectedCategory = selectedCategory else { return }
        var updatedTransaction = transaction
        updatedTransaction.category = selectedCategory.name
        updatedTransaction.amount = Double(amount) ?? 0.0
        updatedTransaction.date = date
        updatedTransaction.description = description
        updatedTransaction.isExpense = isExpense
        updatedTransaction.recurring = recurring
        
        dataManager.updateTransaction(updatedTransaction)
        presentationMode.wrappedValue.dismiss()
    }
}
