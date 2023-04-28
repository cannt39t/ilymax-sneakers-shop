//
//  NewConversationPresenter.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 17.04.2023.
//

import Foundation

class NewConversationPresenter {
    
    weak var view: NewConversationViewController?
    let newConversationService: NewConversationService = NewConversationService()
    
    var startNewConversation: (IlymaxUser) -> Void = {_ in }
    var openExistingConversation: (Conversation) -> Void = { _ in }
    var openExistingDeletedConversation: (IlymaxUser, String) -> Void = { (_, _) in }
    var dismissSearchController: () -> () = {}
    
    private var users: [IlymaxUser] = []
    public var existingConversations: [Conversation] = []
    private var hasFetch = false
    
    func searchUsers(query: String) {
        view?.results.removeAll(keepingCapacity: false)
        if hasFetch {
            filterUsers(with: query)
        } else {
            newConversationService.getUsers { [weak self] users in
                self?.users = users
                self?.hasFetch = true
                self?.filterUsers(with: query)
            }
        }
    } 
    
    func filterUsers(with term: String) {
        guard hasFetch else {
            return
        }
        
        let results: [IlymaxUser] = users.filter({
            let name = $0.name.lowercased()
            return name.hasPrefix(term.lowercased())
        })
        
        
        updateUI(results)
    }
    
    private func updateUI(_ results: [IlymaxUser]) {
        view?.spinner.dismiss()
        view?.results = results
        if results.isEmpty {
            view?.tableView.isHidden = true
            view?.noResultsLabel.isHidden = false
        } else {
            view?.tableView.isHidden = false
            view?.noResultsLabel.isHidden = true
            view?.tableView.reloadData()
        }
    }
    
    public func startConversation(with targetUser: IlymaxUser) {
        dismissSearchController()
        if let targetConveration = existingConversations.first(where: {
            $0.otherUserEmail == targetUser.emailAddress
        }) {
            openExistingConversation(targetConveration)
        } else {
            newConversationService.getConversationForUser(with: targetUser.emailAddress) { [weak self] result in
                switch result {
                    case .failure(_):
                        DispatchQueue.main.async {
                            self?.startNewConversation(targetUser)
                        }
                    case .success(let conversationId):
                        DispatchQueue.main.async {
                            self?.openExistingDeletedConversation(targetUser, conversationId)
                        }
                }
            }
        }
    }
    
}
