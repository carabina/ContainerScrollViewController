//
//  SignUpEmbeddedViewController.swift
//  Example
//
//  Created by Drew Olbrich on 12/23/18.
//  Copyright © 2018 Drew Olbrich. All rights reserved.
//

import UIKit

class SignUpEmbeddedViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var nameTextField: PillTextField!
    @IBOutlet weak var emailTextField: PillTextField!
    @IBOutlet weak var passwordTextField: PillTextField!

    @IBOutlet weak var signUpButton: PillButton!
    @IBOutlet weak var signInButton: UIButton!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        logoImageView.tintColor = .white

        let signInButtonTitleColor: UIColor = .white
        let signInButtonTitleFontSize: CGFloat = 15

        let signInButtonTitle = NSMutableAttributedString()

        let signInButtonTitleRegularFontAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: signInButtonTitleColor,
            .font: UIFont.systemFont(ofSize: signInButtonTitleFontSize, weight: .regular),
            ]
        let signInButtonTitleMediumFontAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: signInButtonTitleColor,
            .font: UIFont.systemFont(ofSize: signInButtonTitleFontSize, weight: .medium),
            ]

        signInButtonTitle.append(NSAttributedString(string: "Already have an account? ", attributes: signInButtonTitleRegularFontAttributes))
        signInButtonTitle.append(NSAttributedString(string: "Sign In", attributes: signInButtonTitleMediumFontAttributes))

        signInButton.setAttributedTitle(signInButtonTitle, for: .normal)

        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self

        nameTextField.addTarget(self, action: #selector(updateSignUpButtonIsEnabledState), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(updateSignUpButtonIsEnabledState), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(updateSignUpButtonIsEnabledState), for: .editingChanged)

        signUpButton.isEnabled = false
    }

    @objc private func updateSignUpButtonIsEnabledState() {
        // TODO: This test should be more sophisticated and perform full validation on each
        // field, depending on its type.
        signUpButton.isEnabled = !textFieldIsEmpty(nameTextField) && !textFieldIsEmpty(emailTextField) && !textFieldIsEmpty(passwordTextField)
    }

    private func textFieldIsEmpty(_ textField: UITextField) -> Bool {
        guard let text = trimmedText(of: textField) else {
            return true
        }
        return text.isEmpty
    }

    private func trimmedText(of textField: UITextField) -> String? {
        return textField.text?.trimmingCharacters(in: CharacterSet.whitespaces)
    }

}

extension SignUpEmbeddedViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            passwordTextField.resignFirstResponder()
        default:
            assertionFailure("Unrecognized text field")
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        // Strip leading and trailing whitespace.
        textField.text = trimmedText(of: textField)
    }

}
