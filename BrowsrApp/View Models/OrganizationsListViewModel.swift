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
    
    @Published var searchText: String = "" {
        didSet {
            startSearching()
        }
    }
    
    private var searchTimer: Timer? = nil
    private var cancellables: Set<AnyCancellable> = []
    private var searchCancellable: AnyCancellable?
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
            fetchOrganizations(since: id)
        }
    }
    
    
    // MARK: Search
    
    private func startSearching() {
        isLoading = true
        
        searchTimer?.invalidate()
        
        if searchText.isEmpty {
            isLoading = false
            return
        }
        
        searchTimer = Timer.scheduledTimer(withTimeInterval: 2.0,
                                           repeats: false,
                                           block: { timer in
            self.searchOrganizations()
        })
    }
    
    
    // MARK: Data handling
    
    private func fetchOrganizations() {
        isLoading = true
        allLoaded = false
        
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
        
        BrowsrLib.getOrganizations(since: since)
            .sink { result in
                switch result {
                case .failure(let resultError):
                    print("ERROR: \(resultError.localizedDescription)")
                    self.allLoaded = true
                case .finished:
                    break
                }
            } receiveValue: { value in
                DispatchQueue.main.async {
                    self.organizationsList.append(contentsOf: value)
                }
            }
            .store(in: &cancellables)
    }
    
    private func searchOrganizations() {
        searchCancellable?.cancel()
        
        allLoaded = true
        searchCancellable = BrowsrLib.searchOrganizations(search: searchText)
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
    }
}
