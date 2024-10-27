//
//  KrakenASVParser.swift
//  blast_parser
//
//  Created by João Varela on 27/10/2024.
//

import Foundation

struct KrakenASVBinArray {
    private var bins = [KrakenASVBin]()
    
    func append(asv:KrakenASV) {
        if var bin = match(asv: asv) {
            bin.append(asv: asv)
        } else {
            let isClassified = asv.taxonomy.taxID != 0
            var bin = KrakenASVBin(isClassified: isClassified,
                                   taxonomy: asv.taxonomy)
            bin.append(asv: asv)
        }
    }
    
    private func match(asv:KrakenASV) -> KrakenASVBin? {
        for bin in bins {
            if asv.taxonomy == bin.taxonomy {
                return bin
            }
        }
        return nil
    }
}

enum KrakenASVError: Error {
    case invalidTaxonomy
}

class KrakenASVParser {
    let path:String
    let readStream:DataStreamReader
    var binArray = KrakenASVBinArray()
    
    init?(path: String) {
        do {
            self.path = path
            let url = URL(fileURLWithPath: path)
            self.readStream = try DataStreamReader(url: url)
        }
        
        catch {
            Console.writeToStdErr("Unable to read the classification file at \(path)")
            return nil
        }
    }
    
    func parse() -> Bool {
        var i = 1
        for line in readStream {
            do {
                let items = line.components(separatedBy: "\t")
                guard items.count == 5 else { continue }
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
        return true
    }
}

