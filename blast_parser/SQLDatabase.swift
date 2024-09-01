//
//  SQLDatabase.swift
//  blast_parser
//
//  Created by João Varela on 01/09/2024.
//

import Foundation

final class SQLDatabase {
    init(database:String, table:String?) {
        createDatabase(database, table ?? "taxonomy")
    }
}
