//
//  SongLineSectionView.swift
//  CoreDataMVVM
//
//  Created by Ryan Crisanti on 5/10/21.
//

import SwiftUI
import os.log

struct SongLineSectionView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: ViewModel
    
    static let logger = Logger(subsystem: "com.rcrisanti.CoreDataMVVM", category: "SongLineSectionView")
    
    init(viewModel: ViewModel, editable: Bool? = nil) {
        if let editable = editable {
            viewModel.editable = editable
        }
        
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    init(songLine: SongLine, editable: Bool) {
        _viewModel = StateObject(wrappedValue: ViewModel(in: songLine, editable: editable))
    }
    
    var body: some View {
        Form {
            Section(header: Text("Chord")) {
                TextField("Chord", text: $viewModel.chord)
            }
            
            Section(header: Text("Lyrics")) {
                TextField("Lyrics", text: $viewModel.lyrics)
            }
        }
        .navigationBarTitle("...\(String(viewModel.id.uuidString.suffix(8)))", displayMode: .automatic)
        .disabled(!viewModel.editable)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                if viewModel.editable {
                    Button("Cancel") {
                        PersistenceController.shared.viewContext.rollback()
                        presentationMode.wrappedValue.dismiss()
                    }
                } else {
                    Text("")
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                if viewModel.editable {
                    Button("Save") {
                        viewModel.save()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(viewModel.disbled)
                } else {
                    Button(action: {
                        viewModel.editable.toggle()
                    }) {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
        }
    }
}

struct SongLineSectionView_Previews: PreviewProvider {
    static let songLineSection = SongLineSection(context: PersistenceController.preview.viewContext)
    static let viewModel = SongLineSectionView.ViewModel(songLineSection, editable: true)
    
    static var previews: some View {
        NavigationView {
            SongLineSectionView(viewModel: viewModel)
                .onAppear {
                    viewModel.lyrics = "Here are some lyrics"
                    viewModel.chord = "C"
            }
        }
    }
}
