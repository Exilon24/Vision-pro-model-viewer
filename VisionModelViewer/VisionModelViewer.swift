//
//  VisionOsTest.swift
//  VisionOsTest
//
//  Created by PwCService IFS-IT Emtech on 05/07/2024.
//

import Foundation
import SwiftUI

@main
struct VisionModelViewer : App
{
    
    @State var modelToLoad: String = ""
    var body: some Scene
    {
        WindowGroup
        {
            ContentView(model: $modelToLoad)
        }
        
        ImmersiveSpace(id: "physics")
        {
            ModelView(modelName: modelToLoad)
        }
    }
}
