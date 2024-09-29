//
//  KrakenReportParser.swift
//  blast_parser
//
//  Created by João Varela on 15/09/2024.
//

import Foundation

enum ReportParserError: Error {
    case invalidRank(line: Int, taxon:String)
}

class ReportParser {
    let path:String
    let readStream:DataStreamReader
    var lines = [ReportLine]()
    
    init?(path: String) {
        do {
            self.path = path
            let url = URL(fileURLWithPath: path)
            self.readStream = try DataStreamReader(url: url)
        }
        
        catch {
            Console.writeToStdErr("Unable to read the report file at \(path)")
            return nil
        }
    }
    
    /// Main method to parse a Kraken2 report
    func parse() throws {
        var i = 0
        for line in readStream {
            let items = line.components(separatedBy: "\t")
            guard items.count == 6 else { continue }
            var reportLine = ReportLine()
            reportLine.lineNumber = i
            reportLine.percentage = Float(items[0]) ?? 0.0
            reportLine.reads = Int(items[1]) ?? 0
            reportLine.assignedReads = Int(items[2]) ?? 0
            reportLine.taxID = Int(items[4]) ?? 0
            reportLine.taxonName = items[5].trimmingCharacters(in: .whitespaces)
            reportLine.rank = try parseRank(line: reportLine, abbreviation: items[3])
            reportLine.hierarchy = Hierarchy.current
            lines.append(reportLine)
            i += 1
        }
    }
    
    /// Parses a line and its abbreviation
    /// - Parameters:
    ///     - line: the line being parsed of the Kraken2 report
    ///     - abbreviation: the abbreviation of the rank (e.g., "U" for "Unclassified")
    /// - Returns: A Rank object describing the taxonomic rank and name
    private func parseRank(line:ReportLine, abbreviation:String) throws -> Rank  {
        // default rank is "U" or "Unclassified"
        switch abbreviation {
        case "U":
            return Rank.unclassified()
        case "R":
            return Rank.root()
        case "D":
            return Rank.domain(line: line)
        default:
            do {
                return try Rank.rank(abbreviation: abbreviation,
                                     name: line.taxonName)
            }
            
            catch {
                throw ReportParserError.invalidRank(line: line.lineNumber,
                                                    taxon: line.taxonName)
            }
        }
    }
}

