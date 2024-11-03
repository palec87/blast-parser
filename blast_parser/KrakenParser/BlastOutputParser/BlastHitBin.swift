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
    
    func sort(criterion:SortCriterion) {
        
    }
}
