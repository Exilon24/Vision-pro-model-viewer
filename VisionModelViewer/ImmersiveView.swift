//
//  ImmersiveView.swift
//  VisionOsTest
//
//  Created by PwCService IFS-IT Emtech on 02/07/2024.
//

import Foundation
import SwiftUI
import RealityKit
import RealityKitContent

struct ModelView : View {
    
    var modelName: String
    
    @State var EntityRef: Entity = Entity()
    @GestureState var magnifyBy = 1.0
    @State var mag: Float = 1
    
    
    @State var lastMag: Float = 0.002
    @State var lastRot: simd_quatf = simd_quatf(angle: .zero, axis: .zero)
    @State var lastPos: simd_float3 = simd_float3()
    
    var dragGesture : some Gesture
    {
        DragGesture(coordinateSpace: .local)
            .targetedToAnyEntity()
            .onChanged
        { value in
            EntityRef.position = value.convert(value.location3D, from: .local, to: EntityRef.parent!)
        }
        .onEnded
        { _ in
            lastPos = EntityRef.position
        }
    }
      
    var magnify : some Gesture{
        MagnifyGesture().updating($magnifyBy) { value, getsState, transaction in
            getsState = value.magnification
        }
        .onChanged
        { value in
            let mag = Float(magnifyBy) * lastMag
            EntityRef.transform.scale = simd_float3(repeating: mag)
        }
        .onEnded
        { _ in
            lastMag = EntityRef.scale.x
        }
    }
    
    var rotate: some Gesture {
        RotateGesture3D(constrainedToAxis: RotationAxis3D(x: 0, y: 1, z: 0))
            .targetedToEntity(EntityRef)
            .onChanged { value in
                
                let dAxis = RotationAxis3D(
                    x: value.rotation.axis.x * -1,
                    y: value.rotation.axis.y * 1,
                    z: value.rotation.axis.z * -1)
                
                let dRot = Rotation3D(angle: value.rotation.angle, axis: dAxis)
                EntityRef.transform.rotation = lastRot * simd_quatf(dRot)
            }
            .onEnded
        { _ in
            lastRot = EntityRef.transform.rotation
        }
    }
    
    var body: some View
    {
        RealityView
        { content in
            do
            {
                
                let plane: ModelEntity = ModelEntity(mesh: .generatePlane(width: 40, depth: 40), materials: [OcclusionMaterial()])
                plane.generateCollisionShapes(recursive: false)
                plane.physicsBody = PhysicsBodyComponent(mode: .static)
            
                var parentModel : Entity = try Entity.load(named: modelName, in: realityKitContentBundle)
                if let model =  parentModel.children.first
                {
                    model.generateCollisionShapes(recursive: true)
                    model.components.set(InputTargetComponent(allowedInputTypes: .indirect))
                    model.components.set(HoverEffectComponent())
                    
                    model.transform.scale = SIMD3<Float>(0.002, 0.002, 0.002)
                    model.transform.translation = SIMD3<Float>(0, 1, -1)
          
                    
                    EntityRef = model
                    
                    
                    model.isEnabled = true
                    
                    content.add(EntityRef)
                    content.add(plane)

                }
                else
                {
                    print("No child found :(")
                }
       
            }
            catch
            {
                print ("Couldn't load model: \(error)")
            }
        }
        .gesture(dragGesture).simultaneousGesture(magnify).simultaneousGesture(rotate)
    }
}
