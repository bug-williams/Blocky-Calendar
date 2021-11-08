//
//  TimeBlock.swift
//  Blocky Calendar
//
//  Created by Bug on 4/6/21.
//

import SwiftUI

struct EventBlock: View {
    
    let storageManager = StorageManager.shared
    
    var dataHandlerDelegate: DataHanderDelegate
    
    var isEmpty: Bool = false
    var hasPassed: Bool = false
    var title: String = ""
    var block: Int = 0
    var color: Int = 0
    
    let colors: [Color] = [.pink, .orange, .yellow, .green, .blue, .purple, .gray]
    
    let minimumDragOffset: CGFloat = 80
    @State var dragOffset: CGSize = CGSize.zero
    
    @State var deleteButtonIsVisible: Bool = false
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                Button(action:{
                    dataHandlerDelegate.deleteEvent(offsets: [dataHandlerDelegate.getEventIndexFromBlock(block: block)])
                }, label: {
                    Image(systemName: "trash.fill")
                        .font(.system(size: 17, weight: .bold))
                        .frame(width: abs((deleteButtonIsVisible ? minimumDragOffset - dragOffset.width : -dragOffset.width) - 4), height: 56)
                        .foregroundColor(.white)
                        .background(Color.red)
                        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                })
            }
            .scaleEffect(
                min(max((deleteButtonIsVisible ? minimumDragOffset - dragOffset.width : -dragOffset.width) / minimumDragOffset, 0), 1),
                anchor: .trailing
            )
            HStack(spacing: 16) {
                Text(getEventTimeLabel(block: block))
                    .font(.system(.caption, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                    .frame(width: 52)
                    .padding(.horizontal, -8)
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .frame(height: 56)
                        .foregroundColor(isEmpty || hasPassed ? Color(UIColor.secondarySystemBackground) : colors[color])
                    HStack {
                        if isEmpty {
                            HStack {
                                Spacer()
                                Image(systemName: "plus")
                                    .font(.system(size: 17, weight: .bold))
                                    .foregroundColor(Color(UIColor.tertiaryLabel))
                                Spacer()
                            }
                        } else {
                            Text(title)
                                .font(.system(.headline, design: .rounded))
                                .fontWeight(.semibold)
                                .foregroundColor(hasPassed ? .secondary : .white)
                                .lineLimit(1)
                        }
                    }
                    .padding(.horizontal, 28)
                }
            }
            .offset(isEmpty ? CGSize.zero : dragOffset)
            .offset(x: deleteButtonIsVisible ? -(minimumDragOffset) : 0)
            .simultaneousGesture(
                DragGesture(minimumDistance: 16, coordinateSpace: .global)
                    .onChanged({ gesture in
                        if !isEmpty {
                            withAnimation(.interactiveSpring()) {
                                dragOffset.width = gesture.translation.width
                            }
                        }
                    })
                    .onEnded({ (offset) in
                        withAnimation(.spring()) {
                            if abs(dragOffset.width) < minimumDragOffset || dragOffset.width > 0 || isEmpty  {
                                deleteButtonIsVisible = false
                            } else {
                                deleteButtonIsVisible = true
                            }
                            dragOffset = CGSize.zero
                        }
                    })
            )
        }
    }
    
    // MARK: - Functions
    private func getEventTimeLabel(block: Int) -> String {
        let hour = block / 3
        let minute = 20 * (block % 3)
        
        if minute == 0 { return "\(hour):00" }
        return "\(hour):\(minute)"
    }
    
}
