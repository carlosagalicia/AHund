/* Login route redirect-main button*/
if (window.location.pathname === "/login") {
  var linkElement = document.getElementById("redirect-main");

  // Update the href attribute
  if (linkElement) {
    linkElement.setAttribute("href", "/login");
  }
}

// No content message
document.addEventListener("DOMContentLoaded", function () {
  function toggleNoContentMessage() {
    var divScroll = document.querySelector(".scroll-section");
    var noContentMessage = document.querySelector(".no-content-message");
    if (divScroll && noContentMessage) {
      if (divScroll.children.length === 1) {
        noContentMessage.style.display = "block";
      } else {
        noContentMessage.style.display = "none";
      }
    }
  }
  toggleNoContentMessage();

  document.addEventListener("click", function () {
    toggleNoContentMessage();
  });
});

//login validation
function validateLoginForm() {
  var email = document.getElementById("email").value;
  var password = document.getElementById("password").value;

  // email length
  if (email.length > 32) {
    alert("El email no puede tener más de 32 caracteres");
    return false;
  }

  // password length
  if (password.length > 255) {
    alert("La contraseña no puede tener más de 255 caracteres");
    return false;
  }

  //required fields
  if (!password || !email) {
    alert("Todos los campos son requeridos");
    return false;
  }

  return true;
}

//Register colab validation
function validateRegisterColabForm() {
  var email = document.getElementById("email").value;
  var password = document.getElementById("password").value;
  var name = document.getElementById("name").value;
  var paterno = document.getElementById("Apaterno").value;
  var materno = document.getElementById("Amaterno").value;
  var user = document.getElementById("Usuario").value;

  // email length
  if (email.length > 32) {
    alert("El email no puede tener más de 32 caracteres");
    return false;
  }

  // email domain check
  if (!email.endsWith("@appix.mx")) {
    alert("El email debe terminar en @appix.mx");
    return false;
  }

  // password length
  if (password.length > 255) {
    alert("La contraseña no puede tener más de 255 caracteres");
    return false;
  }

  // name length
  if (name.length > 40) {
    alert("El nombre no puede tener más de 40 caracteres");
    return false;
  }

  // paternal surname length
  if (paterno.length > 40) {
    alert("El apellido paterno no puede tener más de 40 caracteres");
    return false;
  }

  // maternal surname length
  if (materno.length > 40) {
    alert("El apellido materno no puede tener más de 40 caracteres");
    return false;
  }

  //user length
  if (user.length > 40) {
    alert("El nombre de usuario no puede tener más de 40 caracteres");
    return false;
  }

  //required fields
  if (!email || !password || !name || !paterno || !materno || !user) {
    alert("Todos los campos son requeridos");
    return false;
  }

  return true;
}

// Trendiline chart
google.charts.load("current", { packages: ["corechart"] });
google.charts.setOnLoadCallback(drawChart);

var chart;
var dailyprevButton;
var dailynextButton;
var weeklyprevButton;
var weeklynextButton;

