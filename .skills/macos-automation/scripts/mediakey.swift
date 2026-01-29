#!/usr/bin/env swift
// mediakey.swift - Send system media keys (play/pause, next, previous)
// Usage: mediakey [play|next|prev]

import Cocoa

func sendMediaKey(key: Int32, down: Bool) {
    let flags = down ? NSEvent.ModifierFlags(rawValue: 0xa00) : NSEvent.ModifierFlags(rawValue: 0xb00)
    let data1 = Int((Int32(key) << 16) | ((down ? 0xa : 0xb) << 8))
    
    let event = NSEvent.otherEvent(
        with: .systemDefined,
        location: .zero,
        modifierFlags: flags,
        timestamp: 0,
        windowNumber: 0,
        context: nil,
        subtype: 8,
        data1: data1,
        data2: -1
    )
    event?.cgEvent?.post(tap: .cgSessionEventTap)
}

func pressMediaKey(_ keyType: Int32) {
    sendMediaKey(key: keyType, down: true)
    usleep(100000)
    sendMediaKey(key: keyType, down: false)
}

// Media key types
let NX_KEYTYPE_PLAY: Int32 = 16
let NX_KEYTYPE_NEXT: Int32 = 17
let NX_KEYTYPE_PREVIOUS: Int32 = 18

let args = CommandLine.arguments
let command = args.count > 1 ? args[1] : "play"

switch command {
case "play", "pause":
    pressMediaKey(NX_KEYTYPE_PLAY)
case "next":
    pressMediaKey(NX_KEYTYPE_NEXT)
case "prev", "previous":
    pressMediaKey(NX_KEYTYPE_PREVIOUS)
default:
    print("Usage: mediakey [play|pause|next|prev]")
    exit(1)
}
