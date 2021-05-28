//
//  CheckboxCustomToggleStyle.swift
//  CoreDataMVVM
//
//  Created by Ryan Crisanti on 5/12/21.
//

import SwiftUI

struct CheckboxCustomToggleStyle: ToggleStyle {
    let onSystemImage: String
    let offSystemImage: String
    let onColor: Color
    let offColor: Color
    
    init(onSystemImage: String = "checkmark.circle.fill", offSystemImage: String = "circle", onColor: Color = .blue, offColor: Color = .gray) {
        self.onSystemImage = onSystemImage
        self.offSystemImage = offSystemImage
        self.onColor = onColor
        self.offColor = offColor
    }
    
    func makeBody(configuration: Self.Configuration) -> some View {
        Image(systemName: configuration.isOn ? onSystemImage : offSystemImage)
            .resizable()
            .frame(width: 24, height: 24)
            .foregroundColor(configuration.isOn ? onColor : offColor)
            .onTapGesture {
                configuration.isOn.toggle()
            }
    }
}

struct CheckboxCustomToggleStyle_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            Toggle("Toggle", isOn: .constant(false))
            Toggle("Toggle", isOn: .constant(true))
        }
        .toggleStyle(CheckboxCustomToggleStyle(onSystemImage: "1.circle.fill", onColor: .green, offColor: .black))
    }
}
