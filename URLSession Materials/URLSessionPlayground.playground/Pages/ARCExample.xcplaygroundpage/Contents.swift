// Swift
//
//  main.swift
//  TestARC
//
//  Created by Gregory Read on 3/29/16.
//  Copyright © 2016 Gregory Read. All rights reserved.
//

import Foundation

// A small object with a few small fields
class Item {
    var a: Int = 1
    var b: String = "12345"
    init() {
    }
}

// Object that contains an array of several small objects inside
class Items {
    let ITEM_COUNT: Int = 1000000
    var itemList: [Item]

    var id: Int

    init(id: Int) {
        self.id = id;
        itemList = []

        // You can't allocate array in advance, but we can preallocate
        // the memory required for it.  This will make it similar to
        // how C# arrays work.
        itemList.reserveCapacity(ITEM_COUNT);

        for _ in 0 ..< ITEM_COUNT {
            // You have to append to an array since it's not allocated.
            itemList.append(Item())
        }
    }

    deinit {
        print("Finalized Items")
    }

    var next: Items!
    var prev: Items!
}

func main() {
    let LINKED_LIST_SIZE: Int = 50

    // Create linked list with just one item in it to start
    var count: Int = 0
    var head: Items = Items(id: count)
    var tail: Items = head

    count = 1;
    // Loop until user hits a key
    while count < 500 {
        print("Adding new item to tail. - " + String(head.id) + "," + String(tail.id));
        // Append a new item to the end of the list
        tail.next = Items(id: count);
        tail.next.prev = tail;
        tail = tail.next;
        count += 1;
        // If our count has hit the max size we've set
        if count > LINKED_LIST_SIZE {
            print("Removing oldest item from head.")
            // With ARC, if we do not specifically set one of the references
            // to nil, neither object will be deallocated due to a reference cycle.
            // An alternative to this would be to have the "prev" reference be declared
            // with the "weak" keyword.
            head.prev = nil
            // Remove reference to oldest items object in list
            head = head.next
        }
    }
}

main()
