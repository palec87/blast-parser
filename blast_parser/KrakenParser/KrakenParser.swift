//
//  KrakenParser.swift
//  blast_parser
//
//  Created by João Varela on 12/07/2024.
//

import Foundation

enum KrakenParserError: Error {
    case invalidFile
    case invalidOutputFile
    case unknown
}

class KrakenParser {
    let classification:String
    let sequences:String
    let reportParser:KrakenReportParser
    let asvParser:KrakenASVParser
    let sequenceParser:KrakenSequenceParser
    let defaultReportFilename = "kraken2-parsed-output.tsv"
    let defaultClassificationFilename = "kraken2-parsed-classification.tsv"
    let defaultSequenceFilename = "kraken2-parsed-sequences.fasta"
    var sequencesPerBin = 10
    var outputURL:URL?
    
    init?(report: String, classification: String, sequences: String) {
        self.classification = classification
        self.sequences = sequences
        
        guard let reportParser = KrakenReportParser(path: report)
            else { return nil }
        
        guard let asvParser = KrakenASVParser(path: classification)
            else { return nil }
        
        guard let sequenceParser = KrakenSequenceParser(path: sequences)
            else { return nil }
        
        self.reportParser = reportParser
        self.asvParser = asvParser
        self.sequenceParser = sequenceParser
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
    
    func parseASVs() {
        reportParser.sort()
        asvParser.parse()
        sequenceParser.asvs = asvParser.binArray.getASVs(sequencesPerBin: sequencesPerBin)
    }
    
    func parseSequences() {
        sequenceParser.parse()
    }
    
    func printReport(to path:String? = nil) throws {
        if path == nil {
            let reportURL = URL(fileURLWithPath: reportParser.path,
                                isDirectory: false)
            let directoryURL = reportURL.deletingLastPathComponent()
            outputURL = directoryURL.appending(component: defaultReportFilename)
        } else {
            outputURL = URL(fileURLWithPath: path!, isDirectory: false)
        }
        
        guard let url = outputURL else { throw KrakenParserError.invalidOutputFile }
        let writer = try DataStreamWriter(url: url)
        
        for line in reportParser.lines {
            writer.write(line: line.getLine())
        }
    }
    
    func printParsedClassification(to path:String? = nil) throws {
        if path == nil {
            let reportURL = URL(fileURLWithPath: reportParser.path,
                                isDirectory: false)
            let directoryURL = reportURL.deletingLastPathComponent()
            outputURL = directoryURL.appending(component: defaultClassificationFilename)
        } else {
            outputURL = URL(fileURLWithPath: path!, isDirectory: false)
        }
        
        guard let url = outputURL else { throw KrakenParserError.invalidOutputFile }
        let writer = try DataStreamWriter(url: url)
        
        for asv in sequenceParser.asvs {
            writer.write(line: asv.description)
        }
    }
    
    func printParsedSequences(to path:String? = nil) throws {
        if path == nil {
            let reportURL = URL(fileURLWithPath: reportParser.path,
                                isDirectory: false)
            let directoryURL = reportURL.deletingLastPathComponent()
            outputURL = directoryURL.appending(component: defaultSequenceFilename)
        } else {
            outputURL = URL(fileURLWithPath: path!, isDirectory: false)
        }
        
        guard let url = outputURL else { throw KrakenParserError.invalidOutputFile }
        let writer = try DataStreamWriter(url: url)
        
        for sequence in sequenceParser.sequences {
            writer.write(line: ">" + sequence.sequenceID)
            writer.write(line: sequence.sequence)
        }
    }
}



