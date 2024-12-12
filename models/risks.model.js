const db = require("../util/database");

module.exports = class Risks {
  constructor(my_nombre_riesgo, my_descripcion, my_tipo) {
    this.nombreRiesgo = my_nombre_riesgo;
    this.descripcion = my_descripcion;
    this.tipo = my_tipo;
  }

  async save() {
    await db.execute("CALL InsertRisk(?, ?, ?)", [
      this.nombreRiesgo,
      this.descripcion,
      this.tipo,
    ]);
  }

  static async fetchAll() {
    const query = `
      SELECT riesgo.*, COUNT(presenta.IDRiesgo) AS Concurrencia
      FROM riesgo
      LEFT JOIN presenta ON riesgo.IDRiesgo = presenta.IDRiesgo
      GROUP BY riesgo.IDRiesgo
      ORDER BY Concurrencia DESC, riesgo.IDRiesgo;
      `;

    return await db.execute(query);
  }

  static async fetchBy(type) {
    const query = `
        SELECT * FROM riesgo
        WHERE Tipo = ?;
      `;

    return await db.execute(query, [type]);
  }

  static async fetchRiskTypes() {
    const query = `
      SELECT Tipo FROM Riesgo
      GROUP BY Tipo;
    `;
    return await db.execute(query);
  }

  static async fetchRisk(IDRiesgo) {
    const query = `
        SELECT * FROM riesgo WHERE IDRiesgo = ?;
      `;

    return await db.execute(query, [IDRiesgo]);
  }

  static async fetchRiskInfo(IDRiesgo) {
    const query = `
      SELECT presenta.IDProyecto, presenta.PonderacionRelativa,
      presenta.Medidas, proyecto.Nombre AS NombreProyecto,
      proyecto.Tipo AS TipoProyecto FROM riesgo
      JOIN presenta ON Riesgo.IDRiesgo = presenta.IDRiesgo
      JOIN proyecto on proyecto.IDProyecto = presenta.IDProyecto
      WHERE riesgo.IDRiesgo = ?;
      `;

    return await db.execute(query, [IDRiesgo]);
  }

  static async fetchDissimilar(IDProyecto) {
    const query = `
      SELECT
          R.IDRiesgo,
          R.Nombre,
          R.Tipo,
          R.Descripcion
      FROM
          Riesgo R
      WHERE
          R.IDRiesgo NOT IN (
              SELECT
                  P.IDRiesgo
              FROM
                  Presenta P
              WHERE
                  P.IDProyecto = ?
          );
      `;

    return await db.execute(query, [IDProyecto]);
  }

  static async fetchAssociated(IDProyecto) {
    const query = `
      SELECT
            Presenta.IDRiesgo,
            Presenta.PonderacionRelativa,
            R.Nombre,
            R.Tipo,
            R.Descripcion
        FROM Presenta
        JOIN Riesgo R ON Presenta.IDRiesgo = R.IDRiesgo
        WHERE Presenta.IDProyecto = ?;
      `;

    return await db.execute(query, [IDProyecto]);
  }

  static async associateRisk(
    IDRiesgo,
    IDProyecto,
    fechaAsignacion,
    ponderacion,
    medidas
  ) {
    const query = `INSERT INTO Presenta (IDRiesgo, IDProyecto, FechaAsignacion, PonderacionRelativa, Medidas)
                 VALUES (?, ?, ?, ?, ?)`;

    return await db.execute(query, [
      IDRiesgo,
      IDProyecto,
      fechaAsignacion,
      ponderacion,
      medidas,
    ]);
  }

  static async unassociateRisk(IDRiesgo, IDProyecto) {
    const query = `
      DELETE FROM Presenta
      WHERE IDRiesgo = ? AND IDProyecto = ?;
      `;

    return await db.execute(query, [IDRiesgo, IDProyecto]);
  }

  static async deleteRisk(IDRiesgo) {
    const query = `
      DELETE FROM Riesgo
      WHERE IDRiesgo = ?;
      `;

    return await db.execute(query, [IDRiesgo]);
  }

  static async updateRisk(id, nombre, tipo, descripcion) {
    const query = `
      UPDATE riesgo
      SET Nombre = ?, Tipo = ?, Descripcion = ?
      WHERE IDRiesgo = ?;
    `;

    return await db.execute(query, [nombre, tipo, descripcion, id]);
  }

  static async updateRiskDetails(riskId, projectID, medidas, ponderacion) {
    const query = `
      UPDATE presenta
      SET Medidas = ?,
          PonderacionRelativa = ?
      WHERE IDRiesgo = ? AND IDProyecto = ?;
    `;
    return await db.execute(query, [medidas, ponderacion, riskId, projectID]);
  }

}