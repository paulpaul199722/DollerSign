import SwiftUI

struct BudgetView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingAddBudget = false
    @State private var showingEditBudget = false
    @State private var budgetToEdit: Budget?
    @State private var budgetToDelete: Budget?
    @State private var showingDeleteConfirmation = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(dataManager.budgets) { budget in
                    VStack(alignment: .leading) {
                        HStack {
                            Text(budget.category)
                                .font(.headline)
                            Spacer()
                            if budget.usedAmount > budget.amount {
                                Text("Overspent $\(budget.usedAmount - budget.amount, specifier: dataManager.settings.decimalSpecifier)")
                                    .foregroundColor(.red)
                                    .bold()
                            } else {
                                Text("$\(budget.amount - budget.usedAmount, specifier: dataManager.settings.decimalSpecifier) left")
                                    .foregroundColor(.green)
                                    .bold()
                            }
                        }
                        .padding(.bottom, 5)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("Budget:")
                                        .font(.subheadline)
                                        .bold()
                                    Spacer()
                                    Text("$\(budget.amount, specifier: dataManager.settings.decimalSpecifier)")
                                        .font(.subheadline)
                                }
                                .padding(.bottom, 2)
                                
                                HStack {
                                    Text("Used:")
                                        .font(.subheadline)
                                        .bold()
                                    Spacer()
                                    Text("$\(budget.usedAmount, specifier: dataManager.settings.decimalSpecifier)")
                                        .font(.subheadline)
                                }
                            }
                        }
                        
                        VStack(spacing: 0) {
                            ZStack(alignment: .leading) {
                                ProgressView(value: min(budget.usedAmount / budget.amount, 1.0))
                                    .progressViewStyle(LinearProgressViewStyle(tint: budget.usedAmount > budget.amount ? .red : .blue))
                                    .scaleEffect(x: 1, y: 3, anchor: .center)
                                    .padding(.vertical, 5)
                            }

                            GeometryReader { geometry in
                                let progress = budget.usedAmount / budget.amount
                                let percentage = percentageUsed(budget: budget)
                                
                                Text("\(percentage)%")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                    .position(x: xPosition(for: progress, in: geometry.size.width),
                                              y: geometry.size.height / 2)
                            }
                            .frame(height: 18) // Adjust the height as needed
                        }
                    }
                    .padding(.all, 8)
                    .listRowSeparator(.hidden)  // Hide the list row separator
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            budgetToDelete = budget
                            showingDeleteConfirmation = true
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        
                        Button {
                            budgetToEdit = budget
                            showingEditBudget = true
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.blue)
                    }
                }
            }
            .alert("Confirm Delete", isPresented: $showingDeleteConfirmation) {
                Button("Delete", role: .destructive) {
                    if let budget = budgetToDelete {
                        withAnimation {
                            dataManager.deleteBudget(budget)
                        }
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Are you sure you want to delete this budget?")
            }
            .navigationTitle("Budgets")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        showingAddBudget = true
                    }) {
                        Label("Add Budget", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddBudget) {
                AddBudgetView()
                    .environmentObject(dataManager)
            }
            .sheet(item: $budgetToEdit) { budget in
                EditBudgetView(budget: budget)
                    .environmentObject(dataManager)
            }
        }
    }
    
    private func percentageUsed(budget: Budget) -> Int {
        guard budget.amount != 0 else {
            return 0
        }
        return Int((budget.usedAmount / budget.amount) * 100)
    }
    private func xPosition(for progress: Double, in width: CGFloat) -> CGFloat {
        
        func calculateBasePadding(for progress: Double) -> CGFloat {
               let progressString = String(progress)
               let ninesCount = progressString.filter { $0 == "9" }.count

               switch ninesCount {
               case 1:
                   return 25
               case 2:
                   return 32
//               case 3:
//                   return 40
//               case 4:
//                   return 48
//               case 5:
//                   return 56
//               case 6:
//                   return 64
               // You can add more cases if needed
               default:
                   return 15
               }
           }

           let basePadding: CGFloat = progress > 9.99 ? 25 : calculateBasePadding(for: progress)
      
        
        let maxX = width - basePadding
        let minX = basePadding

        // Cap progress to a maximum of 100% for positioning purposes
        let cappedProgress = min(progress, 1.0)
        let rawPosition = width * CGFloat(cappedProgress)

        // Ensure the raw position stays within the bounds
        if rawPosition < minX {
            return minX
        } else if rawPosition > maxX {
            return maxX
        } else {
            return rawPosition
        }
    }






}
