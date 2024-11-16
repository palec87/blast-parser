//
//  BlastOutputParser.swift
//  blast_parser
//
//  Created by João Varela on 03/11/2024.
//

import Foundation

struct BlastASV: CustomStringConvertible {
    let asv:KrakenASV
    let taxonomy:String?
    let hit:BlastHit
    
    init(asv: KrakenASV, taxonomy: String?, hit: BlastHit) {
        self.asv = asv
        self.taxonomy = taxonomy
        self.hit = hit
    }
    
    var description:String {
        if let taxonomy = self.taxonomy {
            return "\(asv)\t\(taxonomy)\t\(hit)"
        } else {
            return "\(asv)\t\(hit)"
        }
    }
}

final class BlastOutputParser: FileParser {
    let asvsParser:KrakenParsedASVParser
    var taxonomyParser:KrakenTaxonomyParser? = nil
    var hits = [BlastHit]()
    var bins = [BlastHitBin]()
    var blastASVs = [BlastASV]()
    var hitsPerASV = 1
    let defaultReportFilename:String = "blast-report.tsv"
    
    /// Initializer for a parser that will merge the output files of the parse
    /// subcommand with the BLASTn output file which should have the following
    /// 13 columns:
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
    /// - Parameters:
    ///     - path: path to the BLASTn output file
    ///     - asvs: path to parsed ASVs with taxonomic classification
    ///     - taxonomy: path to the parsed Kraken2 count file (optional)
    init?(path:String, asvs: String, taxonomy: String?) {
        guard let asvsParser = KrakenParsedASVParser(path: asvs)
            else { return nil }
        
        self.asvsParser = asvsParser
        
        if let taxonomy = taxonomy {
            self.taxonomyParser = KrakenTaxonomyParser(path: taxonomy)
        }
        
        super.init(path: path)
    }
    
    func parse(criterion:BlastHit.SortCriterion = .bitScore) throws {
        try parseBlastOutput()
        try parseBins(criterion: criterion)
        try merge()
    }
    
    func print(to path:String? = nil) throws {
        let writer = FileWriter(path: path ?? asvsParser.path,
                                filename: defaultReportFilename)
        let dataWriter = try writer.makeDataWriter()
        for blastASV in blastASVs {
            dataWriter.write(line: blastASV.description)
        }
    }
    
    private func parseBlastOutput() throws {
        for line in readStream {
            let items = line.components(separatedBy: "\t")
            guard items.count == 13 else
                { throw RuntimeError("ERROR: Invalid BLASTn output format.") }
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
    private func parseBins(criterion:BlastHit.SortCriterion) throws {
        var previousID = String()
        for hit in hits {
            if hit.querySequenceID != previousID {
                let bin = BlastHitBin(hit: hit)
                bin.sort(criterion: criterion)
                bins.append(bin)
                previousID = hit.querySequenceID
            } else {
                if let previousBin = bins.last {
                    previousBin.append(hit: hit)
                } else {
                    throw RuntimeError("ERROR: Unable to append BLAST hit to bin.")
                }
            }
        }
    }
    
    /// Merge Kraken ASVs with BLASTn best hit(s) of each bin
    /// depending upon the `hitsPerASV` instance variable
    private func merge() throws {
        guard hits.isEmpty == false else {
            throw RuntimeError("ERROR: Unable to merge BLAST hits with the ASVs table because no BLAST hits were found.")
        }
        
        let asvs = try asvsParser.parse()
        guard asvs.isEmpty == false else {
            throw RuntimeError("ERROR: Unable to merge BLAST hits with the ASVs table because no ASVs were found.")
        }
        
        try taxonomyParser?.parse()
        
        // We get the current ìndex to make the search faster in the ASVs table
        // and avoid searching the same hits all over again for each ASV as we
        // assume that the BLAST hits are in the same order as the ASV table
        // regarding the query sequence IDs
        var index = bins.startIndex
        for asv in asvs {
            guard index < bins.endIndex else { break }
            let bin = bins[index]
            guard var queryID = bin.sequenceID else {
                throw RuntimeError("ERROR: Unable to merge BLAST hits with the ASVs table because at least one BLAST hit does not have a sequence ID.")
            }
            
            if queryID == asv.sequenceID {
                // retrieve the best hit(s)
                guard let bestHits = bin.bestHits(hitsPerASV) else { continue }
                for hit in bestHits {
                    let taxonomy = taxonomyParser?.getTaxonomy(for: asv)
                    let blastASV = BlastASV(asv: asv,
                                            taxonomy: taxonomy,
                                            hit: hit)
                    blastASVs.append(blastASV)
                }
            }
            
            // ignore the following hits with the same sequenceID
            while queryID == asv.sequenceID && index < bins.endIndex {
                if let seqID = bins[index].sequenceID {
                    queryID = seqID
                }
                index = bins.index(after: index)
            }
        }
    }
}
