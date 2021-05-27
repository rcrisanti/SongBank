//
//  SplitFormView.swift
//  SongBank
//
//  Created by Ryan Crisanti on 5/27/21.
//

import SwiftUI

struct SplitFormView: View {
    @Binding var lyrics: String
    @State private var splitAt = 0.0
    
//    var splitAtPos: Int {
//        Int(splitAt)
//    }
//
//    var firstSection: String {
//        String(lyrics.prefix(splitAtPos))
//    }
//
//    var secondSection: String {
//        String(lyrics.suffix(lyrics.count - splitAtPos))
//    }
    
    var body: some View {
        let splitAtBinding = Binding<Int>(
            get: { Int(splitAt) },
            set: { splitAt = Double($0) }
        )
        
        NavigationView {
            Form {
//                Text(lyrics)
                                
                CursorControlText(text: lyrics, cursorPos: splitAtBinding)
                    .frame(height: 100)
//                    .disabled(true)
                
//                Section {
//                    HStack(alignment: .top, spacing: 0) {
//                        HStack(alignment: .top) {
//                            Text(firstSection)
//                            Divider()
//                        }
////                        Divider()
//                        Text(secondSection)
//                    }
//                }
                
                Section {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Split at cursor position \(splitAtBinding.wrappedValue)")
                        
                        Slider(value: $splitAt, in: 0...Double(lyrics.count), step: 1) {
                            Text("Split at cursor position \(splitAt)")
                        }
                    }
                }
            }
        }
    }
}

struct SplitFormView_Previews: PreviewProvider {
    static var previews: some View {
        SplitFormView(lyrics: .constant("Oh, she'll be comin' around the mountain when she comes"))
    }
}
