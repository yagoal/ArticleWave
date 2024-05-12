//
//  ArticleViewRepresentable.swift
//  ArticleWave
//
//  Created by Yago Pereira on 11/5/24.
//

import SwiftUI

struct ArticleViewRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = ArticlesViewController

    func makeUIViewController(context: Context) -> ArticlesViewController {
        return ArticlesViewController()
    }

    func updateUIViewController(_ uiViewController: ArticlesViewController, context: Context) {
        // Atualize a view controller se necessário, por exemplo, passando novos dados
    }
}

struct ArticlesScreen: View {
    var body: some View {
            VStack {
                Text("Latest Articles")
                    .font(.largeTitle)
                    .padding(.top, 20)
                
                Text("All the latest news from around the world.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding([.top, .bottom], 10)

                ArticleViewRepresentable()
                    .frame(height: 600)
                
                Spacer()
            }
            .padding()
        .navigationTitle("News")
        .navigationBarTitleDisplayMode(.inline)
    }
}
