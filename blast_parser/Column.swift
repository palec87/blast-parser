//
//  Column.swift
//  blast_parser
//
//  Created by João Varela on 12/07/2024.
//

//import Foundation
//
//struct Column {
//    enum ColumnType {
//        case number
//        case string
//    }
//    
//    enum ColumnName:String, CaseIterable {
//        case qseqid = "query ID"
//        case sseqid = "subject ID"
//        case pident = "% identities"
//        case length = "alignment length"
//        case mismatch = "mismatch nr"
//        case gapopen = "gap openings"
//        case qstart = "query start"
//        case qend = "query end"
//        case sstart = "subject start"
//        case send = "subject end"
//        case evalue = "E-value"
//        case bitscore = "bitscore"
//        case salltitles = "name"
//        case score = "raw score"
//        case nident = "identities"
//        
//        func type() -> ColumnType {
//            switch self {
//            case .qseqid, .sseqid, .salltitles:
//                return .string
//            default:
//                return .number
//            }
//        }
//    }
//    
//    let name:ColumnName
//    let contents:String
//    
//    init(contents: String, name:ColumnName) {
//        self.contents = contents
//        self.name = name
//    }
//}
