//
//  Alamofire+ArgoRequest.swift
//  FrameworksPlayground
//
//  Created by Brian Thomas on 3/14/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import Alamofire
import Argo

extension Request {
  
  public func responseArgoJSON(completionHandler: (NSURLRequest, NSHTTPURLResponse?, Argo.JSONValue, NSError?) -> Void) -> Self {
    return responseArgoJSON(queue: nil, options: NSJSONReadingOptions.AllowFragments, completionHandler: completionHandler)
  }
  
  public func responseArgoJSON(queue: dispatch_queue_t? = nil, options: NSJSONReadingOptions = .AllowFragments, completionHandler: (NSURLRequest, NSHTTPURLResponse?, Argo.JSONValue, NSError?) -> Void) -> Self {
    return response(queue: queue, serializer: Request.JSONResponseSerializer(options: options), completionHandler: { (request, response, object, error) -> Void in
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
        var responseJSON: Argo.JSONValue?
        if error != nil || object == nil {
          responseJSON = Argo.JSONValue.JSONNull
        } else {
          responseJSON = Argo.JSONValue.parse(object!)
        }
        dispatch_async(queue ?? dispatch_get_main_queue(), {
          completionHandler(self.request, self.response, responseJSON!, error)
        })
      })
    })
  }
  
}