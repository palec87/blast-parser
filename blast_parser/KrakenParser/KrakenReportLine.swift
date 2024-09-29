//
//  KrakenReportLine.swift
//  blast_parser
//
//  Created by João Varela on 29/09/2024.
//

import Foundation

struct ReportLine {
    var lineNumber:Int = 0
    var percentage:Float = 0.0
    var reads:Int = 0
    var assignedReads:Int = 0
    var rank:Rank!
    var hierarchy:Hierarchy!
    var taxID:Int = 0
    var taxonName:String = ""
    
    init() {}
    
    func getLine() -> String {
        return ""
    }
}
