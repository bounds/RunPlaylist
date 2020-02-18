//
//  PlaylistSubscription.swift
//  RunPlaylist
//
//  Created by Dave Henke on 2/17/20.
//  Copyright © 2020 Dave Henke. All rights reserved.
//

import Combine
import Foundation
import MediaPlayer

class PlaylistSubscription<S: Subscriber>: Subscription where S.Input == PlaylistPublisher.Output, S.Failure == PlaylistPublisher.Failure {
    private var subscriber: S?
    
    init(_ subscriber: S) {
        self.subscriber = subscriber
    }
    
    func request(_ demand: Subscribers.Demand) {
        DispatchQueue.global(qos: .userInitiated).async {
            let collections = MPMediaQuery.playlists().collections
            let playlists: [Playlist] = collections.map { collections in
                return collections.compactMap { collection in
                    guard let playlist = collection as? MPMediaPlaylist else { return nil }
                    guard let title = playlist.name else { return nil }
                    return Playlist(id: playlist.persistentID, title: title)
                }
                } ?? []
            
            let sorted = playlists.sorted(by: { (first, second) -> Bool in
                return first.title < second.title
            })
            
            DispatchQueue.main.async { [weak self] in
                _ = self?.subscriber?.receive(sorted)
                self?.subscriber?.receive(completion: .finished)
            }
        }
    }
    
    func cancel() {
        self.subscriber = nil
    }
}
