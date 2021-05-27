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
    @State private var showingToggles = false {
        didSet { multiSelection = [] }
    }
    
    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            List {
                ForEach(viewModel.lineSections) { lineSection in
                    NavigationLink(destination: SongLineSectionEditView(viewModel: lineSection)) {
                        LineSectionListRow(
                            viewModel: $viewModel.lineSections[lineSection.getIndex()],
                            showingToggle: $showingToggles,
                            selectedItems: $multiSelection
                        )
                    }
                }
                .onDelete(perform: viewModel.deleteLineSections)
            }
            
            HStack {
                Spacer()
                VStack {                    
                    Spacer()
                    LineActionMenu(
                        viewModel: viewModel,
                        multiSelection: $multiSelection,
                        showingToggles: $showingToggles
                    )
                    .padding([.bottom, .trailing], 30)
                }
            }
        }
        .navigationBarTitle("Line Sections", displayMode: .large)
        .toolbar { toolbar }
        .fullScreenCover(isPresented: $showingNewLineSectionSheet) {
            NavigationView {
                SongLineSectionEditView(songLine: viewModel.songLine)
            }
        }
        .onAppear {
            viewModel.refresh()
        }
        .onChange(of: showingNewLineSectionSheet, perform: { _ in viewModel.refresh() })
    }
}

// MARK: - Toolbar
extension SongLineView {
    @ToolbarContentBuilder
    var toolbar: some ToolbarContent {
        // MARK: When this isnt here the back button disappears... why???
        ToolbarItem(placement: .navigationBarLeading) {
            Text("")
        }
        
        ToolbarItem(placement: .principal) {
            Text("...\(String(viewModel.id.uuidString.suffix(8)))")
        }
        
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            Button(action: {
                withAnimation { showingToggles.toggle() }
            }) {
                Image(systemName: "checkmark.circle\(showingToggles ? ".fill" : "")")
            }
            
            Button(action: {
                showingNewLineSectionSheet = true
            }) {
                Image(systemName: "plus")
            }
            
            EditButton()
        }
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
