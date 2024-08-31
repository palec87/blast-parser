//
//  DatabaseWriter.swift
//  blast_parser
//
//  Created by João Varela on 31/08/2024.
//

import Foundation

enum DatabaseWriterError: Error {
    case writeError(String)
}

extension DatabaseWriterError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .writeError(let path):
            return NSLocalizedString("Unable to create file to write at \(path). Ensure that the path is correct and reachable.",
                                     comment: "")
        }
    }
}

final class DatabaseWriter {
    let url:URL
    var filehandle:FileHandle!
    var lines = [String]()
    let bufferSize:Int
    var count = 0
    
    /// Must be paired with a call to close()
    init(url:URL, blockSize:Int = 4096) throws {
        self.url = url
        let filemanager = FileManager.default
        // NOTE: this will overwite the previous contents of an existing file
        guard filemanager.createFile(atPath: url.path, contents: nil)
            else { throw DatabaseWriterError.writeError(url.path) }
        self.filehandle = try FileHandle(forWritingTo: url)
        self.bufferSize = blockSize
    }
    
    func write(line:String) {
        let terminatedLine = line + "\n"
        count += terminatedLine.count
       
        if count < bufferSize {
            lines.append(terminatedLine)
        } else {
            writeToFile(terminatedLine: terminatedLine)
        }
    }
    
    private func writeToFile(terminatedLine:String = "") {
        var stringToWrite = String()
        for line in lines {
            stringToWrite += line
        }
        stringToWrite += terminatedLine
        filehandle.write(stringToWrite)
        count = 0
        lines = [String]()
    }
    
    func close() {
        if count > 0 {
            writeToFile()
        }
        
        do {
            try filehandle?.close()
        }
        
        catch {
            Console.writeToStdErr("Unable to close file at \(url.path)")
        }
    }
}
