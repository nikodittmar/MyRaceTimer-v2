//
//  NumberPadView.swift
//  MyRaceTimer
//
//  Created by Niko Dittmar on 12/25/23.
//

import SwiftUI

struct NumberPadView: View {
    var onInputDigit: (Int) -> Void
    var onBackspace: () -> Void
    var onDelete: () -> Void
    
    @State var presentingDeleteWarning: Bool = false
    
    var body: some View {
        VStack(spacing: -1) {
            HStack(spacing: -1) {
                Button { self.onInputDigit(1) } label: { Text("1").NumPadButtonStyle() }.accessibilityLabel("One")
                Button { self.onInputDigit(2) } label: { Text("2").NumPadButtonStyle() }.accessibilityLabel("Two")
                Button { self.onInputDigit(3) } label: { Text("3").NumPadButtonStyle() }.accessibilityLabel("Three")
            }
            HStack(spacing: -1) {
                Button { self.onInputDigit(4) } label: { Text("4").NumPadButtonStyle() }.accessibilityLabel("Four")
                Button { self.onInputDigit(5) } label: { Text("5").NumPadButtonStyle() }.accessibilityLabel("Five")
                Button { self.onInputDigit(6) } label: { Text("6").NumPadButtonStyle() }.accessibilityLabel("Six")
            }
            HStack(spacing: -1) {
                Button { self.onInputDigit(7) } label: { Text("7").NumPadButtonStyle() }.accessibilityLabel("Seven")
                Button { self.onInputDigit(8) } label: { Text("8").NumPadButtonStyle() }.accessibilityLabel("Eight")
                Button { self.onInputDigit(9) } label: { Text("9").NumPadButtonStyle() }.accessibilityLabel("Nine")
            }
            HStack(spacing: -1) {
                Button { presentingDeleteWarning = true } label: { Image(systemName: "trash").NumPadButtonStyle(destructive: true) }
                    .alert("Are you sure you want to delete this recording?", isPresented: $presentingDeleteWarning, actions: {
                        Button("No", role: .cancel, action: {})
                        Button("Yes", role: .destructive, action: {
                            self.onDelete()
                        })
                    }, message: {
                        Text("This cannot be undone.")
                    })
                    .accessibilityLabel("Trash")
                Button { self.onInputDigit(0) } label: { Text("0").NumPadButtonStyle() }.accessibilityLabel("Zero")
                Button { self.onBackspace() } label: { Image(systemName: "delete.left").NumPadButtonStyle(destructive: false) }.accessibilityLabel("Backspace")
            }
        }
    }
}

struct NumberPadButton: ViewModifier {
    
    var destructive: Bool = false
    
    func body(content: Content) -> some View {
        if destructive {
            content
                .font(.title)
                .foregroundColor(.red)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .border(Color(UIColor.systemGray4))
                .background(Color(UIColor.systemGray6))
        } else {
            content
                .font(.title)
                .foregroundColor(Color(UIColor.label))
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .border(Color(UIColor.systemGray4))
                .background(Color(UIColor.systemGray6))
        }
    }
}

extension Text {
    func NumPadButtonStyle() -> some View {
        modifier(NumberPadButton(destructive: false))
    }
}

extension Image {
    func NumPadButtonStyle(destructive: Bool) -> some View {
        modifier(NumberPadButton(destructive: destructive))
    }
}
