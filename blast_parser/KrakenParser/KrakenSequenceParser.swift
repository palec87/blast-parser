//
//  KrakenSequenceParser.swift
//  blast_parser
//
//  Created by João Varela on 01/11/2024.
//

import Foundation

struct KrakenSequence {
    let sequenceID:String
    let sequence:String
}

class KrakenSequenceParser {
    let path:String
    let readStream:DataStreamReader
    var asvs:[KrakenASV]!
    var sequences = [KrakenSequence]()
    
    init?(path:String) {
        do {
            self.path = path
            let url = URL(fileURLWithPath: path)
            self.readStream = try DataStreamReader(url: url)
        }
        
        catch {
            Console.writeToStdErr("Unable to read the sequences file at \(path)")
            return nil
        }
    }
    
    func parse() {
        var sequenceID = String()
        var sequence = String()
        for line in readStream {
            if line.firstIndex(of: ">") != nil {
                sequenceID = line.replacingOccurrences(of: ">", with: "")
                sequenceID = sequenceID.trimmingCharacters(in: .whitespacesAndNewlines)
            } else {
                guard match(sequenceID: sequenceID) else { continue }
                sequence = line.trimmingCharacters(in: .newlines)
                let sequenceObj = KrakenSequence(sequenceID: sequenceID,
                                                 sequence: sequence)
                sequences.append(sequenceObj)
                guard asvs.count > 0 else { break }
            }
        }
    }
    
    private func match(sequenceID:String) -> Bool {
        var found = false
        for asv in asvs {
            if asv.sequenceID == sequenceID {
                found = true; break
            }
        }
        
        // prevent the addition of duplicates, making also the search faster
        if found {
            asvs.removeAll(where: {$0.sequenceID == sequenceID})
        }
        return found
    }
}
