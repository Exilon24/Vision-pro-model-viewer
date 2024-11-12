//
//  ContentView.swift
//  VisionOsTest
//
//  Created by PwCService IFS-IT Emtech on 02/07/2024.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct noView : View
{
    
    var body: some View
    {
        EmptyView()
            .glassBackgroundEffect()
    }
}

struct BlueButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue)
            .foregroundStyle(.white)
            .hoverEffect(.lift)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            
    }
}

struct ContentView: View {
    
    @Binding var model: String
    
    let layout =
    [
        GridItem(.fixed(200)),
        GridItem(.fixed(200)),
        GridItem(.fixed(200)),
        GridItem(.fixed(200)),
        GridItem(.fixed(200))
    ]
    
    var body: some View
    {
        NavigationStack
        {
            HStack
            {
                Text("Select a model to view")
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                Spacer()
                Image("pwcLogo")
                    .resizable()
                    .frame(width: 100.0, height: 100.0)
            }
            .padding(50)
            LazyVGrid(columns: layout)
            {
                GridRow
                {
                    ForEach(modelsToLoad, id: \.self)
                    { modelEach in
                        ButtonView(modelRef: $model, model: modelEach)
                            .hoverEffect(.lift)
                    }
                }
            }
        }.background(.clear)
    }
}
