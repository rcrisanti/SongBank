//
//  SongsViewModel.swift
//  CoreDataMVVM
//
//  Created by Ryan Crisanti on 5/11/21.
//

import Foundation
import os.log

extension SongsView {
    class ViewModel: ObservableObject, CustomDebugStringConvertible {
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
            
            Self.logger.debug("\(self.debugDescription) successfully deleted songs")
        }
        
        // MARK: Logging & Debugging
        var debugDescription: String {
            "SongsView.ViewModel(nSongs: \(songs.count))"
        }
        
        static let logger = Logger(subsystem: "com.rcrisanti.SongBank", category: "SongsView.ViewModel")
    }
}
