//
//  MatchedTaxID.swift
//  blast_parser
//
//  Created by João Varela on 27/08/2024.
//

import Foundation

struct MatchedTaxID {
    let taxID:String
    let taxonomy:String
    
    init(taxID: String, taxonomy: String) {
        self.taxID = taxID
        self.taxonomy = taxonomy
    }
}
