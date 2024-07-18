//
//  DatePickerVC.swift
//  ByahtColor
//
//  Created by jaem on 3/15/24.
//

import UIKit
import SnapKit

class DatePickerVC: UIViewController {
    var onStartDateSelected: ((_ startDate: Date) -> Void)?
    var onEndDateSelected: ((_ endDate: Date) -> Void)?

    private var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .inline
        }
        return datePicker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupDatePicker()
    }

    private func setupDatePicker() {
        view.addSubview(datePicker)

        datePicker.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        // 첫 번째 상태에서는 "다음"을 표시하고, 클릭 시 selectStartDate 함수를 호출합니다.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "다음", style: .plain, target: self, action: #selector(selectStartDate))
    }

    @objc private func selectStartDate() {
        let startDate = datePicker.date
        onStartDateSelected?(startDate)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(selectEndDate))
        datePicker.minimumDate = startDate // Ensure end date is after start date
    }

    @objc private func selectEndDate() {
        let endDate = datePicker.date
        onEndDateSelected?(endDate)
        dismiss(animated: true, completion: nil)
    }
}
