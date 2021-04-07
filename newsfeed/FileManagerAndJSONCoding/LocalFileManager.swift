//
//  LocalFileManager.swift
//  newsfeed
//
//  Created by Anna Oksanichenko on 30.03.2021.
//

import Foundation

class LocalFileManager {
    
    
    
    let favoriteArticle = "favoriteArticles.json"
    
    private func documentDirectory() -> URL {
        let documentDirectory =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentDirectory
    }
    
    func createData(_ data: Data) {
        do {
            let url = documentDirectory().appendingPathComponent(favoriteArticle)
            try data.write(to: url)
        }
        catch {
            print("LocalFileManager -> getData: error \(error)")
        }
    }
    
    func readData() -> Data? {
        let url = documentDirectory().appendingPathComponent(favoriteArticle)
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            print(error)
            print("LocalFM read data: no data")
            return nil
        }
    }
}

