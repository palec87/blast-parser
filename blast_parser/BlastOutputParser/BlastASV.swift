//
//  BlastASV.swift
//  blast_parser
//
//  Created by João Varela on 17/11/2024.
//

import Foundation

enum BlastASVError: Error {
    case invalidLineage
}

struct BlastASV: CustomStringConvertible {
    let asv:KrakenASV
    let hit:BlastHit
    let krakenTaxonomy:String?
    var blastTaxonomy = Hierarchy()
    
    init(asv: KrakenASV, taxonomy: String?, hit: BlastHit) {
        self.asv = asv
        self.krakenTaxonomy = taxonomy
        self.hit = hit
    }
    
    mutating func setBlastTaxonomy(database:SQLDatabase) {
        let taxID = self.hit.taxID
        do {
            if let lineage = NCBILineage(database: database, taxID: taxID) {
                blastTaxonomy = Hierarchy(rank: try .rank(abbreviation: "D",
                                                          name: lineage.superkingdom))
                let phylum = try Rank.rank(abbreviation: "P",
                                           name: lineage.phylum)
                blastTaxonomy.addRank(phylum)
                let `class` = try Rank.rank(abbreviation: "C",
                                            name: lineage.class)
                blastTaxonomy.addRank(`class`)
                let order = try Rank.rank(abbreviation: "O",
                                          name: lineage.order)
                blastTaxonomy.addRank(order)
                let family = try Rank.rank(abbreviation: "F",
                                           name: lineage.family)
                blastTaxonomy.addRank(family)
                let genus = try Rank.rank(abbreviation: "G",
                                          name: lineage.genus)
                blastTaxonomy.addRank(genus)
                
                let name = lineage.species.isEmpty ? hit.scientificName : lineage.species
                let species = try Rank.rank(abbreviation: "S",
                                            name: name)
                blastTaxonomy.addRank(species)
            } else if taxID != 0 {
                // if taxID == 0 then blastTaxonomy is already inited
                // with an "Unclassified" Rank, so we do nothing, but
                // otherwise any other taxID is an error.
                throw BlastASVError.invalidLineage
            }
        }
        
        catch {
            Console.writeToStdErr("ERROR: Invalid taxonomy for tax_id = \(taxID)")
        }
    }
    
    var description:String {
        let blastRanks = blastTaxonomy.getRanks()
        if blastRanks.isEmpty == false,
            let krakenTaxonomy = self.krakenTaxonomy {
            return "\(asv)\t\(krakenTaxonomy)\t\(hit)\t\(blastRanks)"
        } else if let krakenTaxonomy = self.krakenTaxonomy {
            return "\(asv)\t\(krakenTaxonomy)\t\(hit)"
        } else if blastRanks.isEmpty == false {
            return "\(asv)\t\(hit)\t\(blastRanks)"
        } else {
            return "\(asv)\t\(hit)"
        }
    }
}
