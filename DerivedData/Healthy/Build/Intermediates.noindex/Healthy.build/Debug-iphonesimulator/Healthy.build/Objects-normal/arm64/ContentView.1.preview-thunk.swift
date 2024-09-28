import func SwiftUI.__designTimeFloat
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeInteger
import func SwiftUI.__designTimeBoolean

#sourceLocation(file: "/Users/ianzhang/Desktop/Personal Coding Projects/Healthy/Healthy/ContentView.swift", line: 1)
//
//  ContentView.swift
//  Healthy
//
//  Created by Ian Zhang on 9/28/24.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @State private var isShowingCamera = false
    @State private var image: UIImage? = nil
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                ProjectName(name: __designTimeString("#803_0", fallback: "Healthy"))
                Spacer()
                
                // Display captured image if available
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: __designTimeInteger("#803_1", fallback: 200), height: __designTimeInteger("#803_2", fallback: 200))
                } else {
                    Image(__designTimeString("#803_3", fallback: "medicinebottle"))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: __designTimeInteger("#803_4", fallback: 200), height: __designTimeInteger("#803_5", fallback: 200))
                }
                
                HStack {
                    Button(action: {
                        isShowingCamera = __designTimeBoolean("#803_6", fallback: true) // Show camera when the Scan button is pressed
                    }) {
                        ScanButton(title: __designTimeString("#803_7", fallback: "Scan"), textColor: .white, backgroundColor: .mint)
                    }
                    .padding(__designTimeInteger("#803_8", fallback: 10))
                    .fullScreenCover(isPresented: $isShowingCamera) {
                        ImagePicker(sourceType: .camera, selectedImage: $image).ignoresSafeArea()
                    }

                    
                    Button {
                        // Handle Db1 action
                    } label: {
                        ScanButton(title: __designTimeString("#803_9", fallback: "Db1"), textColor: .white, backgroundColor: .mint)
                    }
                    .padding(__designTimeInteger("#803_10", fallback: 10))
                    
                    Button {
                        // Handle Db2 action
                    } label: {
                        ScanButton(title: __designTimeString("#803_11", fallback: "Db2"), textColor: .white, backgroundColor: .mint)
                    }
                    .padding(__designTimeInteger("#803_12", fallback: 10))
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
            .frame(width: __designTimeInteger("#803_13", fallback: 100), height: __designTimeInteger("#803_14", fallback: 50))
            .background(backgroundColor)
            .foregroundColor(textColor)
            .font(.system(size: __designTimeInteger("#803_15", fallback: 20), weight: .bold, design: .default))
            .cornerRadius(__designTimeInteger("#803_16", fallback: 20))
    }
}

struct ProjectName: View {
    var name: String
    var body: some View {
        Text(name)
            .font(.system(size: __designTimeInteger("#803_17", fallback: 32), weight: .medium, design: .default))
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

// ImagePicker implementation remains unchanged
struct ImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType
    @Binding var selectedImage: UIImage?
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            picker.dismiss(animated: __designTimeBoolean("#803_18", fallback: true))
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
