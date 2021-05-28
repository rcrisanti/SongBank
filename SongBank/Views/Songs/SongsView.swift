//
//  SongsView.swift
//  CoreDataMVVM
//
//  Created by Ryan Crisanti on 5/3/21.
//

import SwiftUI
import CoreData

struct SongsView: View {
    @StateObject private var viewModel = ViewModel()
    @State private var showingNewSongSheet = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.songs) { songVM in
                    NavigationLink(destination: SongView(viewModel: songVM)) {
                        SongListRow(viewModel: songVM)
                    }
                }
                .onDelete(perform: viewModel.deleteSongs)
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingNewSongSheet = true
                    }) {
                        Image(systemName: "plus")
                    }
                    
                    EditButton()
                }
            }
            .navigationTitle("Songs")
            .fullScreenCover(isPresented: $showingNewSongSheet) {
                SongEditView()
            }
        }
        .onAppear {
            viewModel.refresh()
        }
        .onChange(of: showingNewSongSheet, perform: { _ in
            viewModel.refresh()
        })
    }
}

struct SongsView_Previews: PreviewProvider {
    static var previews: some View {
        SongsView()
    }
}
