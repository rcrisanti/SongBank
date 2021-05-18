//
//  SectionEditView.swift
//  CoreDataMVVM
//
//  Created by Ryan Crisanti on 5/11/21.
//

import SwiftUI

struct SectionEditView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel: SongSectionView.ViewModel
    
    init(viewModel: SongSectionView.ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    init(song: Song) {
        self.init(viewModel: .init(in: song))
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Header", text: $viewModel.header)
                }
                
                Text(viewModel.id.uuidString)
            }
            .navigationTitle("Edit Section")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        PersistenceController.shared.viewContext.rollback()
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
}

struct SectionEditView_Previews: PreviewProvider {
    static let song = Song(context: PersistenceController.preview.viewContext)
    
    static var previews: some View {
        SectionEditView(song: song)
    }
}
