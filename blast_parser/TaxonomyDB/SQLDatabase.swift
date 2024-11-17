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
            tax_name varchar(255) NOT NULL,
            species varchar(100),
            genus varchar(100),
            family varchar(100),
            "order" varchar(100),
            "class" varchar(100),
            phylum varchar(100),
            kingdom varchar(100),
            superkingdom varchar(100),
            comments varchar(50)
        """
    
    init(database:String, table:String?) {
        self.database = database
        self.table = table
    }
    
    func createDatabase() {
        PSDBeginWithDefaultDB();
        if PSDDoesExist(database) == true {
            PSDDeleteDatabase(database)
        }
        // This method swicthes automatically to the newly created db
        // to create the requested table
        let table = self.table ?? "taxonomy"
        PSDCreateDatabase(database, table, columns)
        Console.writeToStdOut("Database \"\(database)\" and table \"\(table)\" created successfully.")
    }
    
    func importDatabase(pathToCSVFile:String) {
        let table = self.table ?? "taxonomy"
        PSDCopyToDB(table, pathToCSVFile)
        Console.writeToStdOut("Table \"\(table)\" exported successfully.")
    }
}
