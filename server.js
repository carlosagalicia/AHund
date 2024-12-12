/* Dependencies */
const path = require("path");
const express = require("express");
const session = require("express-session");
const cookieParser = require("cookie-parser");
const bodyParser = require("body-parser");
const csrf = require("csurf");
const csrfProtection = csrf();
const flash = require("express-flash");
/*------------*/

/* Including Routes */
const mainRoutes = require("./routes/main.routes");
const colabsRoutes = require("./routes/colabs.routes");
const loginRoutes = require("./routes/login.routes");
const dashboardRoutes = require("./routes/dashboard.routes");
const risksRoutes = require("./routes/risks.routes");
const clientsRoutes = require("./routes/clients.routes");
/*------------*/

const app = express();
app.use(bodyParser.urlencoded({ extended: false }));
app.use(
  session({
    secret: "A81vn23JJwqQI",
    resave: false,
    saveUninitialized: true,
  })
);

app.use(express.urlencoded({ extended: false }));
app.use(express.json());
app.use(cookieParser());
app.use(flash());
app.use(express.static(path.join(__dirname, "public")));

app.use(csrfProtection);

app.use((request, response, next) => {
  response.locals.csrfToken = request.csrfToken();
  next();
});

app.set("view engine", "ejs");
app.set("views", path.join(__dirname, "views"));

const PORT = 3003;

/* Including Routes */
app.use("/", mainRoutes);
app.use("/colaboradores", colabsRoutes);
app.use("/dashboard", dashboardRoutes);
app.use("/login", loginRoutes);
app.use("/risks", risksRoutes);
app.use("/clients", clientsRoutes);
/*------------*/

app.use((req, res) => {
  res.status(404).send("Error 404: Page Not Found");
});

app.listen(PORT, () => {
  console.log(`Server listening on port ${PORT}`);
});
