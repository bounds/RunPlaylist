//
//  ContentView.swift
//  RunPlaylist
//
//  Created by Dave Henke on 2/17/20.
//  Copyright © 2020 Dave Henke. All rights reserved.
//

import SwiftUI

struct AuthorizationView: View {
    @EnvironmentObject private var mediaLibrary: MediaLibrary
    
    @State var playlists: [Playlist] = []
    
    var body: some View {
        containedView()
    }
    
    func containedView() -> AnyView {
        switch mediaLibrary.authorizationStatus {
        case .notDetermined:
            return AnyView(RequestAuthorizationView())
        case .authorized:
            return AnyView(
                PlaylistListView(playlists: $playlists)
                    .onReceive(mediaLibrary.playlistPublisher) { playlists in
                        self.playlists = playlists
                }
            )
        case .denied:
            return AnyView(Text("Access Denied"))
        case .restricted:
            return AnyView(Text("Access Restricted"))
        @unknown default:
            return AnyView(Text("Very much unknown state"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AuthorizationView()
    }
}
