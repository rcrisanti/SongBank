//
//  SongListRow.swift
//  CoreDataMVVM
//
//  Created by Ryan Crisanti on 5/10/21.
//

import SwiftUI

struct SongListRow: View {
    @StateObject private var viewModel: SongView.ViewModel
    @State private var showingSheet = false
    
    init(viewModel: SongView.ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(viewModel.title)
                .font(.headline)
            Text(viewModel.author)
                .foregroundColor(.secondary)
        }
        .sheet(isPresented: $showingSheet) {
            SongEditView(viewModel: viewModel)
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

struct SongListRow_Previews: PreviewProvider {
    static let viewModel = SongView.ViewModel()
    
    static var previews: some View {
        SongListRow(viewModel: viewModel)
            .onAppear {
                viewModel.author = "Preview Author"
                viewModel.title = "Preview Title"
            }
    }
}
