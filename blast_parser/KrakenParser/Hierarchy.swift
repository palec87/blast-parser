//
//  KrakenHierarchy.swift
//  blast_parser
//
//  Created by João Varela on 22/09/2024.
//

import Foundation

struct Hierarchy {
    private var ranks = [Rank]()
    
    var firstRank:Rank? {
        return ranks.first
    }
    
    var lastRank:Rank? {
        return ranks.last
    }
    
    var lastRankIndex:Int {
        return ranks.count - 1
    }
    
    /// init with an Unclassified rank
    init() {
        if let rank = Rank(rawValue: 0) {
            ranks.append(rank)
        }
    }
    
    mutating func addRank(_ rank:Rank) {
        ranks.append(rank)
    }
    
    mutating func dropLastRank() {
        _ = ranks.dropLast()
    }
    
    mutating func equalizeWithParent(of rank:Rank) {
        ranks.removeAll { $0 < rank || $0 == rank }
    }
    
    func getRank(index:Int) -> Rank? {
        if index >= 0 && index < ranks.count {
            return ranks[index]
        }
        return nil
    }
    
    func getRanks() -> String {
        var rankString = String()
        
        for rank in ranks {
            if rank.variant == 0 {
                rankString += "\(rank.abbreviation):\(rank.taxonName);"
            }
        }
        
        return rankString
    }
    
    mutating func reset() {
        self.ranks = [Rank]()
    }
}
