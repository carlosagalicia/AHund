const db = require("../util/database");

module.exports = class User {
  static async findById(userId) {
    const query = "SELECT * FROM Usuario WHERE IDUsuario = ?";
    return await db.execute(query, [userId]);
  }

  static async updateById(userId, updatedData) {
    const query = `
    CALL EditProfile( ?, ?, ?, ?, ?, ?);`;
    return await db.execute(query, [
      userId,
      updatedData.userEmail,
      updatedData.name,
      updatedData.aPaterno,
      updatedData.aMaterno,
      updatedData.userPassword,
    ]);
  }
};
