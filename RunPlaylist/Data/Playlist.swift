//
//  Playlist.swift
//  RunPlaylist
//
//  Created by Dave Henke on 2/17/20.
//  Copyright © 2020 Dave Henke. All rights reserved.
//

import Foundation

struct Playlist {
    var id: UInt64
    var title: String
}

extension Playlist: Identifiable { }
