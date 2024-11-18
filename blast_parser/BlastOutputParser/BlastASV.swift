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
    var blastTaxonomy:Hierarchy? = nil
    
    init(asv: KrakenASV, taxonomy: String?, hit: BlastHit) {
        self.asv = asv
        self.krakenTaxonomy = taxonomy
        self.hit = hit
    }
    
    mutating func setBlastTaxonomy(database:SQLDatabase) {
        let taxID = self.asv.taxonomy.taxID
        do {
            if let lineage = NCBILineage(database: database, taxID: taxID) {
                blastTaxonomy = Hierarchy()
                let kingdom = try Rank.rank(abbreviation: "D",
                                            name: lineage.superkingdom)
                blastTaxonomy!.addRank(kingdom)
                let phylum = try Rank.rank(abbreviation: "P",
                                           name: lineage.phylum)
                blastTaxonomy!.addRank(phylum)
                let `class` = try Rank.rank(abbreviation: "C",
                                            name: lineage.class)
                blastTaxonomy!.addRank(`class`)
                let order = try Rank.rank(abbreviation: "O",
                                          name: lineage.order)
                blastTaxonomy!.addRank(order)
                let family = try Rank.rank(abbreviation: "F",
                                           name: lineage.family)
                blastTaxonomy!.addRank(family)
                let genus = try Rank.rank(abbreviation: "G",
                                          name: lineage.genus)
                blastTaxonomy!.addRank(genus)
                let species = try Rank.rank(abbreviation: "S",
                                            name: lineage.species)
                blastTaxonomy!.addRank(species)
            }
        }
        
        catch {
            Console.writeToStdErr("ERROR: Invalid taxonomy for tax_id = \(taxID)")
            blastTaxonomy = nil
        }
    }
    
    var description:String {
        if let blastTaxonomy = self.blastTaxonomy?.getRanks(),
            let krakenTaxonomy = self.krakenTaxonomy {
            return "\(asv)\t\(krakenTaxonomy)\t\(hit)\t\(blastTaxonomy)"
        } else if let krakenTaxonomy = self.krakenTaxonomy {
            return "\(asv)\t\(krakenTaxonomy)\t\(hit)"
        } else if let blastTaxonomy = self.blastTaxonomy?.getRanks() {
            return "\(asv)\t\(hit)\t\(blastTaxonomy)"
        } else {
            return "\(asv)\t\(hit)"
        }
    }
}
