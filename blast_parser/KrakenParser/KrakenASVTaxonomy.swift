//
//  KrakenASVTaxonomy.swift
//  blast_parser
//
//  Created by João Varela on 27/10/2024.
//

import Foundation

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
