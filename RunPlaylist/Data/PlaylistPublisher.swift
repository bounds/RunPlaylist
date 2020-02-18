//
//  PlaylistPublisher.swift
//  RunPlaylist
//
//  Created by Dave Henke on 2/17/20.
//  Copyright © 2020 Dave Henke. All rights reserved.
//

import Foundation
import Combine

class PlaylistPublisher: Publisher {
    typealias Output = [Playlist]
    typealias Failure = Never
    
    init() { }
    
    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        let subscription = PlaylistSubscription(subscriber)
        subscriber.receive(subscription: subscription)
    }
}
