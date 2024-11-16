//
//  KrakenASVParser.swift
//  blast_parser
//
//  Created by João Varela on 27/10/2024.
//

import Foundation

enum KrakenASVError: Error {
    case invalidTaxonomy
}

final class KrakenASVParser: FileParser {
    var binArray = KrakenASVBinArray()
    
    func parse() {
        var i = 1
        for line in readStream {
            do {
                let items = line.components(separatedBy: "\t")
                guard items.count == 5 else { throw KrakenASVError.invalidTaxonomy }
                guard let taxonomy = KrakenASVTaxonomy(classification: items[2])
                    else { throw KrakenASVError.invalidTaxonomy }
                let size = Int(items[3].trimmingCharacters(in: .whitespaces)) ?? 0
                let asv = KrakenASV(sequenceID: items[1],
                                    sequenceSize: size,
                                    taxonomy: taxonomy)
                binArray.append(asv: asv)
            }
            
            catch {
                Console.writeToStdErr("ERROR: Invalid taxon at line \(i) in the classification file")
            }
            i += 1
        }
        
        binArray.sort()
    }
}

