require("dotenv").config();
const mysql = require("mysql2");

const pool = mysql.createPool({
  host: "localhost",
  user: "root",
  database: "ahund",
  password: "root",
  port: 3304,
  connectionLimit: 5,
});

pool.getConnection((err, connection) => {
  if (err) {
    console.error("Connection error with database: ", err);
  } else {
    console.log("Successfully connected to the database.");
    connection.release();
  }
});

module.exports = pool.promise();
