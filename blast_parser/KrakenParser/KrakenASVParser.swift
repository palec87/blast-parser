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
    
    func parse() {
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
    }
    
    func print(sequencesPerBin:Int = 10) {
        
    }
}

