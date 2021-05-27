//
//  SongLineSectionEditViewModel.swift
//  CoreDataMVVM
//
//  Created by Ryan Crisanti on 5/10/21.
//

import Foundation
import os.log

extension SongLineSectionEditView {
    class ViewModel: ObservableObject, Identifiable, CustomDebugStringConvertible, Equatable {
        @Published var songLineSection: SongLineSection
        @Published var lyrics: String
        @Published var chord: String
        let id: UUID
                
        var disabled: Bool {
            lyrics.isEmpty || (lyrics == songLineSection.wrappedLyrics && chord == songLineSection.wrappedChord)
        }
        
        // MARK: Initializers
        init(_ songLineSection: SongLineSection) {
            self.songLineSection = songLineSection
            
            lyrics = songLineSection.wrappedLyrics
            chord = songLineSection.wrappedChord
            id = songLineSection.wrappedId
        }
        
        convenience init(in songLine: SongLine) {
            let songLineSection = SongLineSection(context: PersistenceController.shared.viewContext)
            songLineSection.line = songLine
            songLineSection.id = UUID()
            
            self.init(songLineSection)
        }
        
        // MARK: Saving & Refreshing
        func save() {
            songLineSection.lyrics = lyrics
            songLineSection.chord = chord.isEmpty ? nil : chord
            
            PersistenceController.shared.save()
        }
        
        func cancel() {
            PersistenceController.shared.viewContext.rollback()
            lyrics = songLineSection.wrappedLyrics
            chord = songLineSection.wrappedChord
        }
        
        // MARK: Get index
        var index: Result<Int, SongLineSectionError> {
            guard let index = songLineSection.wrappedLine.wrappedLineSections.firstIndex(of: songLineSection) else {
                return .failure(.IndexError("Could not find index of SongLineSection '\(self.songLineSection)' in SongLine '\(self.songLineSection.wrappedLine.wrappedLineSections)'"))
            }
            return .success(index)
        }
        
        func getIndex() -> Int {
            switch index {
            case .success(let index):
                return index
            case .failure(let error):
                Self.logger.error("\(error.localizedDescription)")
                return 0
            }
        }
        
        // MARK: Protocol Conformance
        static func == (lhs: SongLineSectionEditView.ViewModel, rhs: SongLineSectionEditView.ViewModel) -> Bool {
            (lhs.id == rhs.id) && (lhs.chord == rhs.chord) && (lhs.lyrics == rhs.lyrics)
        }
        
        // MARK: Logging & Debugging
        var debugDescription: String {
            "SongLineSectionEditView.ViewModel(chord: \(chord), lyrics: \(lyrics))"
        }
        
        static let logger = Logger(subsystem: "com.rcrisanti.SongBank", category: "SongLineSectionEditView.ViewModel")
    }
}
