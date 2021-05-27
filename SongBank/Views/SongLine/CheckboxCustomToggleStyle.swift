//
//  CheckboxCustomToggleStyle.swift
//  CoreDataMVVM
//
//  Created by Ryan Crisanti on 5/12/21.
//

import SwiftUI

struct CheckboxCustomToggleStyle: ToggleStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
            .resizable()
            .frame(width: 24, height: 24)
            .foregroundColor(configuration.isOn ? .blue : .gray)
            .onTapGesture {
                configuration.isOn.toggle()
            }
    }
}

struct CheckboxCustomToggleStyle_Previews: PreviewProvider {
    static var previews: some View {
        Toggle("Toggle", isOn: .constant(false))
            .toggleStyle(CheckboxCustomToggleStyle())
            .labelsHidden()
    }
}
