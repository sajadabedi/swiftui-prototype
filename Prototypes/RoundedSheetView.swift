//
//  RoundedSheetView.swift
//  Prototypes
//
//  Created by Sajjad Abedi on 11.12.2024.
//

import SwiftUI

struct RoundedSheetView: View {
    @State private var showModal = false
    let favoriteMovies = ["Star Wars", "The Matrix", "Interstellar", "The Dark Knight", "The Avengers", "The Lion King", "The Incredibles", "The Lion King"]
    var body: some View {
        Button("Show Modal") {
            showModal.toggle()
        }
        .sheet(isPresented: $showModal) {
            VStack {
                Text("Favorite Movies")
                .font(.title)
                
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding()
                // List(favoriteMovies, id: \.self) {
                //     Text($0)
                // }
            }
            .presentationDetents([.medium, .large])
            .presentationCornerRadius(40)
        }
    }
}

#Preview {
    RoundedSheetView()
}
