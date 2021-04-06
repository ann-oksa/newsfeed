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
            print("LocalFM create data: data write")
        }
        catch {
            print("LocalFileManager -> getData: error \(error)")
        }
    }
    
    func readData() -> Data? {
        let url = documentDirectory().appendingPathComponent(favoriteArticle)
        print("LocalFM url")
        
        do {
            let data = try Data(contentsOf: url)
            print("LocalFM read data: have data")
            return data
            
        } catch {
            print(error)
            print("LocalFM read data: no data")
// not return
            return nil
        }
    }
}

