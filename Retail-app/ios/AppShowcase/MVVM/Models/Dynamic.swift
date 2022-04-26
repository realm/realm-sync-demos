//
//  Dynamic.swift
//  WKBoilerPlate
//
//  Created by Brian on 01/08/19.
//  Copyright © 2019 Wekan. All rights reserved.
//

import Foundation

class Dynamic<T> {
    typealias Listener = (T) -> Void

    var listener: Listener?

    func bind(_ listener: Listener?) {
        self.listener = listener
    }

    func bindAndFire(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }

    var value: T {
        didSet {
            listener?(value)
        }
    }

    init(_ val: T) {
        value = val
    }
}

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dict
    }
}

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data,
                                                  options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
