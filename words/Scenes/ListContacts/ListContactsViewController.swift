//
//  ListContactsViewController.swift
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

protocol ListContactsDisplayLogic: class {
    func displayFetchedContacts(viewModel: ListContacts.Fetch.ViewModel)
}

class ListContactsViewController: UITableViewController, ListContactsDisplayLogic {

    // MARK: Properties
    
    var interactor: ListContactsBusinessLogic?
    var displayedContacts: [ListContacts.Fetch.ViewModel.DisplayedContact] = []
    var router: (NSObjectProtocol & ListContactsRoutingLogic & ListContactsDataPassing)?

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
        let interactor = ListContactsInteractor()
        let presenter = ListContactsPresenter()
        let router = ListContactsRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
  
    // MARK: Routing
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
  
    // MARK: View lifecycle
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Update the titlebar
        navigationItem.title = "Contacts"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(showAddContactPopup))
        
        fetchContacts()
    }
    
    // MARK: - Add contact
    
    var emailTextField: UITextField?
    
    @objc func showAddContactPopup(_ sender: Any) {
        let alertController = UIAlertController(
            title: "Add",
            message: "Enter the email address to add user to your contacts list",
            preferredStyle: .alert
        )

        alertController.addTextField { emailTextField in
            emailTextField.placeholder = "Enter email address"
            self.emailTextField = emailTextField
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Add Contact", style: .default) { action in
            let request = ListContacts.Create.Request(user_id: self.emailTextField!.text!)
            self.interactor?.addContact(request: request)
        })
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: Fetch contacts
    
    private func fetchContacts() {
        interactor?.fetchContacts(request: ListContacts.Fetch.Request())
    }
  
    func displayFetchedContacts(viewModel: ListContacts.Fetch.ViewModel) {
        displayedContacts = viewModel.displayedContacts
        tableView.reloadData()
    }
}


// MARK: UITableViewDelegate

extension ListContactsViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedContacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell")
        
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "ContactTableViewCell")
        }

        let contact = displayedContacts[indexPath.row]

        cell?.textLabel?.text = contact.name
        cell?.detailTextLabel?.text = contact.isOnline ? "online" : "offline"

        return cell!
    }
}
