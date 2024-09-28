//
//  KrakenParser.swift
//  blast_parser
//
//  Created by João Varela on 12/07/2024.
//

import Foundation

enum KrakenParserError: Error {
    case invalidFile
    case unknown
}

class KrakenParser {
    let classification:String
    let sequences:String
    let reportParser:ReportParser
    
    init?(report: String, classification: String, sequences: String) {
        self.classification = classification
        self.sequences = sequences
        
        guard let parser = ReportParser(path: report)
            else { return nil }
        
        self.reportParser = parser
    }
    
    func parseReport() throws {
        do {
            try reportParser.parse()
        }
        
        catch ReportParserError.invalidRank(let line, let taxon) {
            Console.writeToStdErr("Invalid rank at \(line): \(taxon)")
            throw KrakenParserError.invalidFile
        }
        
        catch {
            Console.writeToStdErr("Unknown error while trying to parse Kraken2 counts report.")
            throw KrakenParserError.unknown
        }
    }
}



