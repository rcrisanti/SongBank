//
//  SongViewModel.swift
//  CoreDataMVVM
//
//  Created by Ryan Crisanti on 5/10/21.
//

import Foundation

extension SongView {
    class ViewModel: ObservableObject, Identifiable {
        @Published var song: Song
        let id: UUID
        @Published var title: String
        @Published var author: String
        @Published var modified: Date
        @Published var sections: [SongSectionView.ViewModel]
        
        var disabled: Bool {
            title.isEmpty || author.isEmpty || (title == song.wrappedTitle && author == song.wrappedAuthor)
        }
        
        init(_ song: Song = Song(context: PersistenceController.shared.viewContext)) {
            song.id = song.wrappedId
            self.song = song
            title = song.wrappedTitle
            author = song.wrappedAuthor
            modified = song.wrappedModified
            sections = song.wrappedSections.map(SongSectionView.ViewModel.init)
            id = song.wrappedId
        }
        
        func fetchSections() {
            sections = PersistenceController.shared.fetchSections(in: song).map(SongSectionView.ViewModel.init)
        }
        
        func refresh() {
            PersistenceController.shared.save()
            fetchSections()
        }
        
        func save() {
            song.id = id
            song.title = title
            song.author = author
            song.modified = Date()
            song.sections = NSOrderedSet(array: sections.map { $0.songSection })
            
            refresh()
        }
        
        func deleteSections(at offsets: IndexSet) {
            offsets.forEach { index in
                let section = sections[index]
                PersistenceController.shared.viewContext.delete(section.songSection)
            }
            refresh()
        }
        
        func cancel() {            
            PersistenceController.shared.viewContext.rollback()
            
            title = song.wrappedTitle
            author = song.wrappedAuthor
            sections = song.wrappedSections.map(SongSectionView.ViewModel.init)
            refresh()
        }
    }
}
