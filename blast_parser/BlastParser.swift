//
//  Blast_Parser.swift
//  blast_parser
//
//  Created by João Varela on 31/08/2024.
//

import Foundation
import ArgumentParser

@main

// root command
struct BlastParser: ParsableCommand {
static let configuration = CommandConfiguration(
        abstract: """
            Imports an NCBI ranked taxonomy dump file and exports it into a PostGresSQL \
            database and then retrieves and parses the taxonomy information to populate \
            the BLAST results with the respective taxa.
            """,
        usage: "blast_parser <subcommand>",
        version: "0.1",
        subcommands: [Import.self, Export.self, Parse.self],
        defaultSubcommand: Import.self
    )
}

// common options
struct Options:ParsableArguments {
}

extension BlastParser {
    struct Import: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Imports an NCBI ranked taxonomy dump file into a CSV file.",
            aliases: ["imp"]
        )
        
        @OptionGroup var options: Options
        
        @Option(name: [.short, .customLong("input")],
                    help: "Path to rankedlineage.dmp file to be imported.")
        var inputFile:String
        
        @Option(name: [.short, .customLong("output")],
                help: "Path to the output CSV file, which will be overwritten if it already exists.")
        var outputFile: String? = nil
        
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
    
    struct Export: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Exports the imported CSV file into a local PostGresSQL database.",
            aliases: ["exp"]
        )
        
        @OptionGroup var options: Options
        
        @Option(name: [.short, .customLong("input")],
                    help: "Path to rankedlineage.csv file to be imported.")
        var inputFile:String
        
        @Option(name: [.short, .customLong("database")],
                    help: "Name of the database to which rankedlineage.csv file will be exported. IMPORTANT NOTE: If you choose the name of a preexisting database, the latter will be OVERWRITTEN!")
        var database:String
        
        @Option(name: [.short, .customLong("table")],
                help: "Name of the table that will be created in the database. [OPTIONAL]")
        var table:String?
        
        mutating func run() throws {
            let database = SQLDatabase(database: database, table: table)
            database.CreateDatabase()
            database.ImportDatabase(pathToCSVFile: inputFile)
        }
    }
    
    struct Parse: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Parses a Kraken2 counts report to determine which sequences should be validated by BLASTN.",
            aliases: ["prs"]
        )
        
        @OptionGroup var options: Options
        
        @Option(name: [.short, .customLong("report")],
                help: "Path to Kraken2 counts report to be parsed.")
        var report:String
        
        @Option(name: [.short, .customLong("classification")],
                help: "Path to the Kraken2 taxonomic assignment file.")
        var classification:String
        
        @Option(name: [.short, .customLong("sequences")],
                help: "Path to the sample sequences file.")
        var sequences:String
        
        @Option(name: [.short, .customLong("output")],
                help: "Name of the output file. [OPTIONAL]")
        var outputFile:String?
        
        mutating func run() throws {
            guard let parser = KrakenParser(report: report,
                                            classification: classification,
                                            sequences: sequences) else {
                throw KrakenParserError.invalidFile
            }
            
            try parser.parseReport()
            try parser.print(to: outputFile)
        }
    }
}

struct RuntimeError: Error, CustomStringConvertible {
    var description: String
    
    init(_ description: String) {
        self.description = description
    }
}

