//
//  FirstTechnicalView.swift
//  iOS-UIKit-Finance-App
//
//  Created by Alek Michelson on 6/29/22.
//

import SwiftUI

struct FirstTechnicalViewFlippingView: View {
    @State var backDegree = 0.0
    @State var frontDegree = -90.0
    @State var isFlipped = false
    
    let durationAndDelay: CGFloat = 0.2
    
    func flipCard () {
        isFlipped = !isFlipped
        if isFlipped {
            withAnimation(.linear(duration: durationAndDelay)) {
                backDegree = 90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)){
                frontDegree = 0
            }
        } else {
            withAnimation(.linear(duration: durationAndDelay)) {
                frontDegree = -90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)){
                backDegree = 0
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color(UIColor.secondarySystemBackground)
            FirstTechnicalBack(degree: $frontDegree)
            FirstTechnicalFront(degree: $backDegree)
        }
        
        .onTapGesture {
            flipCard()
        }
    }
    
}

struct FirstTechnicalView: View {
    
    var body: some View {
        Section(content: { FirstTechnicalViewFlippingView().foregroundColor(Color.black) })
            .frame(width: UIScreen.main.bounds.size.width, height: 300, alignment: .leading)
    }
}

struct FirstTechnicalFront: View {
//    var title: String
//    var iconSystemName: String
//    var DataView: AnyView
//    var viewModel: AnyClass
    
    @StateObject var viewModel = CompanyTechnicalDataViewModel()
    @Binding var degree: Double
    
    var body: some View {
        
        Form {
            HStack {
                Text("Technical Data")
                    .font(.headline)
                
                Spacer()
                
                Image(systemName: "info.circle")
                    .imageScale(.large)
            }.listRowBackground(Color(UIColor.green))
            VStack(alignment: .leading) {
                
                switch viewModel.state {
                case .loaded:
                    if let stats = viewModel.stats {
                        FirstTechnicalDataView(stats: stats)
                    }
                case .error(let error):
                    Text(error)
                case .empty(let empty):
                    Text(empty)
                default:
                    Text("Loading...")
                }
                
            }.onAppear(perform: { viewModel.load() })
            .listRowBackground(Color(UIColor(red: 0.4, green: 0.8, blue: 0.5, alpha: 1)))
        }.rotation3DEffect(Angle(degrees: degree), axis: (x: 1, y: 0, z: 0))
    }
}

struct FirstTechnicalDataView: View {
    let stats: Stats
    
    var body: some View {
        
        if let beta = stats.beta, let EBITDA = stats.EBITDA {
            Text(String(describing: "beta: \(beta), EBITDA: \(EBITDA)"))
        }
        
        if let totalCash = stats.totalCash, let currentDebt = stats.currentDebt {
            Text(String(describing: "totalCash: \(totalCash), currentDebt: \(currentDebt)"))
        }
        
        if let revenue = stats.revenue, let grossProfit = stats.grossProfit {
            Text(String(describing: "revenue: \(revenue), grossProfit: \(grossProfit)"))
        }
        
        if let revenuePerShare = stats.revenuePerShare, let revenuePerEmployee = stats.revenuePerEmployee {
            Text(String(describing: "revenuePerShare: \(revenuePerShare), revenuePerEmployee: \(revenuePerEmployee)"))
        }
        
        if let debtToEquity = stats.debtToEquity, let profitMargin = stats.profitMargin {
            Text(String(describing: "debtToEquity: \(debtToEquity), profitMargin: \(profitMargin)"))
        }

        
        
    }
}


struct FirstTechnicalBack: View {
    @Binding var degree: Double
    
    var body: some View {
        
        Form {
            Label("Technical Data", systemImage: "info.circle.fill")
                .font(.title3)
                .padding(.horizontal)
            Text("Technical Data")
            Button(action: {}, label:{ Link("Learn more", destination: URL(string: "https://www.investopedia.com/terms/p/pricetarget.asp#:~:text=A%20price%20target%20is%20a,the%20stock%20price%20to%20rise.")!)})
        }

        .rotation3DEffect(Angle(degrees: degree), axis: (x: 1, y: 0, z: 0))
    }
}

struct CompanyTechnicalData_Previews: PreviewProvider {
    static var previews: some View {
        FirstTechnicalView()
    }
}
