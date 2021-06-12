//
//  ContentView.swift
//  bookTestLibrary_Tester
//
//  Created by Benjamin Budzak on 6/5/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        EmptyView()
            .onAppear {
                //MARK: - Examples of Usage:

                    BookTestLibrary.shared.getAccountData { data, response, error in
                        if error != nil {
                            print("error = \(error)")
                        } else {
                            if let safeData = data {
                                print(String(data: safeData, encoding: .utf8)!)

                                do {
                                    let books = try JSONDecoder().decode([BookData].self, from: safeData)
                                    for book in books {
                                        print(book.id)
                                        print(book.name)
                                        print(book.bookKey)
                                    }
                                }  catch {
                                    print("error: ", error)
                                }


                            }

                        }
                    }

                    BookTestLibrary.shared.getAvailableBooks { data, response, error in
                        if error != nil {
                            print("error = \(error)")
                        } else {

                            if let safeData = data {
                                print(String(data: safeData, encoding: .utf8)!)

                                do {
                                    let books = try JSONDecoder().decode([BookData].self, from: safeData)
                                    print(books as Any)
                                    for (index, book) in books.enumerated() {
                                        print("Book Number \(index + 1)")
                                        print(book.name)
                                        print(book.coverImage)
                                        print(book.isbn13)
                                        print(book.price)
                                    }
                                }  catch {
                                    print("error: ", error)
                                }

                            }

                        }
                    }

                
                    BookTestLibrary.shared.activateBook(bookKey: "123456") { data, response, error in
                        if error != nil {
                            print("error = \(error)")
                        } else {

                            if let safeData = data {

                                do {
                                    let message = try JSONDecoder().decode(Message.self, from: safeData)

                                    if message.msg == "success" {
                                        print("book activated successfully")
                                    } else if message.msg == "key not found" {
                                        print("key not found")
                                    } else if message.msg == "Forbidden" {
                                        print("issue with api key")
                                    } else {
                                        print("activate book issue, message is \(message.msg)")
                                    }

                                } catch {
                                    print("error: ", error)
                                }

                            }

                        }
                    }


                BookTestLibrary.shared.getWordsOnPage(page: "24") { data, response, error in
                    if error != nil {
                        print("error = \(error)")
                    } else {
                        if let safeData = data, let result = String(data: safeData, encoding: .utf8) {
                            print(result)
                            if result == "Forbidden" {
                                print("you don't own this book")
                            } else if result == "undefined" {
                                print("that page doesnt exist")
                            } else {
                                print("text is = \(result)")
                            }
                        }
                    }
                }
                


                
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
