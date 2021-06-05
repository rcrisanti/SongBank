//
//  SplitFormView.swift
//  SongBank
//
//  Created by Ryan Crisanti on 5/27/21.
//

import SwiftUI

struct SplitFormView: View {
    @Environment(\.presentationMode) var presentationMode
    let lineSectionId: UUID
    let lyrics: String
    let oldChord: String
    @State private var splitAt: Double
    @State private var newChord = ""
    @StateObject var viewModel: SongLineView.ViewModel
    
    init(viewModel: SongLineView.ViewModel, id: UUID) {
        _viewModel = StateObject(wrappedValue: viewModel)
        
        lineSectionId = id
        let lineSection = viewModel.lineSections.first(where: { $0.id == id})!
        lyrics = lineSection.lyrics
        oldChord = lineSection.chord
        _splitAt = State(initialValue: Double(lyrics.count))
    }
    
    var splitAtPos: Int {
        Int(splitAt)
    }

    var firstSection: String {
        String(lyrics.prefix(splitAtPos))
    }

    var secondSection: String {
        String(lyrics.suffix(lyrics.count - splitAtPos))
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    VStack(alignment: .leading) {
                        Text(oldChord)
                        Text(firstSection)
                    }
                    VStack(alignment: .leading) {
                        TextField("New Section Chord", text: $newChord)
                        Text(secondSection)
                    }
                }
                
                
                Section {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Split at cursor position \(splitAtPos)")
                        
                        Slider(value: $splitAt, in: 0...Double(lyrics.count), step: 1) {
                            Text("Split at cursor position \(splitAt)")
                        }
                    }
                }
            }
            .toolbar { toolbar }
            .navigationBarTitle("Split Section")
        }
    }
}

// MARK: - Toolbar
extension SplitFormView {
    var saveDisabled: Bool {
        splitAtPos < 1 || splitAtPos >= lyrics.count
    }
    
    @ToolbarContentBuilder
    var toolbar: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }
        }
        
        ToolbarItem(placement: .confirmationAction) {
            Button("Save") {
                viewModel.splitSection(lineSectionId, at: splitAtPos, newChord: newChord)
                viewModel.save()
                presentationMode.wrappedValue.dismiss()
            }
            .disabled(saveDisabled)
        }
    }
}

//struct SplitFormView_Previews: PreviewProvider {
//    static var previews: some View {
//        SplitFormView(lyrics: "Oh, she'll be comin' around the mountain when she comes", chord: "G")
//    }
//}
