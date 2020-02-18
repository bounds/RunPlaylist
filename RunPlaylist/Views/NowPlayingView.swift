//
//  NowPlayingView.swift
//  RunPlaylist
//
//  Created by Dave Henke on 2/17/20.
//  Copyright © 2020 Dave Henke. All rights reserved.
//

import SwiftUI

struct NowPlayingView: View {
    @EnvironmentObject private var mediaLibrary: MediaLibrary
    
    var playlist: Playlist
    
    var body: some View {
        VStack {
            if mediaLibrary.artwork != nil {
                Image(uiImage: mediaLibrary.artwork!)
                    .resizable()
                    .aspectRatio(1, contentMode: ContentMode.fit)
                    .shadow(radius: 5.0, x: 2, y: 2)
                    .padding([.leading, .trailing, .bottom], 24.0)
            }
            
            VStack {
                Text(mediaLibrary.nowPlaying?.title ?? "")
                    .font(.body)
                    .multilineTextAlignment(.center)
                Text(mediaLibrary.nowPlaying?.artist ?? "")
                    .font(.headline)
                    .multilineTextAlignment(.center)
            }
            
            if mediaLibrary.nowPlaying != nil {
                Spacer()
                Button(action: {
                    self.addSong()
                }) {
                    Image(systemName: "plus.rectangle.fill")
                        .resizable()
                        .frame(width: 60, height: 60, alignment: .center)
                }
                .buttonStyle(AnimatedButtonStyle())
            }
            
            Spacer()
            HStack(spacing: 16.0) {
                Button(action: { self.mediaLibrary.back() }) {
                    Image(systemName: "backward.fill")
                        .resizable()
                        .frame(width: 45, height: 40, alignment: .center)
                        .padding()
                        .disabled(mediaLibrary.nowPlaying == nil)
                }
                Button(action: { self.mediaLibrary.stop() }) {
                    Image(systemName: "stop.fill")
                        .resizable()
                        .frame(width: 45, height: 45, alignment: .center)
                        .padding()
                        .disabled(mediaLibrary.nowPlaying == nil)
                }
                Button(action: { self.mediaLibrary.skip() }) {
                    Image(systemName: "forward.fill")
                        .resizable()
                        .frame(width: 45, height: 40, alignment: .center)
                        .padding()
                        .disabled(mediaLibrary.nowPlaying == nil)
                }
            }
        }
    }
    
    private func addSong() {
        guard let song = self.mediaLibrary.nowPlaying else {
            return
        }
        
        self.mediaLibrary.addSong(id: song.storeId, to: self.playlist)
    }
}

struct NowPlayingView_Previews: PreviewProvider {
    static var previews: some View {
        NowPlayingView(playlist: Playlist(id: 1234, title: "Test playlist"))
    }
}

struct AnimatedButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.7 : 1.0)
            .foregroundColor(Color(.systemBlue))
    }
}
