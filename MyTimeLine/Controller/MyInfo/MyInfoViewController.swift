//
//  MyInfoViewController.swift
//  MyTimeLine
//
//  Created by Hans Jiang on 2018/3/7.
//  Copyright © 2018年 Hans Jiang. All rights reserved.
//

import UIKit
import Charts

class MyInfoViewController: UIViewController, IAxisValueFormatter {

    let activities = ["肥胖", "智慧", "胃", "肉麻", "愛妮"]
    @IBOutlet weak var MyImageView: UIImageView!
    @IBOutlet weak var RadarChart: RadarChartView!
    
    @IBAction func backPressed(_ sender: Any) {
     self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RadarChart.delegate = self as? ChartViewDelegate
        setChart()
        RadarChart.chartDescription?.enabled = false
        let xAxis = RadarChart.xAxis
        xAxis.labelFont = .systemFont(ofSize: 14, weight: .light)
        xAxis.xOffset = 0
        xAxis.yOffset = 0
        xAxis.valueFormatter = self
        xAxis.labelTextColor = .black
        
        let yAxis = RadarChart.yAxis
        yAxis.labelFont = .systemFont(ofSize: 8, weight: .light)
        yAxis.labelCount = 5
        yAxis.axisMinimum = 0
        yAxis.axisMaximum = 180
        yAxis.drawLabelsEnabled = false
        RadarChart.animate(xAxisDuration: 1.4, yAxisDuration: 1.4, easingOption: .easeOutBack)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setChart() {
        //let activities = ["肥胖", "智慧", "胃", "肉麻", "愛妮"]
        let ChartDataEntry1 = ChartDataEntry.init(x: 0, y: 100)
        let ChartDataEntry2 = ChartDataEntry.init(x: 0, y: 110)
        let ChartDataEntry3 = ChartDataEntry.init(x: 0, y: 20)
        let ChartDataEntry4 = ChartDataEntry.init(x: 0, y: 110)
        let ChartDataEntry5 = ChartDataEntry.init(x: 0, y: 240)
        let entry: [ChartDataEntry]? =  [ChartDataEntry1,
                                         ChartDataEntry2,
                                         ChartDataEntry3,
                                         ChartDataEntry4,
                                         ChartDataEntry5]
        
        let RCset = RadarChartDataSet(values: entry, label: "HansJiang 的能力值")
        RCset.setColor(UIColor(red: 121/255, green: 162/255, blue: 175/255, alpha: 1))
        RCset.fillColor = UIColor(red: 121/255, green: 162/255, blue: 175/255, alpha: 1)
        RCset.drawFilledEnabled = true
        RCset.fillAlpha = 0.4
        RCset.lineWidth = 1
        RCset.drawHighlightCircleEnabled = true
        RCset.setDrawHighlightIndicators(false)
        
        let data = RadarChartData(dataSets: [RCset])
        data.setValueFont(.systemFont(ofSize: 8, weight: .light))
        data.setDrawValues(false)
        data.setValueTextColor(.white)
        RadarChart.data = data
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return activities[Int(value) % activities.count]
    }
}


