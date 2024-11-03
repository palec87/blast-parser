//
//  BlastOutputParser.swift
//  blast_parser
//
//  Created by João Varela on 03/11/2024.
//

import Foundation

// BLASTn output format
// A: qseqid = Query Seq-id (ID of your sequence)
// B: sseqid = Subject Seq-id (ID of the database hit)
// C: pident = Percentage of identical matches
// D: length = Alignment length
// E: evalue = Expected value (E-value)
// F: bitscore = Bit score
// G: sallseqid = All subject Seq-id(s), separated by a ';'
// H: score = Raw score
// I: nident = Number of identical matches
// J: positive = Number of positive-scoring matches
// K: ppos = Percentage of positive-scoring matches
// L: qframe = Query frame
// M: sframe = Subject frame
// N: qlen = Query sequence length
// O: slen = Subject sequence length
// P: salltitles = All subject title(s), separated by a '<>'
// Q: staxids = unique Subject Taxonomy ID(s), separated by a ';' (in numerical order)
// R: sscinames = unique Subject Scientific Name(s), separated by a ';'
// S: sskingdoms = unique Subject Super Kingdom(s), separated by a ';' (in alphabetical order)

final class BlastOutputParser: FileParser {
    let parsedClassification:String
    var hits = [BlastHit]()
    
    init?(path:String, parsedClassification: String) {
        self.parsedClassification = parsedClassification
        super.init(path: path)
    }
    
    func parse() throws {
        try parseBlastOutput()
    }
    
    private func parseBlastOutput() throws {
        for line in readStream {
            let items = line.components(separatedBy: "\t")
            guard items.count == 19 else { throw KrakenParserError.invalidFile }
            let qSeqID = items[0].trimmingCharacters(in: .whitespaces)
            let sSeqID = items[1].trimmingCharacters(in: .whitespaces)
            let pIdentity = Double(items[2].trimmingCharacters(in: .whitespaces)) ?? 0.0
            let length = Int(items[3].trimmingCharacters(in: .whitespaces)) ?? 0
            let eValue = Double(items[4].trimmingCharacters(in: .whitespaces)) ?? 0.0
            let bitscore = Int(items[5].trimmingCharacters(in: .whitespaces)) ?? 0
            let taxID = Int(items[16].trimmingCharacters(in: .whitespaces)) ?? 0
            let name = items[17].trimmingCharacters(in: .whitespaces)
            let kingdom = items[18].trimmingCharacters(in: .whitespacesAndNewlines)
            let hit = BlastHit(querySequenceID: qSeqID,
                               subjectSequenceID: sSeqID,
                               percentageIdentity: pIdentity,
                               alignmentLength: length,
                               eValue: eValue,
                               bitscore: bitscore,
                               taxID: taxID,
                               scientificName: name,
                               kingdom: kingdom)
            hits.append(hit)
        }
    }
}
