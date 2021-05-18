//
//  SongLineSectionViewModel.swift
//  CoreDataMVVM
//
//  Created by Ryan Crisanti on 5/10/21.
//

import Foundation

extension SongLineSectionView {
    class ViewModel: ObservableObject, Identifiable, CustomDebugStringConvertible, Equatable {
        @Published var songLineSection: SongLineSection
        @Published var lyrics: String
        @Published var chord: String
        let id: UUID
        @Published var editable: Bool
                
        var disbled: Bool {
            lyrics.isEmpty || (lyrics == songLineSection.wrappedLyrics && chord == songLineSection.wrappedChord)
        }
        
        init(_ songLineSection: SongLineSection, editable: Bool = true) {
            self.songLineSection = songLineSection
            
            lyrics = songLineSection.wrappedLyrics
            chord = songLineSection.wrappedChord
            id = songLineSection.wrappedId
            self.editable = editable
        }
        
        convenience init(in songLine: SongLine, editable: Bool = true) {
            let songLineSection = SongLineSection(context: PersistenceController.shared.viewContext)
            songLineSection.line = songLine
            songLineSection.id = UUID()
            
            self.init(songLineSection, editable: editable)
        }
        
        func save() {
            songLineSection.lyrics = lyrics
            songLineSection.chord = chord.isEmpty ? nil : chord
            
            PersistenceController.shared.save()
        }
        
        static func == (lhs: SongLineSectionView.ViewModel, rhs: SongLineSectionView.ViewModel) -> Bool {
            (lhs.id == rhs.id) && (lhs.chord == rhs.chord) && (lhs.lyrics == rhs.lyrics)
        }
        
        var debugDescription: String {
            "SongLineSection.ViewModel(chord: \(chord), lyrics: \(lyrics))" 
        }
    }
}
