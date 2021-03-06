//
//  SignupViewController.swift
//  words
//
//  Created by Neo Ighodaro on 09/12/2017.
//  Copyright (c) 2017 CreativityKills Co.. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol SignupFormErrorLogic {
    func showValidationError(_ message: String)
}

class SignupViewController: UIViewController, SignupFormErrorLogic {
    
    // MARK: Properties
    
    var interactor: SignupBusinessLogic?
    var router: (NSObjectProtocol & SignupRoutingLogic)?

    // MARK: Object lifecycle
  
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
  
    // MARK: Setup
  
    private func setup() {
        let viewController = self
        let interactor = SignupInteractor()
        let router = SignupRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.router = router
        interactor.viewController = viewController
        router.viewController = viewController
    }
    
    // MARK: Input fields

    @IBOutlet weak var fullNameTextField: AuthTextField!
    @IBOutlet weak var emailTextField: AuthTextField!
    @IBOutlet weak var passwordTextField: AuthTextField!
    
    // MARK: Actions
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func signupButtonPressed(_ sender: Any) {
        let request = Signup.Request(
            name: fullNameTextField.text!,
            email: emailTextField.text!,
            password: passwordTextField.text!
        )
        
        interactor?.createAccount(request: request)
    }

    func showValidationError(_ message: String) {
        let alertCtrl = UIAlertController(title: "Oops! An error occurred", message: message, preferredStyle: .alert)
        alertCtrl.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.show(alertCtrl, sender: self)
    }
}
