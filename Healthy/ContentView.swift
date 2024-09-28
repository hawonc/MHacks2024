//
//  ContentView.swift
//  Healthy
//
//  Created by Ian Zhang on 9/28/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isShowingCamera = false
    @State private var image: UIImage? = nil
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                ProjectName(name: "Healthy")
                Spacer()
                
                // Display captured image if available
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                } else {
                    Image("medicinebottle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                }
                
                HStack {
                    Button(action: {
                        isShowingCamera = true // Show camera when the Scan button is pressed
                    }) {
                        ScanButton(title: "Scan", textColor: .white, backgroundColor: .mint)
                    }
                    .padding(10)
                    .fullScreenCover(isPresented: $isShowingCamera) {
                        ImagePicker(sourceType: .camera, selectedImage: $image).ignoresSafeArea()
                    }

                    
                    Button {
                        // Handle Db1 action
                    } label: {
                        ScanButton(title: "Db1", textColor: .white, backgroundColor: .mint)
                    }
                    .padding(10)
                    
                    Button {
                        // Handle Db2 action
                    } label: {
                        ScanButton(title: "Db2", textColor: .white, backgroundColor: .mint)
                    }
                    .padding(10)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

struct ScanButton: View {
    var title: String
    var textColor: Color
    var backgroundColor: Color
    var body: some View {
        Text(title)
            .frame(width: 100, height: 50)
            .background(backgroundColor)
            .foregroundColor(textColor)
            .font(.system(size: 20, weight: .bold, design: .default))
            .cornerRadius(20)
    }
}

struct ProjectName: View {
    var name: String
    var body: some View {
        Text(name)
            .font(.system(size: 32, weight: .medium, design: .default))
            .foregroundStyle(.white)
            .padding()
    }
}

struct BackgroundView: View {
    var body: some View {
        ContainerRelativeShape()
            .fill(Color.purple.gradient)
            .ignoresSafeArea()
    }
}
