import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var dataManager: DataManager
    let specifiers = ["%.0f", "%.1f", "%.2f"]
    let humanReadableSpecifiers = ["0 decimal", "1 decimal", "2 decimal"]
    @State private var exampleValue: Double = 1234.567
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Number Format")) {
                    Text("Choose how you want to format the decimal values in the app.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 10)
                    
                    Picker("Decimal Specifier", selection: $dataManager.settings.decimalSpecifier) {
                        ForEach(Array(zip(specifiers, humanReadableSpecifiers)), id: \.0) { specifier, description in
                            Text(description)
                                .tag(specifier)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    VStack(alignment: .leading) {
                        Text("Example:")
                            .font(.headline)
                            .padding(.top, 10)
                        Text("$\(exampleValue, specifier: dataManager.settings.decimalSpecifier)")
                            .font(.title)
                            .padding(.top, 5)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Settings")
            .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
        }
        .onDisappear {
            dataManager.saveSettings()
        }
    }
}

#if DEBUG
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(DataManager())
    }
}
#endif
