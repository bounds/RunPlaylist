//
//  NowPlayingView.swift
//  RunPlaylist
//
//  Created by Dave Henke on 2/17/20.
//  Copyright © 2020 Dave Henke. All rights reserved.
//

import SwiftUI

struct PlayerView: View {
    @EnvironmentObject private var mediaLibrary: MediaLibrary
    
    var playlist: Playlist
    
    var body: some View {
        VStack(spacing: 8.0) {
            Text("Adding to \(playlist.title)")
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .padding([.leading, .trailing])
            
            Button(action: {
                self.mediaLibrary.shufflePlay()
            }) {
                HStack {
                    Image(systemName: "shuffle")
                    Text("Shuffle Library")
                        .font(.callout)
                }
            }
            Spacer()
            if mediaLibrary.isPlaying {
                NowPlayingView(playlist: playlist).padding()
            }
        }
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(playlist: Playlist(id: 1234, title: "Test Playlist"))
    }
}
