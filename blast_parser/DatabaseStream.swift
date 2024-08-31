//
//  DatabaseStream.swift
//  blast_parser
//
//  Created by João Varela on 30/08/2024.
//

import Foundation

// Heavily borrowed from Martin R's answer at:
// https://stackoverflow.com/questions/24581517/read-a-file-url-line-by-line-in-swift
final class DatabaseStream {
    let url:URL
    var filehandle:FileHandle!
    var buffer:Data
    var delimiter:Data
    var isEOF = false
    let encoding:String.Encoding
    let bufferSize:Int
    
    enum DSError: Error {
        case delimiterError
        case readError
    }
    
    /// Must be paired with a call to close()
    init(url:URL, delimiter:String = "\n",
          blockSize:Int = 4096,
          encoding:String.Encoding = .utf8) throws {
        do {
            self.url = url
            self.filehandle = try FileHandle(forReadingFrom: url)
            guard let dataDelimiter = delimiter.data(using: encoding)
                else { throw DSError.delimiterError }
            self.delimiter = dataDelimiter
            self.encoding = encoding
            self.bufferSize = blockSize
            self.buffer = Data()
        }
        
        catch {
            throw DSError.readError
        }
    }
    
    /// Return next line, or nil on EOF.
    func nextLine() -> String? {
        // Read data chunks from file until a line delimiter is found:
        while isEOF == false {
            if let range = buffer.range(of: delimiter) {
                // Convert complete line (excluding the delimiter) to a string:
                let line = String(data: buffer.subdata(in: 0..<range.lowerBound), 
                                  encoding: encoding)
                // Remove line (and the delimiter) from the buffer:
                buffer.removeSubrange(0..<range.upperBound)
                return line
            }
        
            let tmpData = filehandle.readData(ofLength: bufferSize)
            if tmpData.count > 0 {
                buffer.append(tmpData)
            } else {
                // EOF or read error.
                isEOF = true
                if buffer.count > 0 {
                    // Buffer contains last line in file (not terminated by delimiter).
                    let line = String(data: buffer as Data, encoding: encoding)
                    buffer.count = 0
                    return line
                }
            }
        }
        return nil
    }
    
    /// Start reading from the beginning of file.
    func rewind() -> Void {
        filehandle.seek(toFileOffset: 0)
        buffer.count = 0
        isEOF = false
    }
    
    func close() {
        do {
            try filehandle?.close()
        }
        
        catch {
            Console.writeToStdErr("Unable to close file at \(url.path)")
        }
    }
}

extension DatabaseStream : Sequence {
    func makeIterator() -> AnyIterator<String> {
        return AnyIterator {
            return self.nextLine()
        }
    }
}
