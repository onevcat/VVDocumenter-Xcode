# VVDocumenter-Xcode
---

## What is this?

Writing document is so important for developing, but it is really painful with Xcode. Think about how much time you are wasting in pressing '*' or '/', and typing the parameters again and again. Now, you can find the method (or any code) you want to document to, and type in `///`, the document will be generated for you and all params and return will be extracted into a beatiful Javadoc style. You can just fill the inline placeholders to finish your document。

Here is an image which can show what it exactly does.

![Screenshot](https://raw.github.com/onevcat/VVDocumenter-Xcode/master/ScreenShot.gif)

## How to use it?

Build the `VVDocumenter-Xcode` target in the Xcode project and the plug-in will automatically be installed in `~/Library/Application Support/Developer/Shared/Xcode/Plug-ins`. Relaunch Xcode and type in `///` above any code you want to write a document to.

## Xcode version?

This plug-in is developed and tested in Mac OSX 10.8.5 Xcode 4.6.3. It should work in all versions of Xcode 4. If you want to use it in Xcode 5 (DP3 or above), you have to make a liittle change in the plist. This is all what I can say now under the NDA.

The default deployment target is 10.8. If you want to use it in a earlier OS version, you should change OS X Deployment Target (in project info setting) to your system version.

## Limitations

The plugin is using simulation of keyboard event to insert the doc comments for you. So it is depending the keyboard shortcut of Xcode. These two kinds of operation are being used:

* Delete to Beginning of the Line (⌘⌫)
* Paste (⌘V)

If you have modified these two shortcuts in your Xcode, the newset version of the plugin would not work correctly. Instead, you can use a earlier version such as [this one(commit 03c4169ff7)](https://github.com/onevcat/VVDocumenter-Xcode/tree/03c4169ff79b618b9fd3db93dd96652a522ad3e0). Be causion you may suffer a [undo and redo issue ](https://github.com/onevcat/VVDocumenter-Xcode/issues/3).

And there are a set of code type I hope to support, but now I just finished some of them.

* Objc Method (Done)
* C Function (Done)
* Macro (Done)
* Property (Done)
* Variable (Done)
* Enum (To do)
* Struct (To do)
* Union (To do)

Now the docs for to-do types will be generated only with a basic description (which is the same as Property and Variable).

## License

VVDocumenter is published under MIT License

    Copyright (c) 2013 Wei Wang (@onevcat)
    
    Permission is hereby granted, free of charge, to any person obtaining a copy of
    this software and associated documentation files (the "Software"), to deal in
    the Software without restriction, including without limitation the rights to use,
    copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
    Software, and to permit persons to whom the Software is furnished to do so,
    subject to the following conditions:
    
    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.
    
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
    FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
    COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
    IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
