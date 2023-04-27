//
//  ContentView.swift
//  Quote-Combine
//
//  Created by ShafiulAlam-00058 on 4/13/23.
//

import SwiftUI
import Combine

struct QuoteView: View {
    
//    @State private var quote: String = "Hello World!!"
//    @State private var author: String = "Hello World!!"
    @State private var cancellable: Set<AnyCancellable> = []
    @StateObject private var vm = QuoteViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Text("Today's Quote")
                    .font(.largeTitle)
                    .foregroundColor(.cyan)
                    .bold()
                    .padding()
                Spacer()
            }
            Spacer()
            
            ZStack {
                if(!vm.spinner) {
                    VStack(spacing: 20) {
                        Text(vm.quote.content)
                            .font(.title)
                        Text("by - \(vm.quote.author)")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    .padding()
                }
                if(vm.spinner) {
                    ProgressView()
                        .progressViewStyle(.automatic)
                        .frame(width: 200, height: 200)
                        .tint(.blue)
                        .contentShape(Rectangle())
                }
            }
            
            
            Spacer()
            
            Button {
                vm.fetchQuote()
            } label: {
                Text("Refresh")
            }
            .font(.title3)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(.cyan)
            .foregroundColor(.white)
            .cornerRadius(8)
            .padding(30)
        }
        .onAppear() {
            vm.fetchQuote()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        QuoteView()
    }
}
