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
    
    var body: some View {
        Menu {
            ForEach(Self.menuOptions) { option in
                Button(action: {
                    selectedOption = option.option
                    showingAlert = true
                }) {
                    Label(option.label, systemImage: option.systemImage)
                }
                .disabled(option.option.rawValue != multiSelection.count)
            }
        } label: {
            Image(systemName: "line.horizontal.3.circle.fill")
                .font(.system(size: 50))
        }
        .alert(isPresented: $showingAlert) {
            switch selectedOption {
            case .merge:
                return mergeAlert
            case .split:
                return splitAlert
            }
        }
    }
}

// MARK: - Menu options
extension LineActionMenu {
    enum LineActionMenuOptions: Int {
        // Associate value is the # of selections the action requires
        case merge = 2, split = 1
    }
    
    struct LineActionMenuOption: Identifiable {
        let id = UUID()
        let label: String
        let systemImage: String
        let option: LineActionMenuOptions
    }
    
    static let menuOptions = [
        LineActionMenuOption(label: "Merge", systemImage: "arrow.triangle.merge", option: .merge),
        LineActionMenuOption(label: "Split", systemImage: "square.split.2x1", option: .split)
    ]
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

// MARK: - Split Alert
extension LineActionMenu {
    var splitAlert: Alert {
        Alert(
            title: Text("Split the selected section?"),
            message: Text("This cannot be undone"),
            primaryButton: .default(Text("Split")) {
                withAnimation {
                    // TODO: split action here
                    showingToggles = false
                }
            },
            secondaryButton: .cancel() {
                withAnimation {
                    showingToggles = false
                }
            })
    }
}
