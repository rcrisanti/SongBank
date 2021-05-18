//
//  SongsViewModel.swift
//  CoreDataMVVM
//
//  Created by Ryan Crisanti on 5/11/21.
//

import Foundation

extension SongsView {
    class ViewModel: ObservableObject {
        @Published var songs: [SongView.ViewModel] = []
        
        init() {
            refresh()
        }
        
        func fetchSongs() {
            songs = PersistenceController.shared.fetch().map(SongView.ViewModel.init)
        }
        
        func refresh() {
            objectWillChange.send()
            PersistenceController.shared.save()
            fetchSongs()
        }
        
        func deleteSongs(at offsets: IndexSet) {
            offsets.forEach { index in
                let songVM = songs[index]
                PersistenceController.shared.viewContext.delete(songVM.song)
            }
            
            refresh()
        }
    }
}
