//
//  CursorControlText.swift
//  SongBank
//
//  Created by Ryan Crisanti on 5/27/21.
//

import SwiftUI
import os.log

struct CursorControlText: UIViewRepresentable {
    let text: String
    @Binding var cursorPos: Int
    
    init(text: String, cursorPos: Binding<Int>) {
        self.text = text
        _cursorPos = cursorPos
    }
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.text = text
        textView.becomeFirstResponder()
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        if let newCursorPosition = uiView.position(from: uiView.beginningOfDocument, offset: cursorPos) {
            uiView.selectedTextRange = uiView.textRange(from: newCursorPosition, to: newCursorPosition)
        }
        logger.error("Could not get new cursor position at position \(cursorPos) for text of len \(text.count)")
    }
    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, UITextViewDelegate {
//        var parent: CursorControlText
//
//        init(_ parent: CursorControlText) {
//            self.parent = parent
//            super.init()
//        }
//
//        func getCursorPos(textView: UITextView) -> Int {
//            if let selectedRange = textView.selectedTextRange {
//                let cursorPos = textView.offset(from: textView.beginningOfDocument, to: selectedRange.start)
//                return cursorPos
//            }
//            parent.logger.error("Could not determine selected text range")
//            return 0
//        }
//
//        func textViewDidChangeSelection(_ textView: UITextView) {
//            cursorPos = getCursorPos(textView: <#T##UITextView#>)
//        }
//    }
    
    let logger = Logger(subsystem: "com.rcrisanti.SongBank", category: "CursorControlText")
    
    typealias UIViewType = UITextView
}
