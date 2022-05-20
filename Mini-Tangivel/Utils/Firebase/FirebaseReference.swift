//
//  FirebaseReference.swift
//  Mini-Tangivel
//
//  Created by Marco Zulian on 19/05/22.
//

import Firebase

enum FirebaseCollectionReference: String {
    case game
}

func firebaseReference(_ collectionReference: FirebaseCollectionReference) -> CollectionReference {
    return Firestore.firestore().collection(collectionReference.rawValue)
}
