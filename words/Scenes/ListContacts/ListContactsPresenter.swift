//
//  ListContactsPresenter.swift
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

protocol ListContactsPresentationLogic {
    func presentContacts(_ contacts: [Contact])
    func presentAddedContact(response: ListContacts.AddContact.Response)
}

class ListContactsPresenter: ListContactsPresentationLogic {
    
    // MARK: Properties
    
    var displayedContacts: [ListContacts.FetchContacts.ViewModel.DisplayedContact] = []
    weak var viewController: ListContactsDisplayLogic?
    
    // MARK: Present Contacts

    func presentContacts(_ contacts: [Contact]) {
        displayedContacts = []
        
        for contact in contacts {
            let contact = ListContacts.FetchContacts.ViewModel.DisplayedContact(name: contact.user.name, isOnline: false)
            displayedContacts.append(contact)
        }
            
        displayContacts()
    }
    
    func presentAddedContact(response: ListContacts.AddContact.Response) {
        let name = response.contact?.user.name
        let contact = ListContacts.FetchContacts.ViewModel.DisplayedContact(name: name!, isOnline: false)
        
        displayedContacts.append(contact)
        displayContacts()
    }
    
    private func displayContacts() {
        let viewModel = ListContacts.FetchContacts.ViewModel(displayedContacts: displayedContacts)
        viewController?.displayFetchedContacts(viewModel: viewModel)
    }
}
