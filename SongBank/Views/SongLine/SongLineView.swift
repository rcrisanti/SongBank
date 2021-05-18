//
//  SongLineView.swift
//  CoreDataMVVM
//
//  Created by Ryan Crisanti on 5/3/21.
//

import SwiftUI

struct SongLineView: View {
    @Environment(\.editMode) var editMode
    @StateObject var viewModel: ViewModel
    @State private var showingNewLineSectionSheet = false
    @State private var multiSelection: Set<UUID> = []
    
    var mergeable: Bool {
        multiSelection.count == 2
    }
    
    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        let showingToggles = Binding<Bool>(
            get: {                
                switch editMode?.wrappedValue {
                case .active:
                    return true
                default:
                    return false
                }
            }, set: {
                switch $0 {
                case true:
                    editMode?.wrappedValue = .active
                default:
                    editMode?.wrappedValue = .inactive
                }
            }
        )
        
        List {
            ForEach(viewModel.lineSections) { lineSection in
                NavigationLink(destination: SongLineSectionView(viewModel: lineSection, editable: false)) {
                    LineSectionListRow(
                        viewModel: $viewModel.lineSections[viewModel.lineSections.firstIndex(of: lineSection)!],
                        showingToggle: showingToggles,
                        selectedItems: $multiSelection
                    )
                }
            }
            .onDelete(perform: viewModel.deleteLineSections)
        }
        .navigationBarTitle("Line Sections", displayMode: .large)
        .toolbar {
            // MARK: When this isnt here the back button disappears... why???
            ToolbarItem(placement: .navigationBarLeading) {
                Text("")
            }
            
            ToolbarItem(placement: .principal) {
                Text("...\(String(viewModel.id.uuidString.suffix(8)))")
            }
            
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.merge(multiSelection)
                }) {
                    Image(systemName: "arrow.triangle.merge")
                }
                .disabled(!mergeable)
                
                Button(action: {
                    showingNewLineSectionSheet = true
                }) {
                    Image(systemName: "plus")
                }
                
                EditButton()
            }
        }
        .fullScreenCover(isPresented: $showingNewLineSectionSheet) {
            NavigationView {
                SongLineSectionView(songLine: viewModel.songLine, editable: true)
            }
        }
        .onAppear {
            viewModel.refresh()
        }
        .onChange(of: showingNewLineSectionSheet, perform: { _ in
            viewModel.refresh()
        })
    }
}

struct SongLineView_Previews: PreviewProvider {
    static let songLine = SongLine(context: PersistenceController.preview.viewContext)
    static let viewModel = SongLineView.ViewModel(songLine)

    static var previews: some View {
        NavigationView {
            SongLineView(viewModel: viewModel)
        }
    }
}
