//
//  SignalSlot.swift
//  RealLifeApp
//
//  Created by Evgenii Kamyshanov on 15.11.14.
//  Copyright (c) 2014 EPAM Systems. All rights reserved.
//

import Foundation

infix operator <+> {}
infix operator <-> {}

func <+> <T> ( slot:SignalSlot<T>, signal:(String, ( param:T )->Void) )-> Void {
    slot.signals[signal.0] = signal.1
}

func <-> <T> ( slot:SignalSlot<T>, signalKey:String ) -> Void {
    slot.signals.removeValueForKey(signalKey)
}

class SignalSlot<T> {

    var signals:[String:( param:T )->Void] = [:]
    let queue:dispatch_queue_t
    
    init ( slotQueue:dispatch_queue_t ) {
        self.queue = slotQueue
    }
    
    init () {
        self.queue = dispatch_get_main_queue()
    }

    func fire (t:T) -> Void {
        for signal in signals.values {
            dispatch_async(self.queue) {
                signal(param: t)
            }
        }
    }
    
}