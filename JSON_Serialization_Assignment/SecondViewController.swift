//
//  SecondViewController.swift
//  JSON_Serialization_Assignment
//
//  Created by Smita Kankayya on 19/12/23.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var todosCollectionView: UICollectionView!
    @IBOutlet weak var commentsCollectionView: UICollectionView!
    
    private let todosCVCellIdentifier = "TodosCollectionViewCell"
    private let commentsCVCellIdentifier = "CommentsCollectionViewCell"
    
    var jsonPlaceHolderTodos : [Todos] = []
    var jsonPlaceHolderComments : [Comments] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeCollectionView()
        registerXIBWithCollectionView()
        todosFetchData()
        commentsFetchData()
        
    }
    
    func initializeCollectionView(){
        todosCollectionView.dataSource = self
        commentsCollectionView.dataSource = self
        todosCollectionView.delegate = self
        commentsCollectionView.delegate = self
    }
    
    func registerXIBWithCollectionView(){
        let uiNib = UINib(nibName: todosCVCellIdentifier, bundle: nil)
        self.todosCollectionView.register(uiNib, forCellWithReuseIdentifier: todosCVCellIdentifier)
        let uiNib1 = UINib(nibName: commentsCVCellIdentifier, bundle: nil)
        self.commentsCollectionView.register(uiNib1, forCellWithReuseIdentifier: commentsCVCellIdentifier)
    }
    
    func todosFetchData(){
        let todosUrl = URL(string: "https://jsonplaceholder.typicode.com/todos")
        var todosUrlRequest = URLRequest(url: todosUrl!)
        todosUrlRequest.httpMethod = "GET"
        
        let todosUrlSession = URLSession(configuration: .default)
        let dataTask = todosUrlSession.dataTask(with: todosUrlRequest) {
            todosData, todosUrlResponse, todosError in
            let todosResponse = try! JSONSerialization.jsonObject(with:todosData!) as! [[String:Any]]
            print(todosResponse)
            
            for eachTodosResponse in todosResponse{
                let todosDictionary = eachTodosResponse as! [String:Any]
                let todosId = todosDictionary["id"] as! Int
                let todosTitle = todosDictionary["title"] as! String
                let todosComleted = todosDictionary["completed"] as! Bool
                
                let todosObject = Todos(id: todosId,title: todosTitle,completed: todosComleted)
                self.jsonPlaceHolderTodos.append(todosObject)
            }
            
            DispatchQueue.main.async {
                self.todosCollectionView.reloadData()
            }
        }
        
        dataTask.resume()
    }
    
    func commentsFetchData(){
        let commentsUrl = URL(string: "https://jsonplaceholder.typicode.com/comments")
        var commentsUrlRequest = URLRequest(url: commentsUrl!)
        commentsUrlRequest.httpMethod = "GET"
        
        let commentsUrlSession = URLSession(configuration: .default)
        let dataTask1 = commentsUrlSession.dataTask(with:commentsUrlRequest) { commentsData, commentsUrlResponse, commentsError in
        let commentsResponse = try! JSONSerialization.jsonObject(with:commentsData!) as! [[String:Any]]
        print(commentsResponse)
            
            for eachCommentsResponse in commentsResponse{
                let commentsDictionary = eachCommentsResponse as!  [String:Any]
                let commentsId = commentsDictionary["id"] as! Int
                let commentsName = commentsDictionary["name"] as! String
                let commentsEmail = commentsDictionary["email"] as! String
                let commentsBody = commentsDictionary["body"] as! String
                
                let commentsObject = Comments(id: commentsId,name: commentsName,email: commentsEmail,body: commentsBody)
                self.jsonPlaceHolderComments.append(commentsObject)
            }
            
            DispatchQueue.main.async {
                self.commentsCollectionView.reloadData()
            }
        }
        
        dataTask1.resume()
    }
    
}
//MARK : UICollectionViewDataSource
extension SecondViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == todosCollectionView){
            return jsonPlaceHolderTodos.count
        }else if(collectionView == collectionView){
            return jsonPlaceHolderComments.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionView == todosCollectionView){
            let todosCVCell = self.todosCollectionView.dequeueReusableCell(withReuseIdentifier: todosCVCellIdentifier, for: indexPath) as! TodosCollectionViewCell
            todosCVCell.todosLabel.text = String(jsonPlaceHolderTodos[indexPath.row].id) + ("\n\(String(jsonPlaceHolderTodos[indexPath.row].title))") + ("\n\(String(jsonPlaceHolderTodos[indexPath.row].completed))")
            return todosCVCell
        }else if (collectionView == commentsCollectionView){
            let commentsCVCell = self.commentsCollectionView.dequeueReusableCell(withReuseIdentifier: commentsCVCellIdentifier, for: indexPath) as! CommentsCollectionViewCell
            commentsCVCell.commentsLabel.text = String(jsonPlaceHolderComments[indexPath.row].id) + ("\n\(String(jsonPlaceHolderComments[indexPath.row].name))") + ("\n\(String(jsonPlaceHolderComments[indexPath.row].email))") + ("\n\(String(jsonPlaceHolderComments[indexPath.row].body))")
            return commentsCVCell
        }
        return UICollectionViewCell()
    }
}

//MARK : UICollectionViewDelegateFlowLayout
extension SecondViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 100.0)
    }
}
