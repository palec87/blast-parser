//
//  KrakenSequenceParser.swift
//  blast_parser
//
//  Created by João Varela on 01/11/2024.
//

import Foundation

class KrakenSequence {
    let sequenceID:String
    var sequence:String
    
    init(sequenceID: String, sequence: String = String()) {
        self.sequenceID = sequenceID
        self.sequence = sequence
    }
}

class KrakenSequenceParser {
    let path:String
    let readStream:DataStreamReader
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
    
    func parse(asvs:[KrakenASV]) {
        getSequenceIDs(asvs: asvs)
        var sequenceID = String()
        for line in readStream {
            if line.firstIndex(of: ">") != nil {
                sequenceID = line.replacingOccurrences(of: ">", with: "")
                sequenceID = sequenceID.trimmingCharacters(in: .whitespacesAndNewlines)
            } else {
                if let sequenceObj = match(sequenceID: sequenceID) {
                    sequenceObj.sequence = line.trimmingCharacters(in: .newlines)
                    sequences.append(sequenceObj)
                }
            }
        }
    }
    
    /// Method needed to preserve the order of the ASVs
    private func getSequenceIDs(asvs:[KrakenASV]) {
        for asv in asvs {
            sequences.append(KrakenSequence(sequenceID: asv.sequenceID))
        }
    }
    
    private func match(sequenceID:String) -> KrakenSequence? {
        for sequence in sequences {
            if sequence.sequenceID == sequenceID {
                if sequence.sequence.isEmpty {
                    return sequence
                } else {
                    return nil
                }
            }
        }
        return nil
    }
}
