//
//  FileWriter.swift
//  blast_parser
//
//  Created by João Varela on 09/11/2024.
//

import Foundation

struct FileWriter {
    let path:String
    let outputURL:URL
    
    /// Generates a data stream writer
    /// - Parameters:
    ///     - path: path to file to write data to
    ///     - suffix: suffix to add to filename, which will be based on the name of the parent directory
    init(path:String, suffix:String) {
        self.path = path
        let url = URL(fileURLWithPath: path, isDirectory: false)
        let directoryURL = url.deletingLastPathComponent()
        let directoryName = directoryURL.lastPathComponent
        let filename = "\(directoryName)_\(suffix)"
        outputURL = directoryURL.appending(component: filename)
    }
    
    func makeDataWriter() throws -> DataStreamWriter {
        return try DataStreamWriter(url: outputURL)
    }
}
