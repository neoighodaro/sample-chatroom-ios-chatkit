//
//  ListContactsInteractor.swift
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

protocol ListContactsBusinessLogic {
    func fetchContacts(request: ListContacts.FetchContacts.Request)
    func addContact(request: ListContacts.AddContact.Request)
}

protocol ListContactsDataStore {
    var contacts: [Contact]? { get }
}

class ListContactsInteractor: ListContactsBusinessLogic, ListContactsDataStore {
    
    // MARK: Properties
    
    var contacts: [Contact]?
    var presenter: ListContactsPresentationLogic?
    var worker: UsersWorker = UsersWorker(usersStore: UsersAPI())

    // MARK: Fetch Contacts
  
    func fetchContacts(request: ListContacts.FetchContacts.Request) {
        worker.fetchContacts { (contacts, error) in
            if contacts != nil {
                self.presenter?.presentContacts(contacts!)
            }
        }
    }
    
    // MARK: Add contact
    
    func addContact(request: ListContacts.AddContact.Request) {
        worker.addContact(request: request) { (contact, error) in
            if error == nil {
            } else {
                print("Error adding contact")
            }
        }
    }
}