function drawChart() {
  if (typeof window.dataFromServer === "undefined") return;

  var datosDePonderacion = window.dataFromServer;

  // Función para obtener el número de la semana ISO-8601
  function getISOWeek(date) {
    const tempDate = new Date(date.getTime());
    tempDate.setHours(0, 0, 0, 0);
    tempDate.setDate(tempDate.getDate() + 3 - ((tempDate.getDay() + 6) % 7));
    const week1 = new Date(tempDate.getFullYear(), 0, 4);
    return (
      1 +
      Math.round(
        ((tempDate.getTime() - week1.getTime()) / 86400000 -
          3 +
          ((week1.getDay() + 6) % 7)) /
          7
      )
    );
  }

  // Función para obtener el año ISO-8601
  function getISOYear(date) {
    const tempDate = new Date(date.getTime());
    tempDate.setDate(tempDate.getDate() + 3 - ((tempDate.getDay() + 6) % 7));
    return tempDate.getFullYear();
  }

  // Datos por días del mes
  var dataArrayDias = [["Fecha", "Ponderacion"]];
  datosDePonderacion.forEach(function (item) {
    var fecha = new Date(item.Fecha);
    dataArrayDias.push([fecha, item.PonderacionRelativaTotal]);
  });
  var dataDias = google.visualization.arrayToDataTable(dataArrayDias);

  // Datos por semanas del año
  var dataArraySemanas = [["Fecha", "Ponderacion"]];
  var semanas = {};
  datosDePonderacion.forEach(function (item) {
    var fecha = new Date(item.Fecha);
    var year = getISOYear(fecha);
    var week = getISOWeek(fecha);
    var key = `${year}-W${week}`;

    if (!semanas[key]) {
      semanas[key] = [];
    }
    semanas[key].push(item);
  });

  for (var key in semanas) {
    if (semanas.hasOwnProperty(key)) {
      var semana = semanas[key];
      var ultimoDia = semana[semana.length - 1];
      var fecha = new Date(ultimoDia.Fecha);
      dataArraySemanas.push([fecha, ultimoDia.PonderacionRelativaTotal]);
    }
  }
  var dataSemanas = google.visualization.arrayToDataTable(dataArraySemanas);

  // Datos por meses del año
  var dataArrayMeses = [["Fecha", "Ponderacion"]];
  var meses = {};
  datosDePonderacion.forEach(function (item) {
    var fecha = new Date(item.Fecha);
    var year = fecha.getFullYear();
    var month = fecha.getMonth();
    var key = `${year}-${month}`;

    if (!meses[key]) {
      meses[key] = [];
    }
    meses[key].push(item);
  });

  for (var key in meses) {
    if (meses.hasOwnProperty(key)) {
      var mes = meses[key];
      var ultimoDia = mes[mes.length - 1];
      var fecha = new Date(ultimoDia.Fecha);
      dataArrayMeses.push([fecha, ultimoDia.PonderacionRelativaTotal]);
    }
  }
  var dataMeses = google.visualization.arrayToDataTable(dataArrayMeses);

  var options = {
    legend: "none",
    vAxis: {
      title: "Ponderacion",
    },
    colors: ["#e2431e"],
    lineWidth: 3,
    pointSize: 10,
    animation: {
      duration: 1000,
      easing: "in",
    },
    trendlines: { 0: {
      type: 'polynomial',
      degree: 3,
      visibleInLegend: true,
      pointSize: 0,
    } },
  };

  // Dibujar gráfico por días
  var chartDias = new google.visualization.LineChart(
    document.getElementById("curve_chart_dias")
  );

  dailyprevButton = document.getElementById("b1daily");
  dailynextButton = document.getElementById("b2daily");

  var optionsDias = Object.assign({}, options, {
    hAxis: {
      title: "Dia",
      format: "dd/MM",
      gridlines: { count: 60, color: "none" },
      viewWindow: {
        min: new Date(datosDePonderacion[0].Fecha),
        max: new Date(
          new Date(datosDePonderacion[0].Fecha).getTime() +
            30 * 24 * 60 * 60 * 1000
        ),
      },
    },
    colors: ["#ff8a5b"],
  });

  function drawChartDias() {
    dailyprevButton.disabled =
      optionsDias.hAxis.viewWindow.min <= new Date(datosDePonderacion[0].Fecha);
    dailynextButton.disabled =
      optionsDias.hAxis.viewWindow.max >=
      new Date(datosDePonderacion[datosDePonderacion.length - 1].Fecha);
  }

  dailyprevButton.onclick = function () {
    optionsDias.hAxis.viewWindow.min = new Date(
      optionsDias.hAxis.viewWindow.min.getTime() - 30 * 24 * 60 * 60 * 1000
    );
    optionsDias.hAxis.viewWindow.max = new Date(
      optionsDias.hAxis.viewWindow.max.getTime() - 30 * 24 * 60 * 60 * 1000
    );
    drawChartDias();
    chartDias.draw(dataDias, optionsDias);
  };

  dailynextButton.onclick = function () {
    optionsDias.hAxis.viewWindow.min = new Date(
      optionsDias.hAxis.viewWindow.min.getTime() + 30 * 24 * 60 * 60 * 1000
    );
    optionsDias.hAxis.viewWindow.max = new Date(
      optionsDias.hAxis.viewWindow.max.getTime() + 30 * 24 * 60 * 60 * 1000
    );
    drawChartDias();
    chartDias.draw(dataDias, optionsDias);
  };

  drawChartDias();
  chartDias.draw(dataDias, optionsDias);

  // Dibujar gráfico por semanas
  var chartSemanas = new google.visualization.LineChart(
    document.getElementById("curve_chart_semanas")
  );

  weeklyprevButton = document.getElementById("b1weekly");
  weeklynextButton = document.getElementById("b2weekly");

  var optionsSemanas = Object.assign({}, options, {
    hAxis: {
      title: "Semana",
      format: "MMM dd",
      gridlines: { count: 5, color: "none" },
      viewWindow: {
        min: new Date(datosDePonderacion[0].Fecha),
        max: new Date(
          new Date(datosDePonderacion[0].Fecha).getTime() +
            30 * 24 * 60 * 60 * 1000
        ),
      },
    },
    colors: ["#ea526f"],
  });

  function drawChartSemanas() {
    weeklyprevButton.disabled =
      optionsSemanas.hAxis.viewWindow.min <=
      new Date(datosDePonderacion[0].Fecha);
    weeklynextButton.disabled =
      optionsSemanas.hAxis.viewWindow.max >=
      new Date(datosDePonderacion[datosDePonderacion.length - 1].Fecha);
  }

  weeklyprevButton.onclick = function () {
    optionsSemanas.hAxis.viewWindow.min = new Date(
      optionsSemanas.hAxis.viewWindow.min.getTime() - 28 * 24 * 60 * 60 * 1000
    );
    optionsSemanas.hAxis.viewWindow.max = new Date(
      optionsSemanas.hAxis.viewWindow.max.getTime() - 28 * 24 * 60 * 60 * 1000
    );
    drawChartSemanas();
    chartSemanas.draw(dataSemanas, optionsSemanas);
  };

  weeklynextButton.onclick = function () {
    optionsSemanas.hAxis.viewWindow.min = new Date(
      optionsSemanas.hAxis.viewWindow.min.getTime() + 28 * 24 * 60 * 60 * 1000
    );
    optionsSemanas.hAxis.viewWindow.max = new Date(
      optionsSemanas.hAxis.viewWindow.max.getTime() + 28 * 24 * 60 * 60 * 1000
    );
    drawChartSemanas();
    chartSemanas.draw(dataSemanas, optionsSemanas);
  };

  drawChartSemanas();

  chartSemanas.draw(dataSemanas, optionsSemanas);

  // Dibujar gráfico por meses
  var chartMeses = new google.visualization.LineChart(
    document.getElementById("curve_chart_meses")
  );
  var optionsMeses = Object.assign({}, options, {
    hAxis: {
      title: "Meses",
      format: "MMM yyyy",
      gridlines: { count: 12, color: "none" },
    },
    colors: ["#25ced1"],
  });
  chartMeses.draw(dataMeses, optionsMeses);
}

function showGraph(period) {
  var charts = document.getElementsByClassName("line-chart");
  for (var i = 0; i < charts.length; i++) {
    charts[i].style.display = "none";
  }

  if (period === "DAILY") {
    document.getElementById("curve_chart_dias").style.display = "block";
    document.getElementById("b1daily").style.display = "block";
    document.getElementById("b2daily").style.display = "block";
    document.getElementById("b1weekly").style.display = "none";
    document.getElementById("b2weekly").style.display = "none";
  } else if (period === "WEEKLY") {
    document.getElementById("curve_chart_semanas").style.display = "block";
    document.getElementById("b1weekly").style.display = "block";
    document.getElementById("b2weekly").style.display = "block";
    document.getElementById("b1daily").style.display = "none";
    document.getElementById("b2daily").style.display = "none";
  } else if (period === "MONTHLY") {
    document.getElementById("curve_chart_meses").style.display = "block";
    document.getElementById("b1daily").style.display = "none";
    document.getElementById("b2daily").style.display = "none";
    document.getElementById("b1weekly").style.display = "none";
    document.getElementById("b2weekly").style.display = "none";
  }
}
