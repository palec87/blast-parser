//
//  BlastASV.swift
//  blast_parser
//
//  Created by João Varela on 03/11/2024.
//

import Foundation

struct BlastHit {
    let querySequenceID:String
    let subjectSequenceID:String
    let percentageIdentity:Double
    let alignmentLength:Int
    let eValue:Double
    let bitscore:Int
    let taxID:Int
    let scientificName:String
    let kingdom:String
}

struct BlastASV {
    let asv:KrakenASV
    let hit:BlastHit
}


