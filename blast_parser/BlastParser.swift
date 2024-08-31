//
//  Blast_Parser.swift
//  blast_parser
//
//  Created by João Varela on 31/08/2024.
//

import ArgumentParser


@main
struct BlastParser: ParsableCommand {
    @Argument var inputFile: String
    @Argument var outputFile: String
    
    mutating func run() throws {
        print("""
            Counting words in '\(inputFile)' \
            and writing the result into '\(outputFile)'.
            """)
            
        // Read 'inputFile', count the words, and save to 'outputFile'.
    }
}
