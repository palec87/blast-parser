//
//  Database.swift
//  blast_parser
//
//  Created by João Varela on 30/08/2024.
//

import Foundation

final class Database {
    let readStream:DatabaseStream
    let writeStream:DatabaseWriter
    let blockSize = 4096
    
    init(path:String, outputPath:String) {
        let url = URL(fileURLWithPath: path)
        let outURL = URL(fileURLWithPath: outputPath)
        do {
            self.readStream = try DatabaseStream(url: url, blockSize: blockSize)
            self.writeStream = try DatabaseWriter(url: outURL, blockSize: blockSize)
        }
        
        catch DatabaseStream.DSError.delimiterError {
            Console.writeToStdErr("Unable to use delimiter for file at \(url.path)")
            exit(1)
        }
        
        catch DatabaseStream.DSError.readError {
            Console.writeToStdErr("Unable to read file at \(url.path)")
            exit(2)
        }
        
        catch {
            Console.writeToStdErr("\(error.localizedDescription)")
            exit(3)
        }
    }
    
    func parse() {
        for line in readStream {
            writeStream.write(line: parseLine(line: line))
        }
        
        readStream.close()
        writeStream.close()
    }
    
    private func parseLine(line:String) -> String {
        var filteredLine = line.replacingOccurrences(of: "\t", with: "")
        filteredLine = filteredLine.replacingOccurrences(of: "|", with: ",")
        return filteredLine
    }
}
