//
//  MediaLibrary.swift
//  RunPlaylist
//
//  Created by Dave Henke on 2/17/20.
//  Copyright © 2020 Dave Henke. All rights reserved.
//

import Foundation
import Combine
import MediaPlayer

class MediaLibrary: ObservableObject {
    @Published var authorizationStatus: MPMediaLibraryAuthorizationStatus = MPMediaLibrary.authorizationStatus()
    @Published var nowPlaying: Song?
    @Published var isPlaying: Bool = false
    @Published var artwork: UIImage?
    
    let playlistPublisher = PlaylistPublisher()
    
    private var subscriptions: Set<AnyCancellable> = []
    
    init() {
        initializePlayer()
    }
    
    func requestAuthorization() {
        MPMediaLibrary.requestAuthorization { (status) in
            DispatchQueue.main.async {
                self.authorizationStatus = status
                if status == .authorized {
                    self.initializePlayer()
                }
            }
        }
    }
    
    func play() {
        MPMusicPlayerController.systemMusicPlayer.play()
    }
    
    func shufflePlay() {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let shuffledSongs = MPMediaQuery.songs().items?.shuffled() else {
                return
            }
            let collection = MPMediaItemCollection(items: shuffledSongs)
            MPMusicPlayerController.systemMusicPlayer.setQueue(with: collection)
            self.play()
        }
    }
    
    func stop() {
        MPMusicPlayerController.systemMusicPlayer.pause()
    }
    
    func skip() {
        MPMusicPlayerController.systemMusicPlayer.skipToNextItem()
    }
    
    func back() {
        MPMusicPlayerController.systemMusicPlayer.skipToPreviousItem()
    }
    
    func addSong(id: String, to playlist: Playlist, completion: @escaping (Bool) -> () = { _ in }) {
        DispatchQueue.global(qos: .userInitiated).async {
            let query = MPMediaQuery.playlists()
            query.addFilterPredicate(MPMediaPropertyPredicate(value: playlist.id, forProperty: MPMediaPlaylistPropertyPersistentID))
            guard let playlist = query.collections?.first as? MPMediaPlaylist else {
                completion(false)
                return
            }
            playlist.addItem(withProductID: id) { (error) in
                guard error == nil else {
                    print(error?.localizedDescription ?? "")
                    completion(false)
                    return
                }
                completion(true)
            }
        }
    }
    
    private func initializePlayer() {
        guard authorizationStatus == .authorized else { return }
        registerForNotifications()
        getPlayStatus()
        getNowPlayingSong()
    }
    
    private func registerForNotifications() {
        NotificationCenter.default.publisher(for: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange)
            .sink(receiveValue: { _ in
                self.getNowPlayingSong()
            }).store(in: &subscriptions)
        
        NotificationCenter.default.publisher(for: NSNotification.Name.MPMusicPlayerControllerPlaybackStateDidChange)
            .sink(receiveValue: { _ in
                self.getPlayStatus()
            }).store(in: &subscriptions)
        MPMusicPlayerController.systemMusicPlayer.beginGeneratingPlaybackNotifications()
    }
    
    private func getNowPlayingSong() {
        guard let mediaItem = MPMusicPlayerController.systemMusicPlayer.nowPlayingItem,
            let title = mediaItem.title,
            let artist = mediaItem.artist
        else {
            nowPlaying = nil
            artwork = nil
            return
        }
        nowPlaying = Song(id: mediaItem.persistentID, artist: artist, title: title, storeId: mediaItem.playbackStoreID)
        artwork = mediaItem.artwork?.image(at: CGSize(width: 300.0, height: 300.0))
    }
    
    private func getPlayStatus() {
        isPlaying = (MPMusicPlayerController.systemMusicPlayer.playbackState == .playing)
    }
}

