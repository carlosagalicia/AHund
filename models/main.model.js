const db = require("../util/database");

module.exports = class Projects {
  constructor(
    my_nombre_proyecto,
    my_finicio,
    my_ffinal,
    my_tipo,
    my_estado,
    my_nombre_cliente,
    my_correo_electronico,
    my_telefono,
    my_descripcion
  ) {
    this.nombreProyecto = my_nombre_proyecto;
    this.fInicio = my_finicio;
    this.fFinal = my_ffinal;
    this.tipo = my_tipo;
    this.estado = my_estado;
    (this.nombreCliente = my_nombre_cliente),
      (this.correoElectronico = my_correo_electronico),
      (this.telefono = my_telefono),
      (this.descripcion = my_descripcion);
  }

  async save() {
    await db.execute(
      "CALL InsertProjectWithClientCheck(?, ?, ?, ?, ?, ?, ?, ?, ?)",
      [
        this.nombreProyecto,
        this.fInicio,
        this.fFinal,
        this.tipo,
        this.estado,
        this.nombreCliente,
        this.correoElectronico,
        this.telefono,
        this.descripcion,
      ]
    );
  }

  static async updateProjectWithClient(project) {
    return await db.execute(
      "CALL UpdateProjectWithClientCheck(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
      [
        project.IDProyecto,
        project.IDCliente,
        project.nombre,
        project.f_inicio,
        project.f_final,
        project.tipo,
        project.estado,
        project.nombreCliente,
        project.emailCliente,
        project.telefonoCliente,
        project.descripcionCliente,
      ]
    );
  }

  static async fetchAll(status, filter, limit, offset, IDuser) {
    const query = `CALL GetProjects(?, ?, ?, ?, ?);`;

    return await db.execute(query, [status, filter, limit, offset, IDuser]);
  }

  static async fetchProjectRisks(IDProyecto) {
    const query = `
        SELECT
        proyecto.IDProyecto, 
        presenta.PonderacionRelativa, 
        riesgo.Nombre,
        riesgo.Descripcion,
        ROW_NUMBER() OVER (ORDER BY proyecto.IDProyecto, presenta.PonderacionRelativa DESC) AS RowNumber FROM proyecto
        JOIN presenta ON proyecto.IDProyecto = presenta.IDProyecto
        JOIN riesgo ON presenta.IDRiesgo = riesgo.IDRiesgo
        WHERE proyecto.IDProyecto = ?;
        `;
    return await db.execute(query, [IDProyecto]);
  }

  static async countRisks(IDProyecto) {
    const query = `
        SELECT
        proyecto.IDProyecto,
        COUNT(*) AS RiskCount,
        riesgo.Tipo
        FROM proyecto
        JOIN presenta ON proyecto.IDProyecto = presenta.IDProyecto
        JOIN riesgo ON presenta.IDRiesgo = riesgo.IDRiesgo
        WHERE proyecto.IDProyecto = ?
        GROUP BY riesgo.Tipo;
        `;

    return await db.execute(query, [IDProyecto]);
  }

  static async fetchProject(IDProyecto) {
    const query = `
    SELECT proyecto.*,
    COALESCE(SUM(presenta.PonderacionRelativa), 0) AS PonderacionRelativaTotal
    FROM proyecto
    LEFT JOIN presenta ON proyecto.IDProyecto = presenta.IDProyecto
    WHERE proyecto.IDProyecto = ?
    GROUP BY proyecto.IDProyecto;
    `;

    return await db.execute(query, [IDProyecto]);
  }

  static async fetchFirstProject(status) {
    const query = `SELECT IDProyecto FROM proyecto WHERE Estado = ? ORDER BY IDProyecto ASC LIMIT 1;`;

    return await db.execute(query, [status]);
  }

  static async fetchRisksOfProject(IDProyecto) {
    const query = `
        SELECT
        proyecto.IDProyecto,
        presenta.PonderacionRelativa,
        riesgo.Nombre,
        riesgo.Descripcion,
        riesgo.Tipo,
        riesgo.IDRiesgo,
        presenta.Medidas
        FROM proyecto
        JOIN presenta ON proyecto.IDProyecto = presenta.IDProyecto
        JOIN riesgo ON presenta.IDRiesgo = riesgo.IDRiesgo
        WHERE proyecto.IDProyecto = ?;
        `;
    return await db.execute(query, [IDProyecto]);
  }

  static async fetchClient(IDProyecto) {
    const query = `
      SELECT cliente.* FROM proyecto
      JOIN cliente ON proyecto.IDCliente = cliente.IDCliente
      WHERE proyecto.IDProyecto = ?;
    `;

    return await db.execute(query, [IDProyecto]);
  }

  static async countProjects(status) {
    const query = `
      SELECT COUNT(*) AS NumActivos FROM proyecto
      WHERE Estado = ?;
      `;

    return await db.execute(query, [status]);
  }

  static async archiveProject(IDProyecto) {
    const query = `
      UPDATE proyecto SET Estado = 0 WHERE IDProyecto = ?; 
      `;

    await db.execute(query, [IDProyecto]);
  }

  static async unarchiveProject(IDProyecto) {
    const query = `
      UPDATE proyecto SET Estado = 1 WHERE IDProyecto = ?; 
      `;

    await db.execute(query, [IDProyecto]);
  }

  static async highlightProject(IDProyecto, userID) {
    const query = `
        CALL HighlightProject(?, ?);
      `;

    await db.execute(query, [IDProyecto, userID]);
  }

  static async deleteById(projectId) {
    return db.execute("CALL DeleteProject(?)", [projectId]);
  }

  static async getProjectPonderationData(IDProyecto, FechaInicio) {
    const query = `
      SELECT Fecha, PonderacionRelativaTotal
      FROM proyectoslog
      WHERE IDProyecto = ? AND Fecha >= ?
      ORDER BY Fecha ASC
      `;

    return await db.execute(query, [IDProyecto, FechaInicio]);
  }
};
