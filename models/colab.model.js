const db = require("../util/database");

module.exports = class Colab {
  constructor(usuario, contrasena, nombre, apellidos, correo, admin) {}

  static async save(
    idAdmin,
    username,
    password,
    nombres,
    Apaterno,
    Amaterno,
    correo
  ) {
    return db.execute(`CALL InsertUser(${idAdmin}, '${username}', '${password}',
      '${nombres}', '${Apaterno}', '${Amaterno}', '${correo}');`);
  }

  static async fetchAll() {
    return db.execute(`SELECT *
                        FROM usuario u
                        JOIN posee p ON u.IDUsuario = p.IDUsuario
                        WHERE p.IDRol = 2
                        ORDER BY u.Nombre ASC;`);
  }

  static async fetchByNameDESC() {
    return db.execute(`SELECT *
                        FROM usuario u
                        JOIN posee p ON u.IDUsuario = p.IDUsuario
                        WHERE p.IDRol = 2
                        ORDER BY u.Nombre DESC;`);
  }

  static async delete(idAdmin, correo) {
    return db.execute(`CALL DeleteUsuario(${idAdmin}, '${correo}')`);
  }

  static async fetchUser(correo) {
    return db.execute(
      `SELECT * FROM usuario WHERE CorreoElectronico = '${correo}';`
    );
  }

  static async getPermits(id) {
    return db.execute(`SELECT Rol.Nombre
                            FROM Usuario
                            JOIN Posee ON Usuario.IDUsuario = Posee.IDUsuario
                            JOIN Rol ON Posee.IDRol = Rol.IDRol
                            WHERE Usuario.IDUsuario = ${id};`);
  }

  static async addPermit(idAdmin, correo) {
    return db.execute(`CALL AddAdmin(${idAdmin}, '${correo}')`);
  }
};
