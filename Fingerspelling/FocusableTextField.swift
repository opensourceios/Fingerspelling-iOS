import SwiftUI

// https://stackoverflow.com/a/56508132/1157536
struct FocusableTextField: UIViewRepresentable {
  class Coordinator: NSObject, UITextFieldDelegate {
    @Binding var text: String
    var didBecomeFirstResponder = false

    init(text: Binding<String>) {
      _text = text
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
      self.text = textField.text ?? ""
    }
  }

  @Binding var text: String
  var isFirstResponder: Bool = false
  var placeholder: String = ""

  func makeUIView(context: UIViewRepresentableContext<FocusableTextField>) -> UITextField {
    let textField = UITextField(frame: .zero)
    textField.delegate = context.coordinator
    textField.borderStyle = .roundedRect
    textField.placeholder = self.placeholder
    return textField
  }

  func makeCoordinator() -> FocusableTextField.Coordinator {
    Coordinator(text: $text)
  }

  func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<FocusableTextField>) {
    uiView.text = self.text
    if self.isFirstResponder, !context.coordinator.didBecomeFirstResponder {
      uiView.becomeFirstResponder()
      context.coordinator.didBecomeFirstResponder = true
    }
  }
}