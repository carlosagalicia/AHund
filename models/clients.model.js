const db = require("../util/database");

module.exports = class Client {

  static async fetchAll() {
    return db.execute(`SELECT * 
                        FROM cliente 
                        ORDER BY Cliente.Nombre ASC;`);
  }

  static async fetchByNameDESC() {
    return db.execute(`SELECT * 
                        FROM cliente 
                        ORDER BY Cliente.Nombre DESC;`);
  }

  static async fetchByEmailASC() {
    return db.execute(`SELECT * 
                        FROM cliente 
                        ORDER BY Cliente.CorreoElectronico ASC;`);
  }

  static async fetchByEmailDESC() {
    return db.execute(`SELECT * 
                        FROM cliente 
                        ORDER BY Cliente.CorreoElectronico DESC;`);
  }

};
