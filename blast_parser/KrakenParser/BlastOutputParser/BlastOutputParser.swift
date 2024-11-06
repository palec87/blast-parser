//
//  BlastOutputParser.swift
//  blast_parser
//
//  Created by João Varela on 03/11/2024.
//

import Foundation

struct BlastASV {
    let asv:KrakenASV
    let hit:BlastHit
}

final class BlastOutputParser: FileParser {
    let asvsParser:KrakenASVParser
    var hits = [BlastHit]()
    var bins = [BlastHitBin]()
    var blastASVs = [BlastASV]()
    
    init?(path:String, parsedClassification: String) {
        guard let asvsParser = KrakenASVParser(path: parsedClassification)
            else { return nil }
        self.asvsParser = asvsParser
        super.init(path: path)
    }
    
    func parse(criterion:BlastHit.SortCriterion = .bitScore) throws {
        try parseBlastOutput()
        parseBins(criterion: criterion)
        merge()
    }
    
    /// Assumes a BLASTn output table with 19 columns as follows:
    /// A: qseqid = Query Seq-id (ID of your sequence)
    /// B: pident = Percentage of identical matches
    /// C: length = Alignment length
    /// D: evalue = Expected value (E-value)
    /// E: bitscore = Bit score
    /// F: score = Raw score
    /// G: nident = Number of identical matches
    /// H: saccver = Subject accession.version
    /// I: stitle = Subject Title
    /// J: qcovs = Query Coverage Per Subject
    /// K: staxids = unique Subject Taxonomy ID(s), separated by a ';' (in numerical order)
    /// L: sscinames = unique Subject Scientific Name(s), separated by a ';'
    /// M: sskingdoms = unique Subject Super Kingdom(s), separated by a ';' (in alphabetical order)
    private func parseBlastOutput() throws {
        for line in readStream {
            let items = line.components(separatedBy: "\t")
            guard items.count == 13 else { throw KrakenParserError.invalidFile }
            let qSeqID = items[0].trimmingCharacters(in: .whitespaces)
            let sSeqID = items[7].trimmingCharacters(in: .whitespaces)
            let pIdentity = Double(items[1].trimmingCharacters(in: .whitespaces)) ?? 0.0
            let length = Int(items[2].trimmingCharacters(in: .whitespaces)) ?? 0
            let eValue = Double(items[3].trimmingCharacters(in: .whitespaces)) ?? 0.0
            let bitscore = Int(items[4].trimmingCharacters(in: .whitespaces)) ?? 0
            let taxID = Int(items[10].trimmingCharacters(in: .whitespaces)) ?? 0
            let name = items[11].trimmingCharacters(in: .whitespaces)
            let kingdom = items[12].trimmingCharacters(in: .whitespacesAndNewlines)
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
    
    /// Parses the BLASTn output into bins with the same sequenceID
    /// Assumes the hits are sorted by their sequenceIDs
    private func parseBins(criterion:BlastHit.SortCriterion) {
        var previousID = String()
        var binHits = [BlastHit]()
        for hit in hits {
            if hit.querySequenceID == previousID {
                binHits.append(hit)
            } else {
                var bin = BlastHitBin(hits: binHits)
                bin.sort(criterion: criterion)
                bins.append(bin)
                binHits = [BlastHit]()
                previousID = hit.querySequenceID
            }
        }
        hits = [BlastHit]()
    }
    
    /// Merge Kraken ASVs with BLASTn best hit of each bin
    private func merge() {
        asvsParser.parse()
        let asvs = asvsParser.binArray.getASVs()
        
    }
}
