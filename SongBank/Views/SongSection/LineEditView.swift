//
//  LineEditView.swift
//  CoreDataMVVM
//
//  Created by Ryan Crisanti on 5/11/21.
//

import SwiftUI

struct LineEditView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel: SongLineView.ViewModel
    
    init(viewModel: SongLineView.ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    init(songSection: SongSection) {
        self.init(viewModel: .init(in: songSection))
    }
    
    var body: some View {
        NavigationView {
            Form {
                Text(viewModel.id.uuidString)
            }
            .navigationTitle("Edit Line")
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

struct LineEditView_Previews: PreviewProvider {
    static let songLine = SongLine(context: PersistenceController.preview.viewContext)
    static let viewModel = SongLineView.ViewModel(songLine)
    
    static var previews: some View {
        LineEditView(viewModel: viewModel)
    }
}
