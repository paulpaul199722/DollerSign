import SwiftUI

struct AddTransactionView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    @State private var amount: String = ""
    @State private var date: Date = Date()
    @State private var description: String = ""
    @State private var isExpense: Bool = true
    @State private var recurring: Bool = false
    @State private var selectedCategory: Category?
    @State private var showAddCategoryView = false

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
                    Text("Save")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(amount.isEmpty || selectedCategory == nil ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                .disabled(amount.isEmpty || selectedCategory == nil)
            }
            .navigationTitle("Add Transaction")
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
        }
    }
    
    func saveTransaction() {
        guard let selectedCategory = selectedCategory else { return }
        let newTransaction = Transaction(
            id: UUID(),
            amount: Double(amount) ?? 0.0,
            date: date,
            category: selectedCategory.name,
            description: description,
            isExpense: isExpense,
            recurring: recurring
        )
        
        dataManager.addTransaction(newTransaction)
        presentationMode.wrappedValue.dismiss()
    }
}

#if DEBUG
struct AddTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        AddTransactionView()
            .environmentObject(DataManager())
    }
}
#endif
