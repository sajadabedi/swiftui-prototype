//
//  ShockWave.swift
//  Prototypes
//
//  Created by Sajjad Abedi on 09.05.2025.
//

import SwiftUI

fileprivate enum CellAnimationPhase: CaseIterable {
    case identity
    case compress
    case expand
    
    var scaleAdjustment: CGFloat {
        switch self {
        case .identity:
            return 0.0
        case .compress:
            return -0.25
        case .expand:
            return 0.2
        }
        
    }
    
    var brightnessAdjustment: Double {
        switch self {
        case .identity:
            return 0.0
        case .compress:
            return -0.2
        case .expand:
            return 0.1
        }
    }
}


fileprivate func calculateDistance(point1: CGPoint, point2: CGPoint) -> Double {
    return hypot(point2.x - point1.x, point2.y - point1.y)
}
    

fileprivate let CELL_SIZE = 18.0
fileprivate let CELL_SPACING = 8.0
fileprivate let COLUMN_COUNT = 12
fileprivate let ROW_COUNT = 11
fileprivate let MAX_GRID_DISTANCE = calculateDistance(
    point1: .init(x: 0, y:0),
    point2: .init(x: COLUMN_COUNT - 1, y: ROW_COUNT - 1)
)

struct ShockWave: View {
    @State private var trigger: Int = 0
    @State private var waveOrigin: CGPoint = .zero
    
    var body: some View {
        VStack(spacing: CELL_SPACING) {
            ForEach(0..<ROW_COUNT, id: \.self) { rowIndex in
                HStack {
                    ForEach(0..<COLUMN_COUNT, id: \.self) { columnIndex in
                        let cellCoordinate = CGPoint(x: Double(columnIndex), y: Double(rowIndex))
                        let distance = calculateDistance(
                            point1: waveOrigin,
                            point2: cellCoordinate
                        )
                        let distanceNormalized = Double(
                            columnIndex
                        ) / MAX_GRID_DISTANCE
                        let waveImpact = 1.0 - distanceNormalized
                        
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.pink)
                            .frame(width: CELL_SIZE, height: CELL_SIZE)
                            .phaseAnimator(CellAnimationPhase.allCases, trigger: trigger) { content, phase in
                                content
                                    .scaleEffect(1 + phase.scaleAdjustment * waveImpact)
                                    .brightness(phase.brightnessAdjustment * waveImpact)
                                    
                                    
                                
                            } animation: { phase in
                                switch phase {
                                case .identity:
                                    return .bouncy(duration: 0.4, extraBounce: 0.35)
                                case .compress:
                                    return .smooth(duration: 0.2).delay(distance * 0.07)
                                case .expand:
                                    return .smooth(duration: 0.1)
                                }
                            }
                            .onTapGesture {
                                waveOrigin = cellCoordinate
                                trigger += 1
                            }
                    }
                    
                }
            }
            
        }
        
        
    }
    
}

#Preview {
    ShockWave()
}
