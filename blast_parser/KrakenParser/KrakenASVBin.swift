//
//  KrakenASVBin.swift
//  blast_parser
//
//  Created by João Varela on 27/10/2024.
//

import Foundation

struct KrakenASVBin {
    let isClassified:Bool
    let taxonomy:KrakenASVTaxonomy
    private var asvs = [KrakenASV]()
    
    var count:Int {
        return asvs.count
    }
    
    init(isClassified: Bool, taxonomy:KrakenASVTaxonomy) {
        self.isClassified = isClassified
        if isClassified {
            self.taxonomy = taxonomy
        } else {
            self.taxonomy = KrakenASVTaxonomy()
        }
    }
    
    mutating func append(asv:KrakenASV) {
        asvs.append(asv)
    }
    
    mutating func asvs(sequencesToReturn:Int = 10) -> [KrakenASV] {
        // sort asvs by descending sequence size
        asvs.sort(by: >)
        // return the first sequencesToReturn
        return Array(asvs.prefix(sequencesToReturn))
    }
}

extension KrakenASVBin: Equatable {
    static func == (lhs:KrakenASVBin, rhs:KrakenASVBin) -> Bool {
        return lhs.taxonomy == rhs.taxonomy
    }
    
    static func != (lhs:KrakenASVBin, rhs:KrakenASVBin) -> Bool {
        return lhs.taxonomy != rhs.taxonomy
    }
}


