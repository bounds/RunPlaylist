//
//  PlaylistListView.swift
//  RunPlaylist
//
//  Created by Dave Henke on 2/17/20.
//  Copyright © 2020 Dave Henke. All rights reserved.
//

import SwiftUI
import Combine

struct PlaylistListView: View {
    @Binding var playlists: [Playlist]
    
    var body: some View {
        NavigationView {
            VStack {
                List(playlists) { playlist in
                    NavigationLink(destination: PlayerView(playlist: playlist)) {
                        Text(playlist.title)
                    }
                }
            }.navigationBarTitle("Select Playlist")
        }
    }
}

struct PlaylistListView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistListView(playlists: .constant([]))
    }
}
