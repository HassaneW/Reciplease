//
//  BaseViewController.swift
//  Reciplease_Project
//
//  Created by Wandianga hassane on 11/11/2020.
//  Copyright © 2020 Wandianga. All rights reserved.
//

import Foundation


    extension RecipesListViewController {
        func add(_ child: RecipesListViewController) {
            addChild(child)
            view.addSubview(child.view)
            child.didMove(toParent: self)
        }

        func remove() {
            // Just to be safe, we check that this view controller
            // is actually added to a parent before removing it.
            guard parent != nil else {
                return
            }

            willMove(toParent: nil)
            view.removeFromSuperview()
            removeFromParent()
        }
    }

//Utilisation d'un contrôleur de vue enfant

//class ListViewController: UITableViewController {
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        loadItems()
//    }
//
//    private func loadItems() {
//        let loadingViewController = LoadingViewController()
//        add(loadingViewController)
//
//        dataLoader.loadItems { [weak self] result in
//            loadingViewController.remove()
//            self?.handle(result)
//        }
//    }
//}

/*
 Contrôleurs de vue enfant
 
 1) Pour ajouter un contrôleur de vue en tant qu'enfant, nous utilisons les trois appels d'API suivants:
 
 let parent = UIViewController()
 let child = UIViewController()

 // First, add the view of the child to the view of the parent
 parent.view.addSubview(child.view)

 // Then, add the child to the parent
 parent.addChild(child)

 // Finally, notify the child that it was moved to a parent
 child.didMove(toParent: parent)
 
 2) Et pour supprimer un enfant une fois ajouté à un parent, nous utilisons les trois appels suivants:
 
 // First, notify the child that it’s about to be removed
 child.willMove(toParent: nil)

 // Then, remove the child from its parent
 child.removeFromParent()

 // Finally, remove the child’s view from the parent’s
 child.view.removeFromSuperview()
 
 3) Une solution à ce problème consiste à ajouter une extension UIViewControllerqui regroupe toutes les étapes nécessaires pour ajouter ou supprimer un contrôleur de vue enfant en deux méthodes faciles à utiliser, comme celle-ci:
 
 extension UIViewController {
     func add(_ child: UIViewController) {
         addChild(child)
         view.addSubview(child.view)
         child.didMove(toParent: self)
     }

     func remove() {
         // Just to be safe, we check that this view controller
         // is actually added to a parent before removing it.
         guard parent != nil else {
             return
         }

         willMove(toParent: nil)
         view.removeFromSuperview()
         removeFromParent()
     }
 }
 
 
 */


/*
 
 Les contrôleurs de vue enfants sont particulièrement utiles pour les fonctionnalités de l'interface utilisateur que nous souhaitons réutiliser dans un projet. Par exemple, nous pourrions vouloir afficher une vue de chargement lorsque nous chargeons le contenu de chaque écran - et cela peut être facilement implémenté à l'aide d'un contrôleur de vue enfant, qui peut ensuite être simplement ajouté si nécessaire.

 Pour ce faire, créons d'abord un LoadingViewControllerqui affiche une flèche de chargement au centre de sa vue, comme ceci:
 
 class LoadingViewController: UIViewController {
     override func viewDidLoad() {
         super.viewDidLoad()

         let spinner = UIActivityIndicatorView(style: .gray)
         spinner.translatesAutoresizingMaskIntoConstraints = false
         spinner.startAnimating()
         view.addSubview(spinner)

         // Center our spinner both horizontally & vertically
         NSLayoutConstraint.activate([
             spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
         ])
     }
 }
 
 Ensuite, lorsque nous - dans l'un de nos contrôleurs de vue de contenu - commençons à charger du contenu, nous pouvons maintenant simplement ajouter notre nouveau en LoadingViewControllertant qu'enfant pour afficher un spinner de chargement, puis le supprimer une fois que nous avons terminé:
 
 class ContentViewController: UIViewController {
     private let loader = ContentLoader()

     func loadContent() {
         let loadingVC = LoadingViewController()
         add(loadingVC)

         loader.load { [weak self] content in
             loadingVC.remove()
             self?.render(content)
         }
     }
 }
 
 Plutôt cool! 👍 Mais la question est la suivante: pourquoi se donner la peine d'implémenter un contrôleur de vue pour quelque chose comme un spinner de chargement, au lieu d'utiliser simplement un simple UIView? Voici quelques raisons courantes:

 Un contrôleur de vue a accès à des événements tels que viewDidLoadet viewWillAppear, même lorsqu'il est utilisé en tant qu'enfant, ce qui peut être vraiment utile pour de nombreux types de code d'interface utilisateur.
 Un contrôleur de vue est plus autonome et peut à la fois inclure la logique requise pour piloter son interface utilisateur, ainsi que l'interface utilisateur elle-même.
 Lorsqu'il est ajouté en tant qu'enfant, un contrôleur de vue remplit automatiquement l'écran, réduisant ainsi le besoin de code de disposition supplémentaire pour les interfaces utilisateur plein écran.
 Lorsqu'un élément d'interface utilisateur est implémenté en tant que contrôleur de vue, il peut être utilisé dans de nombreux contextes différents, y compris à la fois être poussé sur un contrôleur de navigation et incorporé en tant qu'enfant.
 Bien sûr, cela ne signifie pas nécessairement que toutes les interfaces utilisateur doivent être implémentées à l'aide de contrôleurs de vue enfants - mais c'est un bon outil à garder à l'esprit afin de créer des interfaces utilisateur de manière plus modulaire.
 
 */
