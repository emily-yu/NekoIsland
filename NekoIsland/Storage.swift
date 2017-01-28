//
//  Storage.swift
//  NekoIsland
//
//  Created by VC on 7/22/16.
//  Copyright © 2016 Makeschool. All rights reserved.
//

import Foundation

// Achievements Boolean Storage

// Unique
// Insta Kill: Die in less than 2 seconds
var instaKill = false
// Survivor: Survive for more than 20 seconds
var survivor = false
// Mediocre: Survive for more than 40 seconds
var mediocre = false
// Legend: Survive for more than 60 seconds
var legend = false

// Gameplay Storage
var highScore = 0 // Stores High Score Value
//var texture = "hero" // Change Texture of Hero

var highScoreString = "0:00" // Stores High Score Value as a String

// $$ NonUnique
// 1 minute bonus = +10 extra gold +6 gold for surviving that long
// 2 minute bonus = +20 extra gold +12 gold for surviving