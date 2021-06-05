//
//  LineActionMenu.swift
//  SongBank
//
//  Created by Ryan Crisanti on 5/18/21.
//

import SwiftUI

struct LineActionMenu: View {
    @ObservedObject var viewModel: SongLineView.ViewModel
    @Binding var multiSelection: Set<UUID>
    @Binding var showingToggles: Bool
    
    @State private var selectedOption: LineActionMenuOptions = .merge
    @State private var showingAlert = false
    @State private var showingSheet = false
    
    var body: some View {
        let menuOptions = [
            LineActionMenuOption(label: "Merge", systemImage: "arrow.triangle.merge", requiredSelections: 2) {
                selectedOption = .merge
                showingAlert = true
            },
            LineActionMenuOption(label: "Split", systemImage: "square.split.2x1", requiredSelections: 1) {
                selectedOption = .split
                showingSheet = true
            }
        ]
        
        Menu {
            ForEach(menuOptions) { option in
                Button(action: {
                    option.action()
                }) {
                    Label(option.label, systemImage: option.systemImage)
                }
                .disabled(option.requiredSelections != multiSelection.count)
            }
        } label: {
            Image(systemName: "line.horizontal.3.circle.fill")
                .font(.system(size: 50))
        }
        .alert(isPresented: $showingAlert) {
            switch selectedOption {
            case .merge:
                return mergeAlert
            default:
                return unknownActionAlert
            }
        }
        .sheet(isPresented: $showingSheet) {
            SplitFormView(viewModel: viewModel, id: multiSelection.first!)
        }
    }
}

// MARK: - Menu options
extension LineActionMenu {
    enum LineActionMenuOptions {
        case merge, split
    }
    
    struct LineActionMenuOption: Identifiable {
        let id = UUID()
        let label: String
        let systemImage: String
        let requiredSelections: Int
        let action: () -> Void
    }
    
    var unknownActionAlert: Alert {
        Alert(
            title: Text("Unknown Action"),
            message: Text("No alert should have appeared..."),
            dismissButton: .default(Text("OK"))
        )
    }
}

// MARK: - Merge Alert
extension LineActionMenu {
    var mergeAlert: Alert {
        Alert(
            title: Text("Merge the selected 2 sections?"),
            message: Text("This cannot be undone"),
            primaryButton: .default(Text("Merge")) {
                withAnimation {
                    viewModel.merge(multiSelection)
                    showingToggles = false
                }
            },
            secondaryButton: .cancel() {
                withAnimation {
                    showingToggles = false
                }
            }
        )
    }
}
