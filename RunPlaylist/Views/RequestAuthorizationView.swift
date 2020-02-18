//
//  AuthorizationView.swift
//  RunPlaylist
//
//  Created by Dave Henke on 2/17/20.
//  Copyright © 2020 Dave Henke. All rights reserved.
//

import SwiftUI

struct RequestAuthorizationView: View {
    @EnvironmentObject private var mediaLibrary: MediaLibrary
    
    var body: some View {
        VStack {
            Spacer()
            Text("Please Allow Access to Apple Music")
                .font(.title)
                .multilineTextAlignment(.center)
                .padding(16.0)
            Button(action: { self.mediaLibrary.requestAuthorization() }) {
                Text("Request Authorization")
                    .font(.headline)
            }
            Spacer()
        }
    }
}

struct AuthorizationView_Previews: PreviewProvider {
    static var previews: some View {
        RequestAuthorizationView()
    }
}
