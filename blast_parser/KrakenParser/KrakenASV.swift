//
//  KrakenASV.swift
//  blast_parser
//
//  Created by João Varela on 27/10/2024.
//

import Foundation

struct KrakenASV {
    let sequenceID:String
    let sequenceSize:Int
    let taxonomy:KrakenASVTaxonomy
    
    var description:String {
        return "\(sequenceID)\t\(sequenceSize)\t\(taxonomy.taxID)\t\(taxonomy.taxon)"
    }
}

extension KrakenASV: Equatable {
    static func == (lhs:KrakenASV, rhs:KrakenASV) -> Bool {
        if lhs.sequenceSize == rhs.sequenceSize {
            return lhs.sequenceID == rhs.sequenceID
        }
        return false
    }
    
    static func != (lhs:KrakenASV, rhs:KrakenASV) -> Bool {
        if lhs.sequenceSize != rhs.sequenceSize {
            return true
        }
        return lhs.sequenceID != rhs.sequenceID
    }
}

extension KrakenASV: Comparable {
    static func > (lhs:KrakenASV, rhs:KrakenASV) -> Bool {
        return lhs.sequenceSize > rhs.sequenceSize
    }
    
    static func < (lhs:KrakenASV, rhs:KrakenASV) -> Bool {
        return lhs.sequenceSize < rhs.sequenceSize
    }
}
