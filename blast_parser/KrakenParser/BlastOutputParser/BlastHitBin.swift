//
//  BlastHitBin.swift
//  blast_parser
//
//  Created by João Varela on 03/11/2024.
//

import Foundation

struct BlastHitBin {
    var hits:[BlastHit]
    
    var bestHit:BlastHit? {
        guard hits.isEmpty == false else { return nil }
        return hits[0]
    }
    
    /// assumes that hits are already sorted
    /// using sort(criterion:)
    var bestHitsPerTaxID:[BlastHit]? {
        var bestHits = [BlastHit]()
        var currentTaxID = -1
        for hit in hits {
            if hit.taxID != currentTaxID {
                bestHits.append(hit)
                currentTaxID = hit.taxID
            }
        }
        
        if bestHits.isEmpty {
            return nil
        } else {
            return bestHits
        }
    }
    
    mutating func sort(criterion:BlastHit.SortCriterion) {
        hits.sort(criterion: criterion)
    }
}
