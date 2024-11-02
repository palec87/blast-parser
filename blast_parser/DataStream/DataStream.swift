//
//  DataStream.swift
//  blast_parser
//
//  Created by João Varela on 31/08/2024.
//

import Foundation

class DataStream {
    let url:URL
    var filehandle:FileHandle!
    let bufferSize:Int
    
    init(url:URL, blockSize:Int = 4096) throws {
        self.url = url
        self.bufferSize = blockSize
    }
    
    deinit {
        close()
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

