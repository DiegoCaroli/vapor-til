import Vapor

struct UserController: RouteCollection {
  
  func boot(router: Router) throws {
    let usersRoutes = router.grouped("api", "users")
    
    usersRoutes.post(User.self, use: createHandler)
    usersRoutes.get(use: getAllHandler)
    usersRoutes.get(User.parameter, use: getHandler)
    usersRoutes.get(User.parameter, use: getAcronymsHandler)
//    acronymsRoutes.put(Acronym.parameter, use: updateHandler)
//    acronymsRoutes.delete(Acronym.parameter, use: deleteHandler)

  }
  
  func createHandler(_ req: Request, user: User) throws -> Future<User> {
      return user.save(on: req)
    }
  
    func getAllHandler(_ req: Request) throws -> Future<[User]> {
      return User.query(on: req).all()
    }
  
  func getHandler(_ req: Request) throws -> Future<User> {
    return try req.parameter(User.self)
  }
  
  func getAcronymsHandler(_ req: Request) throws -> Future<[Acronym]> {
    return try req.parameter(User.self)
      .flatMap(to: [Acronym].self) { user in
        try user.acronyms.query(on: req).all()
    }
  }
//
//  func updateHandler(_ req: Request) throws -> Future<Acronym> {
//    return try flatMap(to: Acronym.self, req.parameter(Acronym.self), req.content.decode(Acronym.self)) { acronym, updatedAcronym in
//      acronym.short = updatedAcronym.short
//      acronym.long = updatedAcronym.long
//
//      return acronym.save(on: req)
//    }
//  }
//
//  func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
//    return try req.parameter(Acronym.self).flatMap(to: HTTPStatus.self) { acronym in
//      return acronym.delete(on: req).transform(to: HTTPStatus.noContent)
//    }
//  }
//

  
}
