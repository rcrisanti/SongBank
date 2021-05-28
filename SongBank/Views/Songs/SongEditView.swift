//
//  SongEditView.swift
//  CoreDataMVVM
//
//  Created by Ryan Crisanti on 5/10/21.
//

import SwiftUI

struct SongEditView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel: SongView.ViewModel
    
    init(viewModel: SongView.ViewModel = .init()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Title", text: $viewModel.title)
                    TextField("Author", text: $viewModel.author)
                }
                
//                Text(viewModel.id.uuidString)
            }
            .navigationTitle("Edit Song")
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
}

struct SongEditView_Previews: PreviewProvider {
    static var previews: some View {
        SongEditView()
    }
}
