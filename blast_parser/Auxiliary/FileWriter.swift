//
//  FileWriter.swift
//  blast_parser
//
//  Created by João Varela on 09/11/2024.
//

import Foundation

struct FileWriter {
    let path:String
    let outputURL: URL
    
    /// Generates a data stream writer
    /// - Parameters:
    ///     - path: path to file to write data to
    ///     - filename: if not empty, filename to replace the last component of `path`
    init(path:String, filename:String = String()) {
        self.path = path
        
        if filename.isEmpty {
            outputURL = URL(fileURLWithPath: path, isDirectory: false)
        } else {
            let url = URL(fileURLWithPath: path, isDirectory: false)
            let directoryURL = url.deletingLastPathComponent()
            outputURL = directoryURL.appending(component: filename)
        }
    }
    
    func makeDataWriter() throws -> DataStreamWriter {
        return try DataStreamWriter(url: outputURL)
    }
}
