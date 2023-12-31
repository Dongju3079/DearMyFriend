//
//  RegisterPasswordController.swift
//  DearMyFriend
//
//  Created by Macbook on 11/6/23.
//

import UIKit

class RegisterPasswordController: UIViewController {
    
    public var registerUser: RegisterUserRequest?
    
    private var isKeyboardUp = false
    
    private let registerView = RegisterPasswordView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAction()
        setupTextField()
        setupNavi()
        title = "비밀번호 생성"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerView.passwordField.becomeFirstResponder()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Action Setup
    private func setupNavi() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = ThemeColor.deepPink
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    private func setupAction() {
        registerView.signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }
    
    // MARK: - Selectors
    @objc private func didTapSignIn() {
        let registerPassword = self.registerView.passwordField.text ?? ""
        registerUser?.password = registerPassword
        let vc = RegisterProfileController()
        vc.registerUser = self.registerUser
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    private func setupUI() {
        self.view.addSubviews([registerView])
        
        NSLayoutConstraint.activate([
            registerView.topAnchor.constraint(equalTo: self.view.topAnchor),
            registerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            registerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            registerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension RegisterPasswordController {
    
    @objc func keyboardUp(notification:NSNotification) {
        if !isKeyboardUp, let keyboardFrame:NSValue =
            notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            isKeyboardUp = true
            let keyboardRectangle = keyboardFrame.cgRectValue.height
            let keyboardHeight = keyboardRectangle * 1.1
            
            UIView.animate(withDuration: 0.03, animations: {
                self.registerView.signInButton.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
            }
            )
        }
    }
    
    @objc func keyboardDown() {
        isKeyboardUp = false
        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.registerView.signInButton.transform  = .identity
            }
        )
    }
}

extension RegisterPasswordController : UITextFieldDelegate {
    
    func setupTextField() {
        self.registerView.passwordField.delegate = self
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        if Validator.checkNumber(for: newText) {
            self.registerView.checkNumber.validTrueColor()
        } else {
            self.registerView.checkNumber.validFalseColor()
        }
        //
        if Validator.checkIncludingOfNumber(for: newText) {
            self.registerView.checkIncludeNumber.validTrueColor()
        } else {
            self.registerView.checkIncludeNumber.validFalseColor()
        }
        //
        if Validator.checkIncludingOfEnglish(for: newText) {
            self.registerView.checkIncludeEnglish.validTrueColor()
        } else {
            self.registerView.checkIncludeEnglish.validFalseColor()
        }
        //
        if Validator.checkIncludingOfCharacters(for: newText) {
            self.registerView.checkIncludeCharacters.validTrueColor()
        } else {
            self.registerView.checkIncludeCharacters.validFalseColor()
        }
        
        if Validator.isPasswordValid(for: newText) {
            self.registerView.signInButton.validTrueColor()
            self.registerView.signInButton.isEnabled = true
        } else {
            self.registerView.signInButton.validFalseColor()
            self.registerView.signInButton.isEnabled = false
        }
        
        return true
    }
}
