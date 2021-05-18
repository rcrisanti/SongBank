//
//  SongView.swift
//  CoreDataMVVM
//
//  Created by Ryan Crisanti on 5/3/21.
//

import SwiftUI

struct SongView: View {    
    @StateObject var viewModel: ViewModel
    @State private var showingNewSectionSheet = false
    
    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        List {
            ForEach(viewModel.sections) { section in
                NavigationLink(destination: SongSectionView(viewModel: section)) {
                    Text(section.header)
                }
            }
            .onDelete(perform: viewModel.deleteSections)
        }
        .navigationBarTitle("Sections", displayMode: .large)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(viewModel.title)
                        .font(.headline)
                    Text(viewModel.author)
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
            }
            
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    showingNewSectionSheet = true
                }) {
                    Image(systemName: "plus")
                }
                
                EditButton()
            }
        }
        .fullScreenCover(isPresented: $showingNewSectionSheet) {
            SectionEditView(song: viewModel.song)
        }
        .onAppear {
            viewModel.refresh()
        }
        .onChange(of: showingNewSectionSheet, perform: { _ in
            viewModel.refresh()
        })
    }
}

struct SongView_Previews: PreviewProvider {
    static let viewModel = SongView.ViewModel()
    
    static var previews: some View {
        NavigationView {
            SongView(viewModel: viewModel)
                .onAppear {
                    viewModel.author = "Preview Author"
                    viewModel.title = "Preview Title"
            }
        }
    }
}
