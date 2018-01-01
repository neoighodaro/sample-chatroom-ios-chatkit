//
//  ChatroomInteractor.swift
//  words
//
//  Created by Neo Ighodaro on 09/12/2017.
//  Copyright (c) 2017 CreativityKills Co.. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import Foundation
import PusherChatkit

protocol ChatroomBusinessLogic: PCRoomDelegate {
    var currentUser: PCCurrentUser? { get set }

    func subscribeToRoom(room: PCRoom)
    func addChatMessage(request: Chatroom.Messages.Create.Request, completionHandler: @escaping (Int?, ChatroomError?) -> Void)
}

protocol ChatroomDataStore {
    var contact: Contact? { get set }
}

enum ChatroomError: Error {
    case CannotAdd(String)
}

class ChatroomInteractor: ChatroomBusinessLogic, ChatroomDataStore {
    
    var contact: Contact?
    var currentUser: PCCurrentUser?
    var presenter: ChatroomPresentationLogic?
    
    var messages: [PCMessage] = []
    
    var worker = MessagesWorker(messagesStore: MessagesAPI())
  
    // MARK: Fetch Messages
    
    func subscribeToRoom(room: PCRoom) {
        currentUser?.subscribeToRoom(room: room, roomDelegate: self)
    }
    
    func newMessage(message: PCMessage) {
        DispatchQueue.main.async {
            self.messages.append(message)
            let response = Chatroom.Messages.Fetch.Response(messages: self.messages)
            self.presenter?.presentMessages(response: response)
        }
    }
    
    func userStartedTyping(user: PCUser) {
        
    }

    func userStoppedTyping(user: PCUser) {
        
    }
    
    func addChatMessage(request: Chatroom.Messages.Create.Request, completionHandler: @escaping (Int?, ChatroomError?) -> Void) {
        currentUser?.addMessage(text: request.text, to: request.room) { (messageId, error) in
            guard error == nil else {
                return completionHandler(nil, ChatroomError.CannotAdd((error?.localizedDescription)!))
            }

            DispatchQueue.main.async {
                completionHandler(messageId, nil)
            }
        }
    }
}
