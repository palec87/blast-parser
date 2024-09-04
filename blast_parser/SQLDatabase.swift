//
//  SQLDatabase.swift
//  blast_parser
//
//  Created by João Varela on 01/09/2024.
//

import Foundation

final class SQLDatabase {
    let database:String
    let table:String?
    let columns = """
            tax_id int PRIMARY KEY NOT NULL,
            tax_name varchar(50) NOT NULL,
            species varchar(50),
            genus varchar(50),
            family varchar(50),
            order varchar(50),
            class varchar(50),
            phylum varchar(50),
            kingdom varchar(50),
            superkingdom varchar(50)
        """
    
    init(database:String, table:String?) {
        self.database = database
        self.table = table
    }
    
    func CreateDatabase() {
        PSDBeginWithDefaultDB();
        if PSDDoesExist(database) == true {
            PSDDeleteDatabase(database)
        }
        PSDCreateDatabase(database, table ?? "taxonomy", columns)
        PSDEnd();
    }
}
