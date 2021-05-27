//
//  LineSectionListRow.swift
//  CoreDataMVVM
//
//  Created by Ryan Crisanti on 5/11/21.
//

import SwiftUI

struct LineSectionListRow: View {
    @Binding var viewModel: SongLineSectionEditView.ViewModel
    @State private var showingSheet = false
    @Binding var showingToggle: Bool
    @Binding var selectedItems: Set<UUID>
    var isSelected: Bool {
        selectedItems.contains(viewModel.id)
    }
    
    init(viewModel: Binding<SongLineSectionEditView.ViewModel>, showingToggle: Binding<Bool>, selectedItems: Binding<Set<UUID>>) {
        _viewModel = viewModel
        _selectedItems = selectedItems
        _showingToggle = showingToggle
    }
    
    var body: some View {
        let selectionController = Binding<Bool>(
            get: { isSelected },
            set: { setSelectionController(to: $0) }
        )
        
        HStack {
            if showingToggle {
                Toggle("Selected", isOn: selectionController)
                    .toggleStyle(CheckboxCustomToggleStyle())
            }
            
            VStack(alignment: .leading) {
                Text(viewModel.chord)
                Text(viewModel.lyrics)
            }
        }
        .sheet(isPresented: $showingSheet) {
            NavigationView {
                SongLineSectionEditView(viewModel: viewModel)
            }
        }
        .contextMenu(ContextMenu(menuItems: {
            Button(action: {
                showingSheet = true
            }) {
                Label("Edit", systemImage: "square.and.pencil")
            }
        }))
    }
}

// MARK: - Selection Controller
extension LineSectionListRow {
    func setSelectionController(to: Bool) {
        if to {
            selectedItems.insert(viewModel.id)
        } else {
            selectedItems.remove(viewModel.id)
        }
    }
}

struct LineSectionListRow_Previews: PreviewProvider {
    static let songLineSection = SongLineSection(context: PersistenceController.preview.viewContext)
    static let viewModel = SongLineSectionEditView.ViewModel(songLineSection)
    
    static var previews: some View {
        LineSectionListRow(viewModel: .constant(viewModel), showingToggle: .constant(true), selectedItems: .constant([viewModel.id]))
            .onAppear {
                viewModel.chord = "C"
                viewModel.lyrics = "Here are some lyrics"
            }
    }
}
