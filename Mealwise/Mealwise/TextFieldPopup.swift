//
//  TextFieldPopup.swift
//

import SwiftUI

struct TextFieldPopup: View {
    
    let screenSize = UIScreen.main.bounds
    var title: String = ""
    @Binding var isShown: Bool
    @Binding var text: String
    var onDone: (String) -> Void = { _ in }
    var onCancel: () -> Void = { }
    
    
    var body: some View {
    
        VStack(spacing: 20) {
            Text(title)
                .font(.headline)
            TextField("", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            HStack(spacing: 20) {
                Button("Done") {
                    self.isShown = false
                    self.onDone(self.text)
                }
                Button("Cancel") {
                    self.isShown = false
                    self.onCancel()
                }
            }
        }
        .padding()
        .frame(width: screenSize.width * 0.8, height: screenSize.height * 0.5)
        .background(Color(UIColor.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20.0, style: .continuous))
        .offset(y: isShown ? 0 : screenSize.height)
        .animation(.spring())
        //.shadow(color: Color(#colorLiteral(red: 0.8596749902, green: 0.854565084, blue: 0.8636032343, alpha: 1)), radius: 6, x: -9, y: -9)

    }
}

struct TextFieldPopup_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldPopup(title: "Add Item", isShown: .constant(true), text: .constant(""))
    }
}
