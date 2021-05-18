//
//  LineListRow.swift
//  CoreDataMVVM
//
//  Created by Ryan Crisanti on 5/11/21.
//

import SwiftUI

struct LineListRow: View {
    @StateObject private var viewModel: SongLineView.ViewModel
    @State private var showingSheet = false
    
    init(viewModel: SongLineView.ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Text(viewModel.id.uuidString)
            .fullScreenCover(isPresented: $showingSheet) {
                LineEditView(viewModel: viewModel)
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

struct LineListRow_Previews: PreviewProvider {
    static let songLine = SongLine(context: PersistenceController.preview.viewContext)
    static let viewModel = SongLineView.ViewModel(songLine)
    
    static var previews: some View {
        NavigationView {
            LineListRow(viewModel: viewModel)
        }
    }
}
