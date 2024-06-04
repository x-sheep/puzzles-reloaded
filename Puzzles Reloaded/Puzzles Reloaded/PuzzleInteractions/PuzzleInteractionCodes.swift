//
//  PuzzleInteractionCodes.swift
//  Puzzles
//
//  Created by Kyle Swarner on 4/18/24.
//  Copyright © 2024 Kyle Swarner. All rights reserved.
//

import Foundation
import SwiftUI

/*
enum {
    LEFT_BUTTON = 0x0200,
    MIDDLE_BUTTON,
    RIGHT_BUTTON,
    LEFT_DRAG,
    MIDDLE_DRAG,
    RIGHT_DRAG,
    LEFT_RELEASE,
    MIDDLE_RELEASE,
    RIGHT_RELEASE,
    CURSOR_UP,
    CURSOR_DOWN,
    CURSOR_LEFT,
    CURSOR_RIGHT,
    CURSOR_SELECT,
    CURSOR_SELECT2,
    /* UI_* are special keystrokes generated by front ends in response
     * to menu actions, never passed to back ends */
    UI_LOWER_BOUND,
    UI_QUIT,
    UI_NEWGAME,
    UI_SOLVE,
    UI_UNDO,
    UI_REDO,
    UI_UPPER_BOUND,
    
    /* made smaller because of 'limited range of datatype' errors. */
    MOD_CTRL       = 0x1000,
    MOD_SHFT       = 0x2000,
    MOD_NUM_KEYPAD = 0x4000,
    MOD_MASK       = 0x7000 /* mask for all modifiers */
};
 */

typealias ConditionalControlFunction = (_ gameId: String) -> Bool

/**
 A struct of constants that tie to the keycode commands present in the puzzles code.
 */
struct PuzzleKeycodes {
    static let SOLVE = UI_SOLVE
    static let UNDO = UI_UNDO
    static let REDO = UI_REDO
    
    static let DRAG_LEFT = MOD_SHFT | CURSOR_LEFT
    
    //TODO: Unsure if it makes sense to continue using these methods. Seems like we need to turn interactions into an Int. Holding on to it for now!
    // This was used becase LEFT/RIGHT/MIDDLE was stored as an integer, so they just used it to index these items
    static let buttonDown: [Int] = [LEFT_BUTTON, RIGHT_BUTTON, MIDDLE_BUTTON]
    static let buttonDrag: [Int] = [LEFT_DRAG, RIGHT_DRAG, MIDDLE_DRAG]
    static let buttonUp: [Int] = [LEFT_RELEASE, RIGHT_RELEASE, MIDDLE_RELEASE]
    
    static let leftKeypress: MouseClick = MouseClick(down: LEFT_BUTTON, up: LEFT_RELEASE, drag: LEFT_DRAG)
    static let rightKeypress: MouseClick = MouseClick(down: RIGHT_BUTTON, up: RIGHT_RELEASE, drag: RIGHT_DRAG)
    static let middleKeypress: MouseClick = MouseClick(down: MIDDLE_BUTTON, up: MIDDLE_RELEASE, drag: MIDDLE_DRAG)
    
    static let ClearButton = ButtonPress(keycode: 8) //ASCII value of 'Backspace'. Just trust me on this.
    static let MarksButton = ButtonPress(for: "m") // "m" pretty consistently triggers the "add all marks" functionality in games
    static let SolveButton = ButtonPress(keycode: UI_SOLVE)
    static let UndoButton = ButtonPress(keycode: UI_UNDO)
    static let RedoButton = ButtonPress(keycode: UI_REDO)
}

struct ButtonPress {
    let keycode: Int
    
    init(keycode: Int) {
        self.keycode = keycode
    }
    
    init(for character: Character?) {
        self.keycode = Int(character?.asciiValue ?? 0)
    }
}



class ControlConfig: Hashable {
    static func == (lhs: ControlConfig, rhs: ControlConfig) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(label)
        hasher.combine(imageName)
    }
    
    

    //let image : Image? = nil
    let id = UUID()
    let imageName: String
    let isSystemImage: Bool
    let imageColor: Color
    let label : String
    let displayTextWithIcon: Bool
    let shortPress: MouseClick?
    let longPress: MouseClick?
    var buttonCommand: ButtonPress? // For individual button presses, we fire an integer representing the ASCII value of that character.
    let displayCondition: ConditionalControlFunction
    
    init(label: String, shortPress: MouseClick? = nil, longPress: MouseClick? = nil, command: ButtonPress? = nil, imageName: String = "", isSystemImage: Bool = true, imageColor: Color = .primary, displayTextWithIcon: Bool = false, displayCondition: ConditionalControlFunction? = nil) {
        self.label = label
        self.shortPress = shortPress
        self.longPress = longPress
        self.buttonCommand = command
        self.imageName = imageName
        self.isSystemImage = isSystemImage
        self.displayTextWithIcon = displayTextWithIcon
        self.imageColor = imageColor
        self.displayCondition = displayCondition ?? { _ in true }
    }
    
    func hasImage() -> Bool {
        return !imageName.isEmpty
    }
    
    func buildImage() -> Image {
        guard !imageName.isEmpty else {
            // This _shouldn't_ happen basedon config, but let's return a placeholder image.
            return Image(systemName: "exclamationmark.triangle.fill")
        }
        
        if(isSystemImage) {
            return Image(systemName: imageName)
        } else {
            return Image(imageName)
        }
    }
    
    static var defaultConfig: ControlConfig {
        ControlConfig(label: "Left Click", shortPress: PuzzleKeycodes.leftKeypress, longPress: PuzzleKeycodes.rightKeypress)
    }
}

struct ArrowPress {
    let arrowKey: Int
    let modifier: Int // CTRL, etc.
    
    init(arrowKey: Int, modifier: Int) {
        self.arrowKey = arrowKey
        self.modifier = modifier
    }
}

protocol PuzzleInteraction {
    
}

struct MouseClick: PuzzleInteraction {
    let down: Int
    let drag: Int
    let up: Int
    
    init(down: Int, up: Int, drag: Int) {
        self.down = down
        self.up = up
        self.drag = drag
    }
}
