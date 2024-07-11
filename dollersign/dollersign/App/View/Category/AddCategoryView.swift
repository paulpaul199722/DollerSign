import SwiftUI

struct AddCategoryView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    @State private var categoryName: String = ""
    @State private var categoryIcon: String = "" // Optional

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    TextField("Category Name", text: $categoryName)
                    TextField("Icon", text: $categoryIcon) // Optional: use a picker for icons
                }

                // Save Button outside the Form
                Button(action: {
                    dataManager.addCategory(name: categoryName, icon: categoryIcon)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Add Category")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(categoryName.isEmpty ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                .disabled(categoryName.isEmpty)
            }
            .navigationTitle("Add Category")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
