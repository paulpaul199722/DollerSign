import SwiftUI
struct CategoryView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showAddCategoryView = false
    @State private var selectedCategory: Category?
    @State private var showEditCategoryView = false
    @State private var categoryToDelete: Category?
    @State private var showingDeleteConfirmation = false

    var body: some View {
        NavigationView {
            List {
                ForEach(dataManager.categories) { category in
                    HStack {
                        Text(category.icon) // Display icon
                        Text(category.name)
                        Spacer()
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            categoryToDelete = category
                            showingDeleteConfirmation = true
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }

                        Button {
                            selectedCategory = category
                            showEditCategoryView = true
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.blue)
                    }
                }
            }
            .alert("Confirm Delete", isPresented: $showingDeleteConfirmation) {
                Button("Delete", role: .destructive) {
                    if let category = categoryToDelete {
                        withAnimation {
                            dataManager.removeCategory(category: category)
                        }
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Are you sure you want to delete this category?")
            }
            .navigationTitle("Categories")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddCategoryView = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddCategoryView) {
                AddCategoryView()
                    .environmentObject(dataManager)
            }
            .sheet(item: $selectedCategory) { category in
                EditCategoryView(category: category)
                    .environmentObject(dataManager)
            }
        }
    }
}
