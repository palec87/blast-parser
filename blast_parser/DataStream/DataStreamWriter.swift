//
//  DataStreamWriter.swift
//  blast_parser
//
//  Created by João Varela on 31/08/2024.
//

import Foundation

enum DataStreamWriterError: Error {
    case writeError(String)
}

extension DataStreamWriterError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .writeError(let path):
            return NSLocalizedString("Unable to create file to write at \(path). Ensure that the path is correct and reachable.",
                                     comment: "")
        }
    }
}

final class DataStreamWriter : DataStream {
    var lines = [String]()
    var count = 0
    var totalCharacterCount = 0
    var numberOfLines = 0
    
    /// Must be paired with a call to close()
    override init(url:URL, blockSize:Int = 4096) throws {
        let filemanager = FileManager.default
        // NOTE: this will overwite the previous contents of an existing file
        guard filemanager.createFile(atPath: url.path, contents: nil)
            else { throw DataStreamWriterError.writeError(url.path) }
        try super.init(url: url, blockSize: blockSize)
        filehandle = try FileHandle(forWritingTo: url)
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
            numberOfLines += 1
        }
        stringToWrite += terminatedLine
        numberOfLines += 1
        filehandle.write(stringToWrite)
        totalCharacterCount += count;
        count = 0
        lines = [String]()
        Console.writeToStdOutInPlace("Written \(totalCharacterCount) characters in \(numberOfLines) lines...")
    }
}
