//
//  BlastOutputParser.swift
//  blast_parser
//
//  Created by João Varela on 03/11/2024.
//

import Foundation

struct BlastASV: CustomStringConvertible {
    let asv:KrakenASV
    let hit:BlastHit
    
    var description:String {
        return "\(asv)\t\(hit)"
    }
}

final class BlastOutputParser: FileParser {
    let asvsParser:KrakenASVParser
    var hits = [BlastHit]()
    var bins = [BlastHitBin]()
    var blastASVs = [BlastASV]()
    var hitsPerASV = 1
    let defaultReportFilename:String = "blast-report.tsv"
    
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
    
    func print(to path:String? = nil) throws {
        let writer = FileWriter(path: path ?? asvsParser.path,
                                filename: defaultReportFilename)
        let dataWriter = try writer.makeDataWriter()
        for blastASV in blastASVs {
            dataWriter.write(line: blastASV.description)
        }
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
    
    /// Merge Kraken ASVs with BLASTn best hit(s) of each bin
    /// depending upon the `hitsPerASV` instance variable
    private func merge() {
        guard hits.isEmpty == false else {
            Console.writeToStdErr("ERROR: Unable to merge BLAST hits with the ASVs table because no BLAST hits were found.")
            return
        }
        
        asvsParser.parse()
        let asvs = asvsParser.binArray.getASVs()
        
        guard asvs.isEmpty == false else {
            Console.writeToStdErr("ERROR: Unable to merge BLAST hits with the ASVs table because no ASVs were found.")
            return
        }
        
        // We get the current ìndex to make the search faster in the ASVs table
        // and avoid searching the same hits all over again for each ASV as we
        // assume that the BLAST hits are in the same order than the ASV table
        // regarding the query sequence IDs
        var index = bins.startIndex
        for asv in asvs {
            guard index < bins.endIndex else { break }
            let bin = bins[index]
            guard var queryID = bin.sequenceID else { continue }
            if queryID == asv.sequenceID {
                // retrieve the best hit(s)
                guard let bestHits = bin.bestHits(hitsPerASV) else { continue }
                for hit in bestHits {
                    let blastASV = BlastASV(asv: asv, hit: hit)
                    blastASVs.append(blastASV)
                }
            }
            
            // ignore the following hits with the same sequenceID
            repeat {
                index = bins.index(after: index)
                if let seqID = bins[index].sequenceID {
                    queryID = seqID
                }
            } while queryID == asv.sequenceID && index < bins.endIndex
        }
    }
}
