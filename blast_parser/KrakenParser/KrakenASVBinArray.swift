//
//  KrakenASVBinArray.swift
//  blast_parser
//
//  Created by João Varela on 27/10/2024.
//

import Foundation

struct KrakenASVBinArray {
    private var bins = [KrakenASVBin]()
    
    func append(asv:KrakenASV) {
        if var bin = match(asv: asv) {
            bin.append(asv: asv)
        } else {
            let isClassified = asv.taxonomy.taxID != 0
            var bin = KrakenASVBin(isClassified: isClassified,
                                   taxonomy: asv.taxonomy)
            bin.append(asv: asv)
        }
    }
    
    func getASVs(sequencesPerBin:Int = 10) -> [KrakenASV] {
        var result = [KrakenASV]()
        for var bin in bins {
            result += bin.asvs(sequencesToReturn: sequencesPerBin)
        }
        return result
    }
    
    private func match(asv:KrakenASV) -> KrakenASVBin? {
        for bin in bins {
            if asv.taxonomy == bin.taxonomy {
                return bin
            }
        }
        return nil
    }
}
