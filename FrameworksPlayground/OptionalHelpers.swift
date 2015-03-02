//
//  OptionalHelpers.swift
//  FrameworksPlayground
//
//  Created by Brian Thomas on 3/9/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation

func clean<T>(optionals: [T?]) -> [T] {
  var posts : [T] = []
  for optional in optionals {
    switch optional {
    case .Some(let val):
      posts.append(val)
    default:
      assert(true)
    }
  }
  return posts
}

func toDictionary<E, K, V>(
  array: [E],
  transformer: (element: E) -> (key: K, value: V)?)
  -> Dictionary<K, V>
{
  return array.reduce([:]) {
    (var dict, e) in
    if let (key, value) = transformer(element: e)
    {
      dict[key] = value
    }
    return dict
  }
}

func indexMap<E, K where K: Hashable>(array: [E], transformer: (element: E) -> K?) -> Dictionary<K, [Int]> {
  var count: Int = 0
  let map = array.reduce([K: [Int]]()) {
    (var dict, e) in
    if let key = transformer(element: e)
    {
      if var previousVal = dict[key] {
        dict[key] = previousVal + [count]
      } else {
        dict[key] = [count]
      }
      count++
    }
    return dict
  }
  return map
}