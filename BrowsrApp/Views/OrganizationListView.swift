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
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Organizations")
                .font(.system(size: 26))
                .bold()
                .foregroundColor(.black)
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
                        VStack(spacing: 0) {
                            ForEach(viewModel.organizationsList, id: \.self.id) { organization in
                                OrganizationCellView(organization: organization)
                                    .onAppear {
                                        // This is triggering too many times in preview
//                                        viewModel.onCellAppear(id: organization.id)
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
        .onAppear {
            viewModel.organizationsListOnAppear()
        }
        .frame(maxWidth: .infinity)
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
    
    @State var favouriteChanged = false
    
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
            
            Image(systemName: organization.isFavourite() ? "star.circle" : "star")
                .resizable()
                .foregroundColor(.yellow)
                .frame(width: 30, height: 30)
                .onTapGesture {
                    if organization.isFavourite() {
                        organization.removeFromFavourites()
                    } else {
                        organization.addToFavourites()
                    }
                    favouriteChanged.toggle()
                }
        }
        .padding(.vertical)
        
        SeparatorView()
    }
}
