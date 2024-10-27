//
//  KrakenASVBin.swift
//  blast_parser
//
//  Created by João Varela on 27/10/2024.
//

import Foundation

struct KrakenASV {
    let sequenceID:String
    let sequenceSize:Int
    let taxonomy:KrakenASVTaxonomy
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

struct KrakenASVTaxonomy {
    let taxon:String
    let taxID:Int
    
    init() {
        self.taxon = "Unclassified"
        self.taxID = 0
    }
    
    init?(classification:String) {
        let items = classification.components(separatedBy: "(")
        guard items.count == 2 else { return nil }
        self.taxon = items[0].trimmingCharacters(in: .whitespaces)
        let taxID = items[1].trimmingCharacters(in: .decimalDigits.inverted)
        guard let taxID = Int(taxID) else { return nil }
        self.taxID = taxID
    }
}

extension KrakenASVTaxonomy: Equatable {
    static func == (lhs:KrakenASVTaxonomy, rhs:KrakenASVTaxonomy) -> Bool {
        return lhs.taxID == rhs.taxID
    }
    
    static func != (lhs:KrakenASVTaxonomy, rhs:KrakenASVTaxonomy) -> Bool {
        return lhs.taxID != rhs.taxID
    }
}

struct KrakenASVBin {
    let isClassified:Bool
    let taxonomy:KrakenASVTaxonomy
    private var asvs = [KrakenASV]()
    
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
}

extension KrakenASVBin: Equatable {
    static func == (lhs:KrakenASVBin, rhs:KrakenASVBin) -> Bool {
        return lhs.taxonomy == rhs.taxonomy
    }
    
    static func != (lhs:KrakenASVBin, rhs:KrakenASVBin) -> Bool {
        return lhs.taxonomy != rhs.taxonomy
    }
}
