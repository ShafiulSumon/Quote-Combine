//
//  TestView.swift
//  Quote-Combine
//
//  Created by ShafiulAlam-00058 on 4/17/23.
//

import SwiftUI

struct User: Codable, Hashable {
    let name: String
}

class ViewModel: ObservableObject {
    @Published var userArray: [User] = []
    
    func getUser() async -> [User] {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
            return []
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let userData = try JSONDecoder().decode([User].self, from: data)
            DispatchQueue.main.async {
                self.userArray = userData
            }
            return userData
        }
        catch {
            print(error)
        }
        return []
    }
}

struct TestView: View {
    
    @StateObject var vm = ViewModel()
    @State var array: [User] = []
    
    var body: some View {
        List(array, id: \.self) { data in
            Text(data.name)
        }
        .onAppear() {
            Task {
                array = await vm.getUser()
            }
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
