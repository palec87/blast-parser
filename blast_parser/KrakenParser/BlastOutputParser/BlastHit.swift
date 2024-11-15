//
//  BlastHit.swift
//  blast_parser
//
//  Created by João Varela on 03/11/2024.
//

import Foundation

struct BlastHit: CustomStringConvertible {
    enum SortCriterion:String {
        case identity = "pident"
        case eValue = "evalue"
        case bitScore = "bitscore"
    }
    
    let querySequenceID:String
    let subjectSequenceID:String
    let percentageIdentity:Double
    let alignmentLength:Int
    let eValue:Double
    let bitscore:Int
    let taxID:Int
    let scientificName:String
    let kingdom:String
    
    var description:String {
        return """
                    \(subjectSequenceID)\t\
                    \(percentageIdentity)\t\
                    \(bitscore)\t\
                    \(eValue)\t\
                    \(taxID)\t\
                    \(scientificName)
               """
    }
}

extension BlastHit {
    static func sortByIdentity(_ lhs:BlastHit,_ rhs:BlastHit) -> Bool {
        lhs.percentageIdentity > rhs.percentageIdentity
    }
    
    static func sortByEValue(_ lhs:BlastHit,_ rhs:BlastHit) -> Bool {
        lhs.eValue < rhs.eValue
    }
    
    static func sortByBitScore(_ lhs:BlastHit,_ rhs:BlastHit) -> Bool {
        lhs.bitscore > rhs.bitscore
    }
}

extension [BlastHit] {
    mutating func sort(criterion:BlastHit.SortCriterion) {
        switch criterion {
        case .identity:
            self.sort(by: BlastHit.sortByIdentity)
        case .eValue:
            self.sort(by: BlastHit.sortByEValue)
        case .bitScore:
            self.sort(by: BlastHit.sortByBitScore)
        }
    }
}



