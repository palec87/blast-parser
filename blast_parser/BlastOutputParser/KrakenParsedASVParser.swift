//
//  KrakenParsedASVParser.swift
//  blast_parser
//
//  Created by João Varela on 16/11/2024.
//

import Foundation

final class KrakenParsedASVParser: FileParser {
    /// Parses the output file of the parsed subcommand containing
    /// the sequenceIDs and their respective Kraken2 classifications
    func parse() throws -> [KrakenASV] {
        var lines = [KrakenASV]()
        for line in readStream {
            let items = line.components(separatedBy: "\t")
            guard items.count == 5 else { throw RuntimeError("Invalid Kraken2 ASV with classification file.")}
            let sequenceID = items[0].trimmingCharacters(in: .whitespaces)
            let length = Int(items[1].trimmingCharacters(in: .whitespaces)) ?? 0
            let reads = Int(items[2].trimmingCharacters(in: .whitespaces)) ?? 0
            let taxID = Int(items[3].trimmingCharacters(in: .whitespaces)) ?? 0
            let classification = items[4].trimmingCharacters(in: .whitespaces)
            let taxonomy = KrakenASVTaxonomy(taxon: classification,
                                             taxID: taxID)
            let asv = KrakenASV(sequenceID: sequenceID,
                                length: length,
                                assignedReads: reads,
                                taxonomy: taxonomy)
            lines.append(asv)
        }
        return lines
    }
}
