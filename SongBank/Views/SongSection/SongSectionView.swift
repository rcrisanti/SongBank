//
//  SongSectionView.swift
//  CoreDataMVVM
//
//  Created by Ryan Crisanti on 5/10/21.
//

import SwiftUI

struct SongSectionView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: ViewModel
    @State private var showingNewLineSheet = false
    
    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        List {
            ForEach(viewModel.lines) { line in
                NavigationLink(destination: SongLineView(viewModel: line)) {
                    LineListRow(viewModel: line)
                }
            }
            .onDelete(perform: viewModel.deleteLines)
        }
        .navigationBarTitle("Lines", displayMode: .large)
        .toolbar {
            // MARK: WHen this isnt here the back button disappears... why???
            ToolbarItem(placement: .navigationBarLeading) {
                Text("")
            }
            
            ToolbarItem(placement: .principal) {
                Text(viewModel.header)
                    .font(.headline)
            }
            
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    showingNewLineSheet = true
                }) {
                    Image(systemName: "plus")
                }
                
                EditButton()
            }
        }
        .fullScreenCover(isPresented: $showingNewLineSheet) {
            LineEditView(songSection: viewModel.songSection)
        }
        .onAppear {
            viewModel.refresh()
        }
        .onChange(of: showingNewLineSheet, perform: { _ in
            viewModel.refresh()
        })
    }
}

struct SongSectionView_Previews: PreviewProvider {
    static let songSection = SongSection(context: PersistenceController.preview.viewContext)
    static let viewModel = SongSectionView.ViewModel(songSection)
    
    static var previews: some View {
        NavigationView {
            SongSectionView(viewModel: viewModel)
                .onAppear {
                    viewModel.header = "Preview Header"
            }
        }
    }
}
