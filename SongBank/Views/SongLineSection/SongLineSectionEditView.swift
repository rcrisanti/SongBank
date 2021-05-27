//
//  SongLineSectionEditView.swift
//  CoreDataMVVM
//
//  Created by Ryan Crisanti on 5/10/21.
//

import SwiftUI
import os.log

struct SongLineSectionEditView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: ViewModel
    
    static let logger = Logger(subsystem: "com.rcrisanti.SongBank", category: "SongLineSectionView")
    
    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    init(songLine: SongLine) {
        _viewModel = StateObject(wrappedValue: ViewModel(in: songLine))
    }
    
    var body: some View {
        Form {
            Section(header: Text("Chord")) {
                TextField("Chord", text: $viewModel.chord)
            }
            
            Section(header: Text("Lyrics")) {
//                TextField("Lyrics", text: $viewModel.lyrics)
                TextEditor(text: $viewModel.lyrics)
            }
        }
        .navigationBarTitle("...\(String(viewModel.id.uuidString.suffix(8)))", displayMode: .automatic)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    viewModel.cancel()
                    presentationMode.wrappedValue.dismiss()
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    viewModel.save()
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(viewModel.disabled)
            }
        }
    }
}

struct SongLineSectionView_Previews: PreviewProvider {
    static let songLineSection = SongLineSection(context: PersistenceController.preview.viewContext)
    static let viewModel = SongLineSectionEditView.ViewModel(songLineSection)
    
    static var previews: some View {
        NavigationView {
            SongLineSectionEditView(viewModel: viewModel)
                .onAppear {
                    viewModel.lyrics = "Here are some lyrics"
                    viewModel.chord = "C"
            }
        }
    }
}
