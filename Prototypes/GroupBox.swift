//
//  GroupBox.swift
//  Prototypes
//
//  Created by Sajjad Abedi on 24.12.2024.
//

import SwiftUI

struct GroupBoxView: View {
    var body: some View {
        VStack {
            GroupBox(label: Label("Hello, world!", systemImage: "globe")) {
                Text("Hello, world!")
            }.groupBoxStyle(.customCard)

        }.padding()
    }
}


struct CustomCard: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading, spacing: 8){
            configuration.label
                .font(.caption)
                .fontWeight(.semibold)
                .fontDesign(.monospaced)
                .foregroundColor(.pink)
            
            configuration.content
        }
        .padding()
        .background(.thinMaterial).cornerRadius(20).shadow(radius: 0.5)
        
    }
}

extension GroupBoxStyle where Self == CustomCard {
    static var customCard: CustomCard { CustomCard() }
}

#Preview {
    GroupBoxView()
}
