//
//  main.swift
//  blast_parser
//
//  Created by João Varela on 11/07/2024.
//

import Foundation

// column to extract
let columnToRead = 10

// main
//let arguments = Console.getArgs()
//let path = "/Users/admin/Documents/Development/Bioinformatics/ncbi/queries/NEC_13_00001_t.txt"
let databasePath = "/Users/admin/Documents/Development/Bioinformatics/ncbi/db/new_taxdump/rankedlineage.dmp"
let outputFilePath = "/Users/admin/Documents/Development/Bioinformatics/ncbi/db/new_taxdump/rankedlineage.csv"

//guard arguments.count == 1 else {
//    Console.writeToStdErr("Wrong argument number. Will exit now!\n")
//    exit(1)
//}


// let url = URL(fileURLWithPath: arguments[1], isDirectory: false)

let database = Database(path: databasePath, outputPath: outputFilePath)
database.parse()




