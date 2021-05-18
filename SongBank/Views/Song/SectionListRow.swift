//
//  SectionListRow.swift
//  CoreDataMVVM
//
//  Created by Ryan Crisanti on 5/11/21.
//

import SwiftUI

struct SectionListRow: View {
    @StateObject private var viewModel: SongSectionView.ViewModel
    @State private var showingSheet = false
    
    init(viewModel: SongSectionView.ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Text(viewModel.header)
            .fullScreenCover(isPresented: $showingSheet) {
                SectionEditView(viewModel: viewModel)
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

struct SectionListRow_Previews: PreviewProvider {
    static let songSection = SongSection(context: PersistenceController.preview.viewContext)
    static let viewModel = SongSectionView.ViewModel(songSection)
    
    static var previews: some View {
        SectionListRow(viewModel: viewModel)
            .onAppear {
                viewModel.header = "Verse Preview"
            }
    }
}
