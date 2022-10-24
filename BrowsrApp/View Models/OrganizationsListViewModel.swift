//
//  OrganizationsListViewModel.swift
//  BrowsrApp
//
//  Created by Vitor Dinis on 24/10/2022.
//

import Foundation
import BrowsrLib
import Combine

class OrganizationsListViewModel: ObservableObject {
    
    @Published var organizationsList: [Organization] = []
    
    @Published var isLoading = false
    
    private var cancellables: Set<AnyCancellable> = []
    private var allLoaded = false
    
    
    // MARK: View Lifecycle
    
    func organizationsListOnAppear() {
        if organizationsList.isEmpty {
            fetchOrganizations()
        }
    }
    
    func refreshOrganizationsList() {
        fetchOrganizations()
    }
    
    func onCellAppear(id: Int64) {
        if allLoaded || isLoading { return }
        
        if id == organizationsList.last?.id {
            // Call for next page until we got them all
            fetchOrganizations(since: id)
        }
    }
    
    
    // MARK: Data handling
    
    private func fetchOrganizations() {
        isLoading = true
        
        BrowsrLib.getOrganizations()
            .sink { result in
                switch result {
                case .failure(let resultError):
                    print("ERROR: \(resultError.localizedDescription)")
                case .finished:
                    break
                }
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            } receiveValue: { value in
                DispatchQueue.main.async {
                    self.organizationsList = value
                }
            }
            .store(in: &cancellables)
    }
    
    private func fetchOrganizations(since: Int64) {
//        isLoading = true
        
        BrowsrLib.getOrganizations(since: since)
            .sink { result in
                switch result {
                case .failure(let resultError):
                    print("ERROR: \(resultError.localizedDescription)")
                case .finished:
                    break
                }
//                self.isLoading = false
            } receiveValue: { value in
                DispatchQueue.main.async {
                    self.organizationsList.append(contentsOf: value)
                }
            }
            .store(in: &cancellables)
    }
}
