//
//  SongSectionViewModel.swift
//  CoreDataMVVM
//
//  Created by Ryan Crisanti on 5/10/21.
//

import Foundation
import os.log

extension SongSectionView {
    class ViewModel: ObservableObject, Identifiable, CustomDebugStringConvertible {
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
//            refresh()
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
            
            Self.logger.debug("\(self.debugDescription) successfully saved")
        }
        
        func deleteLines(at offsets: IndexSet) {
            offsets.forEach { index in
                let line = lines[index]
                PersistenceController.shared.viewContext.delete(line.songLine)
            }
            refresh()
            
            Self.logger.debug("\(self.debugDescription) successfully deleted lines")
        }
        
        // MARK: Logging & Debugging
        var debugDescription: String {
            "SongSectionView.ViewModel(song: \(songSection.wrappedSong.wrappedTitle), header: \(header), nLines: \(lines.count))"
        }
        
        static let logger = Logger(subsystem: "com.rcrisanti.SongBank", category: "SongSectionView.ViewModel")
    }
}
