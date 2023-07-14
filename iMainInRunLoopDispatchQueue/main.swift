import UIKit

let appDelegateClass: AnyClass = NSClassFromString("TODO:ClassName") ?? NSClassFromString("TODO:ClassName2") ?? AppDelegate.self

UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(appDelegateClass))
