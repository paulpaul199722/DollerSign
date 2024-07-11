import SwiftUI

struct AddBudgetView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedCategory: Category?
    @State private var amount: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date().addingTimeInterval(60 * 60 * 24 * 30)
    @State private var showAddCategoryView = false
    @State private var showEditCategoryView = false
    
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
            .navigationTitle("Add Budget")
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
        }
    }
    
    func saveBudget() {
        guard let selectedCategory = selectedCategory else { return }
        let newBudget = Budget(
            id: UUID(),
            category: selectedCategory.name,
            amount: Double(amount) ?? 0.0,
            startDate: startDate,
            endDate: endDate
        )
        
        dataManager.addBudget(newBudget)
        presentationMode.wrappedValue.dismiss()
    }
}

#if DEBUG
struct AddBudgetView_Previews: PreviewProvider {
    static var previews: some View {
        AddBudgetView()
            .environmentObject(DataManager())
    }
}
#endif
