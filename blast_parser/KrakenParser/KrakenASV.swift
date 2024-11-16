//
//  KrakenASV.swift
//  blast_parser
//
//  Created by João Varela on 27/10/2024.
//

import Foundation

struct KrakenASV: CustomStringConvertible {
    let sequenceID:String
    let length:Int
    var assignedReads = 0
    let taxonomy:KrakenASVTaxonomy
    
    var description:String {
        return """
                    \(sequenceID)\t\
                    \(length)\t\
                    \(assignedReads)\t\
                    \(taxonomy.taxID)\t\
                    \(taxonomy.taxon)
               """
    }
}

extension KrakenASV: Equatable {
    static func == (lhs:KrakenASV, rhs:KrakenASV) -> Bool {
        if lhs.length == rhs.length {
            return lhs.sequenceID == rhs.sequenceID
        }
        return false
    }
    
    static func != (lhs:KrakenASV, rhs:KrakenASV) -> Bool {
        if lhs.length != rhs.length {
            return true
        }
        return lhs.sequenceID != rhs.sequenceID
    }
}

extension KrakenASV: Comparable {
    static func > (lhs:KrakenASV, rhs:KrakenASV) -> Bool {
        return lhs.length > rhs.length
    }
    
    static func < (lhs:KrakenASV, rhs:KrakenASV) -> Bool {
        return lhs.length < rhs.length
    }
}
