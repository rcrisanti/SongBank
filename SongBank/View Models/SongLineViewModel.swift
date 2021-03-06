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
        @Published var lineSections: [SongLineSectionView.ViewModel]
        
        let id: UUID
        
        var disabled: Bool {
            false
        }
        
        init(_ songLine: SongLine) {
            self.songLine = songLine
            lineSections = songLine.wrappedLineSections.map { SongLineSectionView.ViewModel($0) }
            id = songLine.wrappedId
            refresh()
        }
        
        convenience init(in songSection: SongSection) {
            let songLine = SongLine(context: PersistenceController.shared.viewContext)
            songLine.id = UUID()
            songLine.section = songSection
            
            self.init(songLine)
        }
        
        func fetchLineSections() {
            lineSections = PersistenceController.shared.fetchLineSections(in: songLine).map { SongLineSectionView.ViewModel($0) }
        }
        
        func refresh() {
            PersistenceController.shared.save()
            fetchLineSections()
        }
        
        func save() {
            songLine.lineSections = NSOrderedSet(array: lineSections)
            refresh()
        }
        
        func deleteLineSections(at offsets: IndexSet) {
            offsets.forEach { index in
                let lineSection = lineSections[index]
                PersistenceController.shared.viewContext.delete(lineSection.songLineSection)
            }
            refresh()
        }
        
        func merge(_ first: SongLineSection, with second: SongLineSection) {
            first.lyrics = first.wrappedLyrics + second.wrappedLyrics
            
            PersistenceController.shared.viewContext.delete(second)
            refresh()
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
        
        var debugDescription: String {
            "SongLineView.ViewModel(\(lineSections))"
        }
        
        static let logger = Logger(subsystem: "com.rcrisanti.CoreDataMVVM", category: "SongLineView.ViewModel")
    }
}
