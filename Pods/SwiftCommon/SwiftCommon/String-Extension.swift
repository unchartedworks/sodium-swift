/**
 # String-Extension.swift
## SwiftCommon
 
 - Author: Andrew Bradnan
 - Date: 5/25/16
 - Copyright: © 2016 Whirlygig Ventures. All rights reserved.
 */

import Foundation

extension String {
    /**
     Remove the characters from a string.
     
    '''
    let aString = "She was a soul stripper. She took my heart!"
    let chars: [Character] = ["a", "e", "i"]
 
    println(aString.stripCharacters(chars))
    '''
    */
    public func stripCharacters(_ chars: Set<Character>) -> String {
        return String(self.characters.filter({ !chars.contains($0)}))
    }
    
    /// indexOf(ch)
    public func indexOf(_ char: Character) -> String.Index? {
        return self.characters.index(of: char)
    }
    
    // spit out the string in ascii.  not sure how to make hex, it's decimal atm.
    public func toAsciiString() -> String {
        var rt = ""
        
        for ch in characters {
            rt += "\(ch) "
        }
        
        return rt
    }
    
    /// byte length
    public var countBytes: Int { return self.unicodeScalars.count }
    
    /// string length
    public var length: Int { return self.characters.count }
    
    /// easy NSRange for the string
    public var all: NSRange { get { return NSMakeRange(0, self.length) } }
    /// NSRange for all the bytes in a string
    public var allBytes: NSRange { get { return NSMakeRange(0, self.countBytes) } }
    
    /// search and replace using regex
    public func searchReplace(_ search: String, replace: String, options: NSRegularExpression.Options = .caseInsensitive) -> String {
        do {
            let expr = try NSRegularExpression(pattern: search, options: options)
            
            let replacement = expr.stringByReplacingMatches(in: self, options: NSRegularExpression.MatchingOptions(), range: self.allBytes, withTemplate: replace)
            
            return replacement
        }
        catch {
            return self
        }
    }
    
    /// get a substring the normal way
    public func substring(_ start: Int, end: Int) -> String {
        let r = self.characters.index(self.startIndex, offsetBy: start)..<self.characters.index(self.startIndex, offsetBy: end)
        return self.substring(with: r)
    }
    
    /// get a substring using a NSRange
    public func substring(_ r: NSRange) -> String {
        return self.substring(r.location, end: r.location + r.length)
    }
    
    /// is not nil or emtpy
    static func isNotEmpty(_ s: String?) -> Bool {
        return !(s?.isEmpty ?? true)
    }

    /// return array of strings of every 2 chars
    public var pairs: [String] {
        var result: [String] = []
        let chars = Array(characters)
        for index in stride(from: 0, to: chars.count, by: 2) {
            result.append(String(chars[index..<min(index+2, chars.count)]))
        }
        return result
    }
    
    /// find the last char
    public func lastIndexOf(_ c: Character) -> Index? {
        if let r: Range<Index> = self.range(of: String(c), options: .backwards) {
            return r.lowerBound
        }
        
        return nil
    }
    
    // return a filename
    public var pathFileName: String? {
        if let idx = self.lastIndexOf("/") {
            return self.substring(from: self.index(after: idx))
        }
        return nil
    }

}
