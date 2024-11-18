//
//  BlastASV.swift
//  blast_parser
//
//  Created by João Varela on 17/11/2024.
//

import Foundation

struct BlastASV: CustomStringConvertible {
    let asv:KrakenASV
    let hit:BlastHit
    let krakenTaxonomy:String?
    var blastTaxonomy:String? = nil
    
    init(asv: KrakenASV, taxonomy: String?, hit: BlastHit) {
        self.asv = asv
        self.krakenTaxonomy = taxonomy
        self.hit = hit
    }
    
    mutating func setBlastTaxonomy(database:SQLDatabase) {
        // FIXME: Implement it with NCBILineage and then parse the result
    }
    
    var description:String {
        if let blastTaxonomy = self.blastTaxonomy,
            let krakenTaxonomy = self.krakenTaxonomy {
            return "\(asv)\t\(krakenTaxonomy)\t\(hit)\t\(blastTaxonomy)"
        } else if let krakenTaxonomy = self.krakenTaxonomy {
            return "\(asv)\t\(krakenTaxonomy)\t\(hit)"
        } else if let blastTaxonomy = self.blastTaxonomy {
            return "\(asv)\t\(hit)\t\(blastTaxonomy)"
        } else {
            return "\(asv)\t\(hit)"
        }
    }
}
