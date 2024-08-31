//
//  Column.swift
//  blast_parser
//
//  Created by João Varela on 12/07/2024.
//

import Foundation

struct SortingColumn {
    enum ColumnOrder {
        case ascending
        case descending
    }
    
    let type:Column.ColumnType
    let order:ColumnOrder
    
    init(type: Column.ColumnType, order: ColumnOrder) {
        self.type = type
        self.order = order
    }
}
