import SwiftUI

struct EditCategoryView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    @State var category: Category

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    TextField("Category Name", text: $category.name)
                    TextField("Icon", text: $category.icon) // Optional: use a picker for icons
                }

                // Save Button outside the Form
                Button(action: {
                    dataManager.updateCategory(category)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save Changes")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(category.name.isEmpty ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                .disabled(category.name.isEmpty)
            }
            .navigationTitle("Edit Category")
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
