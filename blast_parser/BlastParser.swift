//
//  Blast_Parser.swift
//  blast_parser
//
//  Created by João Varela on 31/08/2024.
//

import Foundation
import ArgumentParser

@main
struct BlastParser: ParsableCommand {
    @Argument(help: "Path to rankedtaxonomy.dmp file to be imported.")
    var inputFile: String
    @Option(name: [.short, .customLong("output")],
            help: "Path to the output CSV file, which will be overwritten if it already exists.")
    var outputFile: String? = nil
    
    static let configuration = CommandConfiguration(
            abstract: "Imports an NCBI ranked taxonomy dump file an exports it into a PostGresSQL database",
            usage: """
                blast_parser <input-file> [OPTIONS] 
                """)
    
    mutating func run() throws {
        let inputURL = URL(fileURLWithPath: inputFile)
        guard FileManager.default.fileExists(atPath: inputFile) else {
            throw RuntimeError("Input file at \(inputFile) not found.")
        }
        
        var outputPath = String()
        if outputFile == nil {
            let oldFilenameURL = inputURL.deletingPathExtension()
            outputPath = oldFilenameURL.appendingPathExtension("csv").path
        } else {
            outputPath = outputFile!
        }
        
        let database = Database(path: inputFile, outputPath: outputPath)
        database.parse()
    }
}

struct RuntimeError: Error, CustomStringConvertible {
    var description: String
    
    init(_ description: String) {
        self.description = description
    }
}

