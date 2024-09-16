//
//  KrakenReportParser.swift
//  blast_parser
//
//  Created by João Varela on 15/09/2024.
//

import Foundation

struct ReportLine {
    var percentage:Float = 0.0
    var reads:Int = 0
    var assignedReads:Int = 0
    var ranking:String = ""
    var taxID:Int = 0
    var taxon:String = ""
    var hierarchy:String = ""
    
    init() {}
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
    
    func parse() {
        for line in readStream {
            let items = line.components(separatedBy: "\t")
            guard items.count == 6 else { continue }
            var reportLine = ReportLine()
            reportLine.percentage = Float(items[0]) ?? 0.0
            reportLine.reads = Int(items[1]) ?? 0
            reportLine.assignedReads = Int(items[2]) ?? 0
            reportLine.ranking = items[3]
            reportLine.taxID = Int(items[4]) ?? 0
            reportLine.taxon = items[5].trimmingCharacters(in: .whitespaces)
            lines.append(reportLine)
        }
        parseRankings()
        sort()
    }
    
    private func parseRankings() {
        
    }
    
    private func sort() {
        
    }
}

