//
//  KrakenParser.swift
//  blast_parser
//
//  Created by João Varela on 12/07/2024.
//

import Foundation

final class KrakenParser {
    let classification:String
    let sequences:String
    let reportParser:KrakenReportParser
    let asvParser:KrakenASVParser
    let sequenceParser:KrakenSequenceParser
    let defaultReportFilename = "kraken2-parsed-output.tsv"
    let defaultClassificationFilename = "kraken2-parsed-classification.tsv"
    let defaultSequenceFilename = "kraken2-parsed-sequences.fasta"
    var sequencesPerBin = 10
    var asvs:[KrakenASV]?
    
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
            throw RuntimeError("ERROR: Invalid rank at \(line): \(taxon)")
        }
        
        catch {
            throw RuntimeError("ERROR: Unknown error while trying to parse Kraken2 counts report.")
        }
    }
    
    func parseASVs() throws {
        reportParser.sort()
        try asvParser.parse()
        asvs = asvParser.binArray.getASVs(sequencesPerBin: sequencesPerBin)
    }
    
    func parseSequences() throws {
        guard let asvs = self.asvs
            else { throw RuntimeError("ERROR: Invalid ASV file.") }
        sequenceParser.parse(asvs: asvs)
    }
    
    func printReport(to path:String? = nil) throws {
        let writer = FileWriter(path: path ?? reportParser.path,
                                filename: defaultReportFilename)
        let dataWriter = try writer.makeDataWriter()
        for line in reportParser.lines {
            dataWriter.write(line: line.getLine())
        }
    }
    
    func printParsedClassification(to path:String? = nil) throws {
        guard let asvs = self.asvs
            else { throw RuntimeError("ERROR: Invalid ASV file.")}
        
        let writer = FileWriter(path: path ?? reportParser.path,
                                filename: defaultClassificationFilename)
        let dataWriter = try writer.makeDataWriter()
        for asv in asvs {
            dataWriter.write(line: asv.description)
        }
    }
    
    func printParsedSequences(to path:String? = nil) throws {
        let writer = FileWriter(path: path ?? reportParser.path,
                                filename: defaultSequenceFilename)
        let dataWriter = try writer.makeDataWriter()
        for sequence in sequenceParser.sequences {
            dataWriter.write(line: ">" + sequence.sequenceID)
            dataWriter.write(line: sequence.sequence)
        }
    }
}



