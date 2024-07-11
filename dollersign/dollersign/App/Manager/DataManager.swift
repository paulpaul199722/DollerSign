import Foundation

class DataManager: ObservableObject {
    @Published var transactions: [Transaction] = []
    @Published var budgets: [Budget] = []
    @Published var categories: [Category] = []
    @Published var settings: Settings = Settings.defaultSettings


    private let transactionsKey = "transactions_key"
    private let budgetsKey = "budgets_key"
    private let categoriesKey = "categories_key"
    private let settingsKey = "settings_key"

    
    init() {
        loadTransactions()
        loadBudgets()
        loadCategories()
        loadSettings()

    }
    
    
    
    // Transaction Methods
    func loadTransactions() {
        if let data = UserDefaults.standard.data(forKey: transactionsKey) {
            if let decoded = try? JSONDecoder().decode([Transaction].self, from: data) {
                transactions = decoded
            }
        } else {
            // Add default transactions if none exist
            transactions = [
                Transaction(id: UUID(), amount: 50.0, date: Date(), category: "Food", description: "Groceries", isExpense: true,  recurring: false),
                Transaction(id: UUID(), amount: 2000.0, date: Date(), category: "Salary", description: "Monthly Salary", isExpense: false,  recurring: false)
            ]
            saveTransactions()
        }
    }
    
    func saveTransactions() {
        if let encoded = try? JSONEncoder().encode(transactions) {
            UserDefaults.standard.set(encoded, forKey: transactionsKey)
        }
    }
    
    func addTransaction(_ transaction: Transaction) {
        transactions.append(transaction)
        updateBudgets(for: transaction)
        saveTransactions()
        
        if transaction.recurring {
            NotificationManager.shared.scheduleNotification(for: transaction)
        }
    }
    
    func updateTransaction(_ transaction: Transaction) {
        if let index = transactions.firstIndex(where: { $0.id == transaction.id }) {
            transactions[index] = transaction
            saveTransactions()
        }
    }
    
    func deleteTransaction(_ transaction: Transaction) {
        transactions.removeAll { $0.id == transaction.id }
        saveTransactions()
    }
    
    // Budget Methods
    func loadBudgets() {
        if let data = UserDefaults.standard.data(forKey: budgetsKey) {
            if let decoded = try? JSONDecoder().decode([Budget].self, from: data) {
                budgets = decoded
            }
        } else {
            // Add default budgets if none exist
            budgets = [
                Budget(id: UUID(), category: "Food", amount: 500.0, startDate: Date().addingTimeInterval(-60*60*24*30), endDate: Date().addingTimeInterval(60*60*24*30)),
                Budget(id: UUID(), category: "Transport", amount: 100.0, startDate: Date().addingTimeInterval(-60*60*24*30), endDate: Date().addingTimeInterval(60*60*24*30))
            ]
            saveBudgets()
        }
    }
    
    func saveBudgets() {
        if let encoded = try? JSONEncoder().encode(budgets) {
            UserDefaults.standard.set(encoded, forKey: budgetsKey)
        }
    }
    
    func addBudget(_ budget: Budget) {
        budgets.append(budget)
        saveBudgets()
    }
    
    func updateBudget(_ updatedBudget: Budget) {
        if let index = budgets.firstIndex(where: { $0.id == updatedBudget.id }) {
            budgets[index] = updatedBudget
            saveBudgets()
        }
    }
    
    func deleteBudget(_ budget: Budget) {
        if let index = budgets.firstIndex(where: { $0.id == budget.id }) {
            budgets.remove(at: index)
            saveBudgets()
        }
    }
    
    private func updateBudgets(for transaction: Transaction) {
        if transaction.isExpense {
            for i in 0..<budgets.count {
                if budgets[i].category == transaction.category &&
                    transaction.date >= budgets[i].startDate &&
                    transaction.date <= budgets[i].endDate {
                    
                    budgets[i].usedAmount += transaction.amount
                    saveBudgets()
                }
            }
        }
    }
    
    // Categories Method
    func saveCategories() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(categories) {
            UserDefaults.standard.set(encoded, forKey: categoriesKey)
        }
    }

    func loadCategories() {
        if let savedCategories = UserDefaults.standard.data(forKey: categoriesKey) {
            let decoder = JSONDecoder()
            if let loadedCategories = try? decoder.decode([Category].self, from: savedCategories) {
                categories = loadedCategories
            }
        } else {
            // Add default categories if none exist
            categories = [
                Category(name: "Food", icon: "🍔"),
                Category(name: "Transport", icon: "🚗"),
                Category(name: "Salary", icon: "💼")
            ]
            saveCategories()
        }
    }
    
    func addCategory(name: String, icon: String) {
        let newCategory = Category(name: name, icon: icon)
        categories.append(newCategory)
        saveCategories()
    }
    
    func updateCategory(_ updatedCategory: Category) {
        if let index = categories.firstIndex(where: { $0.id == updatedCategory.id }) {
            categories[index] = updatedCategory
            saveCategories()
        }
    }
    
    func removeCategory(category: Category) {
        if let index = categories.firstIndex(where: { $0.id == category.id }) {
            categories.remove(at: index)
            saveCategories()
        }
    }
    
    // Settings Methods
       func loadSettings() {
           if let data = UserDefaults.standard.data(forKey: settingsKey) {
               if let decoded = try? JSONDecoder().decode(Settings.self, from: data) {
                   settings = decoded
               }
           }
       }
       
       func saveSettings() {
           if let encoded = try? JSONEncoder().encode(settings) {
               UserDefaults.standard.set(encoded, forKey: settingsKey)
           }
       }
}
