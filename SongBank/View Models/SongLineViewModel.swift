//
//  SongLineViewModel.swift
//  CoreDataMVVM
//
//  Created by Ryan Crisanti on 5/10/21.
//

import Foundation
import os.log

extension SongLineView {
    class ViewModel: ObservableObject, Identifiable, CustomDebugStringConvertible {
        @Published var songLine: SongLine
        @Published var lineSections: [SongLineSectionEditView.ViewModel]
        let id: UUID
        
        var disabled: Bool {
            false
        }
        
        // MARK: Initializers
        init(_ songLine: SongLine) {
            self.songLine = songLine
            lineSections = songLine.wrappedLineSections.map { SongLineSectionEditView.ViewModel($0) }
            id = songLine.wrappedId
//            refresh()
        }
        
        convenience init(in songSection: SongSection) {
            let songLine = SongLine(context: PersistenceController.shared.viewContext)
            songLine.id = UUID()
            songLine.section = songSection
            
            self.init(songLine)
        }
        
        // MARK: Saving & Refreshing
        func fetchLineSections() {
            lineSections = PersistenceController.shared.fetchLineSections(in: songLine).map { SongLineSectionEditView.ViewModel($0) }
        }
        
        func refresh() {
            PersistenceController.shared.save()
            fetchLineSections()
        }
        
        func save() {
            songLine.lineSections = NSOrderedSet(array: lineSections.map { $0.songLineSection })
            refresh()
            
            Self.logger.debug("\(self.debugDescription) successfully saved")
        }
        
        func cancel() {
            PersistenceController.shared.viewContext.rollback()
            lineSections = songLine.wrappedLineSections.map { SongLineSectionEditView.ViewModel($0) }
            
            Self.logger.debug("\(self.debugDescription) successfully canceled")
        }
        
        // MARK: Delete LineSections
        func deleteLineSections(at offsets: IndexSet) {
            offsets.forEach { index in
                let lineSection = lineSections[index]
                PersistenceController.shared.viewContext.delete(lineSection.songLineSection)
            }
            refresh()
            
            Self.logger.debug("\(self.debugDescription) successfully deleted line sections")
        }
        
        // MARK: Merge
        func merge(_ first: SongLineSection, with second: SongLineSection) {
            first.lyrics = first.wrappedLyrics + second.wrappedLyrics
            
            PersistenceController.shared.viewContext.delete(second)
            refresh()
            
            Self.logger.debug("\(self.debugDescription) successfully merged sections")
        }
        
        func merge(_ ids: Set<UUID>) {
            if ids.count == 2 {
                let first: SongLineSection = lineSections.first(where: { ids.contains($0.id) })!.songLineSection
                let second: SongLineSection = lineSections.last(where: { ids.contains($0.id) })!.songLineSection
                
                merge(first, with: second)
                
            } else {
                Self.logger.fault("Could not merge because there were \(ids.count) IDs passed, but expected exactly 2")
            }
        }
        
        // MARK: Split
        func splitSection(_ id: UUID, at cursorPos: Int, newChord: String? = nil) {
            let index = songLine.wrappedLineSections.firstIndex(where: { id == $0.id })!
            let originalSection = songLine.wrappedLineSections[index]
            
            let newSection = SongLineSection(context: PersistenceController.shared.viewContext)
            newSection.id = UUID()
            newSection.line = songLine
            newSection.lyrics = String(originalSection.wrappedLyrics.suffix(originalSection.wrappedLyrics.count - cursorPos))
            newSection.chord = newChord
            newSection.line = originalSection.line
            
            originalSection.lyrics = String(originalSection.wrappedLyrics.prefix(cursorPos))
            
            songLine.insertIntoLineSections(newSection, at: index + 1)
            
            refresh()
            
            Self.logger.debug("\(self.debugDescription) successfully split sections")
        }
        
        // MARK: Logging & Debugging
        var debugDescription: String {
            "SongLineView.ViewModel(song: \(songLine.wrappedSection.wrappedSong.wrappedTitle), section: \(songLine.wrappedSection.wrappedHeader), nLineSections: \(lineSections.count))"
        }
        
        static let logger = Logger(subsystem: "com.rcrisanti.SongBank", category: "SongLineView.ViewModel")
    }
}
