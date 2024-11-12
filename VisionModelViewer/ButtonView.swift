//
//  ButtonView.swift
//  VisionOsTest
//
//  Created by PwCService IFS-IT Emtech on 04/07/2024.
//

import SwiftUI

// Add model names here
var modelsToLoad: [String] =
[
    "3dPrinter",
    "filmCam",
    "hololens",
    "monitor",
    "Quest",
    "quest2",
    "quest2Box",
    "roboDog"
]

struct blueButton : ButtonStyle
{
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(width: 200, height: 200)
            //.background(Color.blue)
            .glassBackgroundEffect()
            .foregroundStyle(.white)
            .contentShape(RoundedRectangle(cornerRadius: 45))
            .hoverEffect(.highlight)
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

struct ButtonView: View {
    
    @Environment (\.openImmersiveSpace) var OpenImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    @Binding var modelRef: String
    var model: String
    var body: some View {
        VStack{
            NavigationLink(destination: EmptyView())
            {
                Button {
                    modelRef = model
                    Task
                    {
                        
                        await dismissImmersiveSpace()
                        await OpenImmersiveSpace(id: "physics")
                    }
                    
                } label: {
                    Text(model)
                        .font(.largeTitle)
                }
                .buttonStyle(blueButton())
                .frame(width: 200, height: 200)
            }
            .buttonStyle(PlainButtonStyle())


        }
    }
}
