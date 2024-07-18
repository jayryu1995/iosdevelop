//
//  BeautyVC.swift
//  ByahtColor
//
//  Created by jaem on 2024/01/12.
//
import UIKit
import Alamofire
import SnapKit
import Combine

class TalkVC: UIViewController {

    private var viewModel = TalkViewModel()
    private var cancellables = Set<AnyCancellable>()
    private var loadingIndicator: UIActivityIndicatorView?
    private let tableView = UITableView()
    private var isLoadingData = false

    private let textView: UILabel = {
        let tv = UILabel()
        tv.text = "Talk"
        tv.textAlignment = .center
        tv.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        return tv
    }()

    private let layer: UIView = {
        let layer = UIView()
        layer.backgroundColor = UIColor.black
        return layer
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBindings()
        viewModel.fetchTalk()
    }

    private func setupView() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = .white
        setupTopView()
        setupTableView()
        setupButton()
        setupLoadingIndicator()
    }

    private func setupTopView() {
        view.addSubview(textView)
        view.addSubview(layer)

        textView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview().offset(20)
            $0.width.equalTo(60)
            $0.height.equalTo(40)
        }

        layer.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom)
            $0.leading.trailing.equalTo(textView)
            $0.height.equalTo(1)
        }
    }

    private func setupButton() {
        let button = UIButton()
        button.setTitle("Write", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
        button.setImage(UIImage(named: "pen_icon"), for: .normal)
        button.setTitleColor(.white, for: .normal)

        let spacing: CGFloat = 5
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: 0)
        button.backgroundColor = .black
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        view.addSubview(button)

        button.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
            make.width.equalTo(90)
        }
    }

    @objc private func buttonAction() {
        let vc = TalkWriteVC()
        navigationController?.pushViewController(vc, animated: true)
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TalkTableCell.self, forCellReuseIdentifier: "TalkTableCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        view.addSubview(tableView)

        tableView.snp.makeConstraints {
            $0.top.equalTo(layer.snp.bottom).offset(10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }

    private func setupLoadingIndicator() {
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator?.center = self.view.center
        view.addSubview(loadingIndicator!)

        loadingIndicator?.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func setupBindings() {
        viewModel.$results
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.loadingIndicator?.startAnimating()
                } else {
                    self?.loadingIndicator?.stopAnimating()
                }
            }
            .store(in: &cancellables)
    }
}

extension TalkVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.results.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TalkTableCell", for: indexPath) as! TalkTableCell
        cell.selectionStyle = .none

        let index = indexPath.row
        let talk = viewModel.results[index]
        cell.configure(with: talk)
        if let path = talk.imageList?.first {
            cell.setImage(imagePath: path)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let selectedData = viewModel.results[indexPath.row]
        let detailVC = TalkReadVC()

        detailVC.board = selectedData
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
