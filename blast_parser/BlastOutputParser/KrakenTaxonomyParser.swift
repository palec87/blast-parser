//
//  KrakenTaxonomyParser.swift
//  blast_parser
//
//  Created by João Varela on 16/11/2024.
//

import Foundation

struct KrakenTaxonomyLine {
    let assignedReads: Int
    let name: String
    let taxonomy: String
}

final class KrakenTaxonomyParser: FileParser {
    var lines = [KrakenTaxonomyLine]()
    /// Parses the output file of the parse subcommand to retrieve
    /// the hierarchical taxonomic classification produced by Kraken2
    func parse() throws {
        for line in readStream {
            let items = line.components(separatedBy: "\t")
            guard items.count == 8 else {
                throw RuntimeError("ERROR: Invalid Kraken taxonomy file")
            }
            
            let reads = Int(items[3].trimmingCharacters(in: .whitespaces)) ?? 0
            let name = items[6].trimmingCharacters(in: .whitespaces)
            let taxonomy = items[7].trimmingCharacters(in: .whitespacesAndNewlines)
            let taxonomyLine = KrakenTaxonomyLine(assignedReads: reads,
                                                  name: name,
                                                  taxonomy: taxonomy)
            lines.append(taxonomyLine)
        }
    }
    
    func getTaxonomy(for asv:KrakenASV) -> String? {
        for line in lines {
            if asv.assignedReads == line.assignedReads
                && asv.taxonomy.taxon == line.name {
                return line.taxonomy
            }
        }
        return nil
    }
}
