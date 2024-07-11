import SwiftUI

struct EditBudgetView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    var budget: Budget
    
    @State private var selectedCategory: Category?
    @State private var amount: String
    @State private var startDate: Date
    @State private var endDate: Date
    @State private var showAddCategoryView = false
    @State private var showEditCategoryView = false
    
    init(budget: Budget) {
        self.budget = budget
        _amount = State(initialValue: "\(budget.amount)")
        _startDate = State(initialValue: budget.startDate)
        _endDate = State(initialValue: budget.endDate)
        _selectedCategory = State(initialValue: nil)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Budget Details")) {
                        TextField("Amount", text: $amount)
                            .keyboardType(.decimalPad)
                        DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                        DatePicker("End Date", selection: $endDate, displayedComponents: .date)
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
                                .swipeActions {
                                    Button {
                                        selectedCategory = category
                                        showEditCategoryView = true
                                    } label: {
                                        Label("Edit", systemImage: "pencil")
                                    }
                                    .tint(.blue)
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
                    saveBudget()
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
            .navigationTitle("Edit Budget")
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
            .sheet(isPresented: $showEditCategoryView) {
                if let selectedCategory = selectedCategory {
                    EditCategoryView(category: selectedCategory)
                        .environmentObject(dataManager)
                }
            }
            .onAppear {
                initializeFields()
            }
        }
    }
    
    private func initializeFields() {
        selectedCategory = dataManager.categories.first(where: { $0.name == budget.category })
    }

    func saveBudget() {
        guard let selectedCategory = selectedCategory else { return }
        var updatedBudget = budget
        updatedBudget.category = selectedCategory.name
        updatedBudget.amount = Double(amount) ?? 0.0
        updatedBudget.startDate = startDate
        updatedBudget.endDate = endDate
        
        dataManager.updateBudget(updatedBudget)
        presentationMode.wrappedValue.dismiss()
    }
}

#if DEBUG
struct EditBudgetView_Previews: PreviewProvider {
    static var previews: some View {
        EditBudgetView(budget: Budget(id: UUID(), category: "Food", amount: 1000.0, startDate: Date(), endDate: Date().addingTimeInterval(60 * 60 * 24 * 30)))
            .environmentObject(DataManager())
    }
}
#endif
