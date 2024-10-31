//
//  ContentView.swift
//  Calc
//
//  Created by found on 29/10/24.
//

import SwiftUI

enum CalcButton: String {
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case zero = "0"
    case add = "+"
    case subtract = "-"
    case divided = "/"
    case multiplied = "x"
    case equal = "="
    case clear = "AC"
    case decimal = "."
    case percent = "%"
    case negative = "-/+"
    
    var buttonColor: Color{
        switch self {
        case .add, .subtract, .multiplied, .divided, .equal:
            return .orange
        case .clear, .negative, .percent:
            return Color(.lightGray)
        default:
            return Color(UIColor(red: 55/255.0, green: 55/255.0, blue: 55/255.0, alpha: 1))
        }
    }
    
}

enum Operation{
    case add, subtract, multiplied, divided, none
}


struct ContentView: View {
    
    @State var currentOperation: Operation = .none
    @State var runningNumber: Float = 0
    @State var value = "0"
    
    let buttons: [[CalcButton]] = [ //Pra inicializar os botoes
        [.clear, .negative, .percent, .divided],
        [.seven, .eight, .nine, .multiplied],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .decimal, .equal]
    ]
    
    var body: some View {
        ZStack{ //é como se fosse um conteiner pra tudo (div)
            Color.black.edgesIgnoringSafeArea(.all) //Define a cor do conteiner e seleciona para ignora
            
            VStack{
                Spacer()
                
                //é uma div dentro da div, um conteiner.
                HStack{
                    //Separacao
                    Spacer() //Deixa o texto no canto da tela
                    Text(value ) //Texto e suas propiedades
                        .bold()
                        .font(.system(size: 100))
                        .foregroundStyle(.white)
                }
                .padding() //Espaco entre canto da tela e o texto
                
                //Para cada botao ele cria ele com um id com seu propio valor e coloca alinhado
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12){
                        ForEach(row,id: \.self) {item in
                            Button(action: {
                                self.didtap(button: item)
                            }, label: {
                                Text(item.rawValue)
                                    .font(.system(size: 32))
                                    .frame(width: self.buttonWidth(item: item), height: self.buttonHeight(item: item))
                                    .background(item.buttonColor)
                                    .foregroundStyle(Color.white)
                                    .addBorder(item.buttonColor, cornerRadius: 35)
                                    
                            })
                        }
                    }
                }.padding(.bottom, 3)
            }
        }
    }
    
    func buttonWidth(item: CalcButton) -> CGFloat {
        if item == .zero{
            return((UIScreen.main.bounds.width - (4*12)) / 4) * 2
        }
        return (UIScreen.main.bounds.width - (5*12)) / 4
    }
    
    func buttonHeight(item: CalcButton) -> CGFloat {
        return (UIScreen.main.bounds.width - (5*12)) / 4
    }
    
    func didtap(button: CalcButton){
        switch button {
            case .add, .subtract, .multiplied, .divided:
                // Armazena o valor atual em `runningNumber` e define a operação atual
            if let currentValue = Float(self.value) {
                    self.runningNumber = currentValue
                    self.value = "0" // Limpa `value` para nova entrada
                }
                
                switch button {
                case .add:
                    self.currentOperation = .add
                case .subtract:
                    self.currentOperation = .subtract
                case .multiplied:
                    self.currentOperation = .multiplied
                case .divided:
                    self.currentOperation = .divided
                default:
                    break
                }

            case .equal:
                // Realiza a operação com `runningNumber` e o valor atual
                let currentValue = Float(self.value) ?? 0
                switch self.currentOperation {
                case .add:
                    self.value = "\(self.runningNumber + currentValue)"
                case .subtract:
                    self.value = "\(self.runningNumber - currentValue)"
                case .multiplied:
                    self.value = "\(self.runningNumber * currentValue)"
                case .divided:
                    if currentValue != 0 {
                        self.value = "\(self.runningNumber / currentValue)"
                    } else {
                        self.value = "Error" // Evita divisão por zero
                    }
                case .none:
                    break
                }
                
                // Redefine operação e runningNumber para o próximo cálculo
                self.currentOperation = .none
                self.runningNumber = 0

            case .clear:
                // Reinicia todos os valores para o estado inicial
                self.value = "0"
                self.runningNumber = 0
                self.currentOperation = .none

        case .decimal:
            if !self.value.contains(".") {
                self.value += "."
            }
            
        case .percent:
            if let currentValue = Float(self.value){
                let percentValue = currentValue / 100
                self.value = percentValue.truncatingRemainder(dividingBy: 1) == 0 ? "\(Int(percentValue))" : "\(percentValue)"
            }

            default:
                // Entrada de números
                let number = button.rawValue
                if self.value == "0" {
                    self.value = number
                } else {
                    self.value += number
                }
            }
        }
    
}

extension View {
     public func addBorder<S>(_ content: S, width: CGFloat = 1, cornerRadius: CGFloat) -> some View where S : ShapeStyle {
         let roundedRect = RoundedRectangle(cornerRadius: cornerRadius)
         return clipShape(roundedRect)
              .overlay(roundedRect.strokeBorder(content, lineWidth: width))
     }
 }

#Preview {
    ContentView()
}
