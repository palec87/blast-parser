//
//  KrakenASVBin.swift
//  blast_parser
//
//  Created by João Varela on 27/10/2024.
//

import Foundation

class KrakenASVBin {
    let isClassified:Bool
    let taxonomy:KrakenASVTaxonomy
    private var asvs = [KrakenASV]()
    private var _readCount = 0
    
    var readCount:Int {
        get {
            return _readCount
        }
        
        set {
            guard _readCount == 0 else { return }
            _readCount = newValue
            for var asv in asvs {
                asv.readCount = newValue
            }
        }
    }
    
    init(isClassified: Bool, taxonomy:KrakenASVTaxonomy) {
        self.isClassified = isClassified
        if isClassified {
            self.taxonomy = taxonomy
        } else {
            self.taxonomy = KrakenASVTaxonomy()
        }
    }
    
    func append(asv:KrakenASV) {
        asvs.append(asv)
    }
    
    func asvs(sequencesToReturn:Int = 10) -> [KrakenASV] {
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

extension KrakenASVBin: Comparable {
    static func > (lhs:KrakenASVBin, rhs:KrakenASVBin) -> Bool {
        return lhs.readCount > rhs.readCount
    }
    
    static func < (lhs:KrakenASVBin, rhs:KrakenASVBin) -> Bool {
        return lhs.readCount < rhs.readCount
    }
}


