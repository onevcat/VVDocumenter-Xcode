# VVDocumenter-Xcode [![Build Status](https://api.travis-ci.org/onevcat/VVDocumenter-Xcode.svg)](https://travis-ci.org/onevcat/VVDocumenter-Xcode) <a href="https://flattr.com/submit/auto?user_id=onevcat&url=https%3A%2F%2Fgithub.com%2Fonevcat%2FVVDocumenter-Xcode" target="_blank"><img src="http://api.flattr.com/button/flattr-badge-large.png" alt="Flattr this" title="Flattr this" border="0"></a>
---

## What is this?

Writing document is so important for developing, but it is really painful with Xcode. Think about how much time you are wasting in pressing '*' or '/', and typing the parameters again and again. Now, you can find the method (or any code) you want to document to, and type in `///`, the document will be generated for you and all params and return will be extracted into a Javadoc style, which is compatible with [appledoc](https://github.com/tomaz/appledoc), [Doxygen](http://www.stack.nl/~dimitri/doxygen/) and [HeaderDoc](https://developer.apple.com/library/mac/documentation/DeveloperTools/Conceptual/HeaderDoc/intro/intro.html). You can just fill the inline placeholder tokens to finish your document.

Here is an image which can show what it exactly does. 

![Screenshot](https://raw.github.com/onevcat/VVDocumenter-Xcode/master/ScreenShot.gif)

> By the way, it also supports [Swift](https://developer.apple.com/swift/) now. Cheers!

![Screenshot](https://raw.github.com/onevcat/VVDocumenter-Xcode/master/vvdocumenter-swift.gif)

## How to install and use?

The best way of installing is by [Alcatraz](http://alcatraz.io). Install Alcatraz followed by the instruction, restart your Xcode and press `⇧⌘9`. You can find `VVDocumenter-Xcode` in the list and click the icon on left to install.

If you do not like the Alcatraz way, you can also clone the repo. Then build the `VVDocumenter-Xcode` target in the Xcode project and the plug-in will automatically be installed in `~/Library/Application Support/Developer/Shared/Xcode/Plug-ins`. Relaunch Xcode and type in `///` above any code you want to write a document to.

If you want to use other text beside of `///` to trigger the document insertion, you can find a setting panel by clicking `VVDocument` in the Window menu of Xcode. You can also find some other useful options there, including setting using spaces instead of tab in the panel or changing the format of generated documentation.

## Xcode version?

This plug-in is supported in Xcode 5, 6 and 7. From Xcode 5, Apple added a UUID-verification to all plugins to ensure the stability when Xcode gets updated. The value of `DVTPlugInCompatibilityUUIDs` in project plist should contains current UUID of Xcode version, or the plugin does not work. And from Xcode 6.3, you will be prompt to "Load third party bundle" if you are using a plugin. You should always select "Load bundles" to enable this plugin.

All plugins will be disabled once you update your Xcode, since the supported UUIDs in the plugins do not contain the one. You should try to clean your plugins folder (`~/Library/Application Support/Developer/Shared/Xcode/Plug-ins` by default) and clone/build the latest version from master branch. If you happened to skip the bundle loading, you can use this to reset the prompt:

```bash
defaults delete com.apple.dt.Xcode DVTPlugInManagerNonApplePlugIns-Xcode-{your_xcode_version}
```

**Please do not open an issue if this plugin not work in your newly updated Xcode.** Pull request for new `DVTPlugInCompatibilityUUIDs` is welcome, and if UUID of your Xcode version is already there, please try to reinstall the plugin from a clean state.

The default deployment target is 10.8. If you want to use it in a earlier OS version, you should change OS X Deployment Target (in project info setting) to your system version.

## Swift Support

Yes, this plugin supports documentation for Swift 2 now. Check [this post](http://ericasadun.com/2015/06/14/swift-header-documentation-in-xcode-7/) to see how to write the documentation for swift. By using `VVDocumenter-Xcode`, you can just type `///` to make the magic happen.

The documentation format changed from Swift 1.x to 2. If you are using Swift 1.x, you could build from branch [Xcode6](https://github.com/onevcat/VVDocumenter-Xcode/tree/Xcode6) to get the support for the earlier format.

## Limitations and Future

The plugin is using simulation of keyboard event to insert the doc comments for you. So it is depending the keyboard shortcut of Xcode. These two kinds of operation are being used:

* Delete to Beginning of the Line (⌘⌫)
* Paste (⌘V)

If you have modified these two shortcuts in your Xcode, the newset version of the plugin would not work correctly. Instead, you can use a earlier version such as [this one(commit 03c4169ff7)](https://github.com/onevcat/VVDocumenter-Xcode/tree/03c4169ff79b618b9fd3db93dd96652a522ad3e0). Be causion you may suffer an [undo and redo issue ](https://github.com/onevcat/VVDocumenter-Xcode/issues/3).

`VVDocumenter-Xcode` is now using regular expression to extract things needed, which is not the best way to do such thing. A better approach could be using the AST, and I also have a plan to do it later if I have some more time :)

## License

VVDocumenter is published under MIT License. See the LICENSE file for more.
