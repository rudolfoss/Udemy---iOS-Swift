//
//  ViewController.swift
//  Today
//
//  Created by HA on 2022/07/18.
//

import UIKit

class ReminderListViewController: UICollectionViewController {
    //typealiases are helpful for referring to an existing type with a name that’s more expressive.
    typealias DataSource = UICollectionViewDiffableDataSource<Int, String>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, String>
    
    //Add a dataSource property that implicitly unwraps a DataSource.
    //옵셔널에 값이 있다는 것을 알고 있는 경우에만 암시적으로 래핑되지 않은 옵셔널을 사용할 것. 그렇지 않으면 앱을 즉시 종료하는 런타임 오류가 발생할 위험이 있음. 옵셔널에 값이 있음을 보장하기 위해 다음 단계에서 데이터 소스를 초기화한다.
    var dataSource: DataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //After the view controller loads its view hierarchy into memory, the system calls viewDidLoad().
        let listLayout = listLayout()
        //Assign the list layout to the collection view layout.
        collectionView.collectionViewLayout = listLayout

        //셀 등록은 셀의 내용과 모양을 구성하는 방법을 지정합니다.
        let cellRegistertaion = UICollectionView.CellRegistration{ (cell: UICollectionViewListCell, indexPath: IndexPath, itemIdentifier: String) in
        //Retrieve the reminder corresponding to the item. //retrieve 검색하다.
        let reminder = Reminder.sampleData[indexPath.item]
        //셀의 기본 콘텐츠 구성을 검색.
        var contentConfiguration = cell.defaultContentConfiguration()
        //목록은 구성 텍스트를 셀의 기본 텍스트로 표시합니다.
        contentConfiguration.text = reminder.title
        //셀에 컨텐츠 구성을 지정.
        cell.contentConfiguration = contentConfiguration

        }
        //Create a new data source.
        dataSource = DataSource(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: String) in
            //셀 등록을 사용하여 셀을 큐에서 빼고 반환합니다.
            //모든 항목에 대해 새로운 셀을 만들 수 있지만 초기화 비용으로 인해 앱의 성능이 저하된다. 셀을 재사용하면 앱이 방대한 수의 항목을 사용해도 잘 작동할 수 있다.
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistertaion, for: indexPath, item: itemIdentifier)
            
            //데이터 소스를 만들고 초기화했지만 데이터가 변경되면 데이터 소스에 알려야 함.
        }
        
        var snapshot = Snapshot()
        //Append sections to the snapshot.
        snapshot.appendSections([0])
        //In this situation, map(_:) returns a new array containing only the reminder titles, which populate as items in the snapshot.
        snapshot.appendItems(Reminder.sampleData.map { $0.title })
        //Applying the snapshot reflects the changes in the user interface.
        dataSource.apply(snapshot)
        
        //Assign the data source to the collection view.
        collectionView.dataSource = dataSource

    }

    //투데이 앱은 미리 알림을 목록으로 표시. 미리 정의된 구성을 시작점으로 사용하여 목록이 표시되는 방식을 정의하기 시작.
    
    //UICollectionLayoutListConfiguration creates a section in a list layout.
    private func listLayout() -> UICollectionViewCompositionalLayout{
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        //Disable separators, and change the background color to clear.
        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .clear
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)

    }
}
