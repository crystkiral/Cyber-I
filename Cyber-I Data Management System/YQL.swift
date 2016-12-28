//
//  YQL.swift
//  YQLSwift
//
//  Created by Jake Lee on 1/25/15.
//  Copyright (c) 2015 JHL. All rights reserved.
//

import Foundation

struct YQL {
    fileprivate static let prefix:NSString = "http://query.yahooapis.com/v1/public/yql?&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback=&q="
    
    static func query(_ statement:String) -> NSDictionary? {

        var escapedStatement = statement.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed())
        let query = "\(prefix)\(escapedStatement!)"

        var results:NSDictionary? = nil
        var jsonError:NSError? = nil
        do{
        let jsonData = try Data(contentsOf: URL(string: query)!, options: NSData.ReadingOptions.mappedIfSafe)
        
       
        
        
            results = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
        
        if jsonError != nil {
            NSLog( "ERROR while fetching/deserializing YQL data. Message \(jsonError!)" )
        }
        }
        catch{}
        return results
            
    }
}
