//
//  KrakenRanks.swift
//  blast_parser
//
//  Created by João Varela on 17/09/2024.
//

import Foundation

struct Rank: RawRepresentable {
    // variants of ranks can be numbered, for instance, D1,
    // D2 and D3 before or after the main rank, i.e., D
    enum VariantPosition {
        case none
        case before
        case after
    }
    
    static let ranks = ["Unclassified",
                        "Root",
                        "Domain",
                        "Kingdom",
                        "Phylum",
                        "Class",
                        "Order",
                        "Family",
                        "Genus",
                        "Species"]
    static let abbreviations = ["U","R","D","K","P","C","O","F","G","S"]
    
    typealias RawValue = Int
    var rawValue:Int
    var variant:Int = 0
    var variantPosition = VariantPosition.none
    var abbreviation:String = ""
    var rank:String = ""
    var name:String = ""
    
    init?(rawValue:Int) {
        self.rawValue = rawValue
        guard rawValue >= 0 && rawValue <= 9 else { return nil }
        abbreviation = Rank.abbreviations[rawValue]
        rank = Rank.ranks[rawValue]
    }
    
    init?(rankCodeString:String) {
        if rankCodeString.count == 1 {
            if let index = Rank.abbreviations.firstIndex(of: rankCodeString) {
                self.rawValue = index
                self.abbreviation = rankCodeString
                self.rank = Rank.ranks[index]
            } else {
                return nil
            }
        } else if rankCodeString.count == 2 {
            guard let first = rankCodeString.first else { return nil }
            let abbreviation = String(first)
            if let index = Rank.abbreviations.firstIndex(of: abbreviation) {
                self.rawValue = index
                self.abbreviation = abbreviation
                self.rank = Rank.ranks[index]
                guard let last = rankCodeString.last else { return nil }
                guard let variant = Int(String(last)) else { return nil }
                self.variant = variant
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}

extension Rank: Equatable {
    static func == (lhs:Rank, rhs:Rank) -> Bool {
        return lhs.rawValue == rhs.rawValue &&
                lhs.variant == rhs.variant &&
                lhs.variantPosition == rhs.variantPosition
    }
    
    static func != (lhs:Rank, rhs:Rank) -> Bool {
        return lhs.rawValue != rhs.rawValue ||
                lhs.variant != rhs.variant ||
                lhs.variantPosition != rhs.variantPosition
    }
}

struct Hierarchy {
    
}
