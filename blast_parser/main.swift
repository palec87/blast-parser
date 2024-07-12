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
let arguments = Console.getArgs()

guard arguments.count == 2 else {
    Console.writeToStdErr("Wrong argument number. Will exit now!\n")
    exit(-1)
}

let parser = Parser(path: arguments[1])

guard let contents = parser.read() else {
    Console.writeToStdErr("Unable to read file at \(parser.path)\n")
    exit(-1)
}

let taxids = parser.parse(contents: contents, column: columnToRead)

for taxid in taxids {
    Console.writeToStdOut("\(taxid)\n")
}



