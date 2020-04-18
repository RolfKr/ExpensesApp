//
//  LineChartView.swift
//  ExpensesApp
//
//  Created by Rolf Kristian Andreassen on 18/04/2020.
//  Copyright © 2020 Rolf Kristian Andreassen. All rights reserved.
//

import Foundation
import Charts

class LineChart: LineChartView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    private func configure() {
        backgroundColor = UIColor.systemTeal
        rightAxis.enabled = false
        let yAxix =  self.leftAxis
        yAxix.labelFont = .boldSystemFont(ofSize: 12)
        yAxix.setLabelCount(6, force: false)
        yAxix.labelTextColor = .white
        yAxix.axisLineColor = .white
        yAxix.labelPosition = .outsideChart
        
        xAxis.labelPosition = .bottom
        xAxis.labelTextColor = .white
        xAxis.labelFont = .boldSystemFont(ofSize: 12)
        xAxis.setLabelCount(6, force: false)
        xAxis.axisLineColor = .systemBlue
    }
    
//
//    func createChart(on containerView: UIView) {
//        containerView.addSubview(lineChartView)
//        lineChartView.animate(xAxisDuration: 2.5)
//
//    }
//
//
//    func setData(with data: [Item]) {
//        let set1 = LineChartDataSet(entries: yValues, label: "Subscribers")
//        set1.drawCirclesEnabled = false
//        set1.mode = .cubicBezier
//        set1.lineWidth = 3
//        set1.setColors(.white)
//        set1.fill = Fill(color: .white)
//        set1.fillAlpha = 0.8
//        set1.drawFilledEnabled = true
//
//        let data = LineChartData(dataSet: set1)
//        data.setDrawValues(false)
//        lineChart.data = data
//    }
}
