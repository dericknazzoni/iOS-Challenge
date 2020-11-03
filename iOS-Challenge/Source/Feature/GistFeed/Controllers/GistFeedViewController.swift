//
//  GistFeedContoller.swift
//  iOS-Challenge
//
//  Created by Derick Nazzoni on 29/10/20.
//

import UIKit

class GistFeedViewController: UIViewController, Identifiable {
    
    var gistFiltrados = [GistFeedModel]()
    weak var delegate: GistFeedViewControllerDelegate?
    
    @IBOutlet private weak var reultLabel: UILabel?
    @IBOutlet private weak var searchBar: UISearchBar?
    @IBOutlet private weak var tableView: UITableView?
    @IBOutlet private weak var errorView: UIView?
    
    private var viewModel: GistFeedViewModelProtocol?
    private var searching: Bool = false
    private var dataSource: [GistFeedModel] = []
    private var spinner: UIView = UIView()
    private var currentPage: Int = 0
    private var stopReloading = false
    
    
    static func instatiate(viewModel: GistFeedViewModelProtocol = GistFeedViewModel()) -> GistFeedViewController {
        let controller: GistFeedViewController = UIStoryboard.viewController(from: .GistFeed, bundle: Bundle(for: self))
        controller.viewModel = viewModel
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindElements()
        errorView?.isHidden = true
        registerCells()
        tableView?.delegate = self
        tableView?.dataSource = self
        searchBar?.delegate = self
        title = "All Gist's"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataSource.removeAll()
        viewModel?.fetchGistFeed(page: 0)
    }
    
    @objc func closeKeyboard(){
        self.view.endEditing(true)
    }
    
    func registerCells() {
        self.tableView?.register(GistFeedCell.nib, forCellReuseIdentifier: GistFeedCell.reuseIdentifier)
    }
    private func getFavorites() -> [GistFeedModel] {
        
        let userDefaults = UserDefaults.standard
        var gistList = [GistFeedModel]()
        do {
            gistList = try userDefaults.getObject(forKey: "gistList", castTo: [GistFeedModel].self)
        } catch {
            print(error.localizedDescription)
        }
        return gistList
    }
    
    private func saveFavorite(model: GistFeedModel, image: UIImage) {
        
        var gistList = getFavorites()
        if gistList.contains(where: {$0.id == model.id}) {
            guard let index = gistList.firstIndex(where: {$0.id == model.id}) else { return }
            gistList.remove(at: index)
        } else {
            gistList.append(model)
        }
        let userDefaults = UserDefaults.standard
        do {
            try userDefaults.setObject(gistList, forKey: "gistList")
            _ = String(model.owner?.avatarUrl?.split(separator: "/").last?.split(separator: "?").first ?? "")
            store(image: image, forKey: model.owner?.avatarUrl ?? "")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func store(image: UIImage,
                       forKey key: String) {
        guard let pngRepresentation = image.pngData(), let filePath = filePath(forKey: key) else { return }
        do  {
            try pngRepresentation.write(to: filePath,
                                        options: .atomic)
        } catch let err {
            print("Saving file resulted in error: ", err)
        }
        
    }
    
    private func filePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory,
                                                 in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
        
        return documentURL.appendingPathComponent(key + ".png")
    }
    
    private func sortLists(login: String) -> [GistFeedModel]{
        return dataSource.filter { gist in
            guard let gistLogin = gist.owner?.login else { return false }
            if gistLogin.lowercased().hasPrefix(login.lowercased()) {
                return true
            }
            return false
        }
    }
    
    func bindElements(){
        
        viewModel?.gists.bind(skip: true) { [weak self] gists in
            guard let self = self else { return }
            if gists.isEmpty {
                self.stopReloading = true
            }
            self.dataSource.append(contentsOf: gists)
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
        viewModel?.loading.bind(skip: true) { [weak self] isLoading in
            guard let self = self,
                  let tableView = self.tableView,
                  self.currentPage == 0 else { return }
            DispatchQueue.main.async {
                if isLoading {
                    self.spinner = UIViewController.displaySpinner(onView: tableView)
                    return
                }
                UIViewController.removeSpinner(spinner: self.spinner)
            }
        }
        
        viewModel?.imageLoading.bind(skip: true) { [weak self] imageLoading in
            guard let self = self, let imageLoading = imageLoading else { return }
            DispatchQueue.main.async {
                guard let cell = self.tableView?.cellForRow(at: IndexPath(item: imageLoading.row, section: 0)) as? GistFeedCell else { return }
                if imageLoading.loading {
                    cell.spinner = UIViewController.displaySpinner(onView: cell)
                    return
                }
                UIViewController.removeSpinner(spinner: cell.spinner)
            }
        }
        
        viewModel?.image.bind(skip: true) { [weak self] image in
            guard let self = self, let image = image else { return }
            DispatchQueue.main.async {
                guard let cell = self.tableView?.cellForRow(at: IndexPath(item: image.row, section: 0)) as? GistFeedCell else { return }
                cell.updateImage(image: image.image)
            }
        }
        
                viewModel?.connectionError.bind(skip: true) { [weak self] error in
                    guard let self = self else { return }
                    self.errorView?.isHidden = false
                }
    }
    
}

extension GistFeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard !stopReloading else { return }
        cell.layoutSubviews()
        guard let imageId = dataSource[safe: indexPath.row]?.owner?.avatarUrl else { return }
        viewModel?.fetchImage(forRow: indexPath.row, stringUrl: imageId)
        if indexPath.row == dataSource.count-3 {
            currentPage += 1
            viewModel?.fetchGistFeed(page: currentPage)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let gist = searching
                ? gistFiltrados[safe: indexPath.row]
                : dataSource[safe: indexPath.row] else { return }
        delegate?.wantsToShowDetail(gist: gist)
    }
    
}
extension GistFeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searching ? gistFiltrados.count : dataSource.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GistFeedCell.reuseIdentifier, for: indexPath) as? GistFeedCell,
              let gist = searching ? gistFiltrados[safe: indexPath.row] : dataSource[safe: indexPath.row],
              let name = gist.owner?.login else { return UITableViewCell() }
        cell.setup(image: UIImage(), name: name)
        cell.isFavorite = getFavorites().contains(where: {$0.owner?.login == gist.owner?.login })
        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }
    
}

extension GistFeedViewController: GistFeedCellDelegate {
    
    func didClickFavorite(indexPath: IndexPath?, image: UIImage) {
        guard let indexPath = indexPath else { return }
        saveFavorite(model: dataSource[indexPath.row], image: image)
        tableView?.reloadData()
    }
}

extension GistFeedViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.count == 0 {
            searching = false
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
        
        gistFiltrados = sortLists(login: searchText)
        searching = true
        DispatchQueue.main.async {
            self.tableView?.reloadData()
        }
        
        setupView()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        DispatchQueue.main.async {
            self.tableView?.reloadData()
        }
        
        setupView()
    }
    
    func setupView() {
        if gistFiltrados.count == 0 {
            DispatchQueue.main.async {
                self.tableView?.isHidden = true
                self.reultLabel?.isHidden = false
                self.reultLabel?.text = "Nenhum resultado encontrado"
                self.reultLabel?.textColor = UIColor.gray
                self.reultLabel?.adjustsFontSizeToFitWidth = true
            }
        } else {
            self.reultLabel?.isHidden = true
            self.tableView?.isHidden = false
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        closeKeyboard()
    }
    
}


