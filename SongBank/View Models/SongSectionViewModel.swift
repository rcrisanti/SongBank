//
//  SongSectionViewModel.swift
//  CoreDataMVVM
//
//  Created by Ryan Crisanti on 5/10/21.
//

import Foundation

extension SongSectionView {
    class ViewModel: ObservableObject, Identifiable {
        @Published var songSection: SongSection
        let id: UUID
        @Published var header: String
        @Published var lines: [SongLineView.ViewModel]
        
        var disabled: Bool {
            header.isEmpty || header == songSection.header
        }
        
        init(_ songSection: SongSection) {
            self.songSection = songSection
            header = songSection.wrappedHeader
            id = songSection.wrappedId
            lines = songSection.wrappedLines.map(SongLineView.ViewModel.init)
            refresh()
        }
        
        convenience init(in song: Song) {
            let songSection = SongSection(context: PersistenceController.shared.viewContext)
            songSection.song = song
            songSection.id = UUID()
            
            self.init(songSection)
        }
        
        func fetchLines() {
            lines = PersistenceController.shared.fetchLines(in: songSection).map(SongLineView.ViewModel.init)
        }
        
        func refresh() {
            PersistenceController.shared.save()
            fetchLines()
        }
        
        func save() {
            songSection.header = header
            songSection.lines = NSOrderedSet(array: lines)
            refresh()
        }
        
        func deleteLines(at offsets: IndexSet) {
            offsets.forEach { index in
                let line = lines[index]
                PersistenceController.shared.viewContext.delete(line.songLine)
            }
            refresh()
        }
    }
}
