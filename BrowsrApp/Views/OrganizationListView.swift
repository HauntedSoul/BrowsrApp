//
//  OrganizationListView.swift
//  BrowsrApp
//
//  Created by Vitor Dinis on 24/10/2022.
//

import SwiftUI
import BrowsrLib

struct OrganizationListView: View {
    
    @StateObject var viewModel = OrganizationsListViewModel()
    
    @State var searching = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    if searching {
                        TextField("", text: $viewModel.searchText)
                            .font(.system(size: 22))
                            .foregroundColor(.black)
                            .padding(4)
                            .background(
                                Color.black.opacity(0.2)
                            )
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("Organizations")
                            .font(.system(size: 26))
                            .bold()
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .foregroundColor(.blue)
                        .frame(width: 30, height: 30)
                        .onTapGesture {
                            searching.toggle()
                            if !searching {
                                viewModel.refreshOrganizationsList()
                            }
                        }
                }
                .padding()
                
                if viewModel.isLoading {
                    VStack {
                        Spacer()
                        ProgressView()
                            .tint(.blue)
                            .scaleEffect(3)
                        Spacer()
                    }
                } else {
                    if viewModel.organizationsList.isEmpty {
                        VStack {
                            Spacer()
                            Button("Refresh") {
                                viewModel.refreshOrganizationsList()
                            }
                            .font(.system(size: 28))
                            .bold()
                            Spacer()
                        }
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 0) {
                                ForEach(viewModel.organizationsList, id: \.self.id) { organization in
                                    OrganizationCellView(organization: organization, isFavourite: organization.isFavourite())
                                        .onAppear {
                                            viewModel.onCellAppear(id: organization.id)
                                        }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 32)
                        }
                        .frame(maxHeight: .infinity)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .onAppear {
            viewModel.organizationsListOnAppear()
        }
        .background {
            Color.white
                .ignoresSafeArea()
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

struct OrganizationListView_Previews: PreviewProvider {
    static var previews: some View {
        OrganizationListView()
    }
}

struct OrganizationCellView: View {
    let organization: Organization
    
    @State var isFavourite: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            AsyncImage(url: URL(string: organization.avatarURL)) { image in
                image
                    .resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 60, height: 60)

            VStack(alignment: .leading) {
                Text(organization.login.capitalized)
                    .foregroundColor(.black)
                    .bold()
                
                Spacer()
                
                Text(organization.organizationDescription ?? "")
                    .foregroundColor(.black)
            }
            .padding(.horizontal)
            
            Spacer()
            
            Image(systemName: isFavourite ? "star.circle" : "star")
                .resizable()
                .foregroundColor(.yellow)
                .frame(width: 30, height: 30)
                .onTapGesture {
                    if organization.isFavourite() {
                        organization.removeFromFavourites()
                    } else {
                        organization.addToFavourites()
                    }
                    isFavourite.toggle()
                }
        }
        .padding(.vertical)
        
        SeparatorView()
    }
}
