//
//  BlastHitBin.swift
//  blast_parser
//
//  Created by João Varela on 03/11/2024.
//

import Foundation

struct BlastHitBin {
    enum SortCriterion {
        case identity
        case eValue
        case bitScore
    }
    
    var hits:[BlastHit]
    
    var bestHit:BlastHit? {
        guard hits.isEmpty == false else { return nil }
        return hits[0]
    }
    
    mutating func sort(criterion:SortCriterion) {
        switch criterion {
        case .identity:
            hits.sort(by: sortByIdentity)
        case .eValue:
            hits.sort(by: sortByEValue)
        case .bitScore:
            hits.sort(by: sortByBitScore)
        }
    }
    
    func sortByIdentity(_ lhs:BlastHit,_ rhs:BlastHit) -> Bool {
        lhs.percentageIdentity > rhs.percentageIdentity
    }
    
    func sortByEValue(_ lhs:BlastHit,_ rhs:BlastHit) -> Bool {
        lhs.eValue < rhs.eValue
    }
    
    func sortByBitScore(_ lhs:BlastHit,_ rhs:BlastHit) -> Bool {
        lhs.bitscore > rhs.bitscore
    }
}
