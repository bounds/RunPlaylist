//
//  Song.swift
//  RunPlaylist
//
//  Created by Dave Henke on 2/17/20.
//  Copyright © 2020 Dave Henke. All rights reserved.
//

import Foundation

struct Song {
    let id: UInt64
    let artist: String
    let title: String
    let storeId: String
}

extension Song: Identifiable {
    
}
