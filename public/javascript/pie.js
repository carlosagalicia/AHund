google.charts.load("current", { packages: ["corechart"] });
google.charts.setOnLoadCallback(drawPieChart1);

function drawPieChart1() {
  fetch("/dashboard/risk-types", {
    method: "GET",
    headers: {
      "Content-Type": "application/json",
    },
  })
    .then((response) => {
      if (!response.ok) {
        throw new Error("Error al obtener los riesgos.");
      }
      return response.json();
    })
    .then((riskTypes) => {
      const formattedData = riskTypes.map((riesgo) => [
        riesgo.Tipo,
        riesgo.RiskCount,
      ]);
      formattedData.unshift(["Tipo", "Ocurrencia"]);
      let data = google.visualization.arrayToDataTable(formattedData);

      var options = {
        pieHole: 0.4,
      };

      var chart = new google.visualization.PieChart(
        document.getElementById("piechart1")
      );

      chart.draw(data, options);
    })
    .catch((error) => {
      console.error(error);
    });
}

google.charts.load("current", { packages: ["corechart"] });
google.charts.setOnLoadCallback(drawPieChart2);

function drawPieChart2() {
  fetch("/dashboard/project-risks", {
    method: "GET",
    headers: {
      "Content-Type": "application/json",
    },
  })
    .then((response) => {
      if (!response.ok) {
        throw new Error("Error al obtener los riesgos.");
      }
      return response.json();
    })
    .then((projectRisks) => {
      const formattedData = projectRisks.map((riesgo) => [
        riesgo.Nombre,
        riesgo.PonderacionRelativa,
      ]);
      formattedData.unshift(["Riesgo", "Puntuación"]);
      let data = google.visualization.arrayToDataTable(formattedData);

      var options = {
        pieHole: 0.4,
      };

      var chart = new google.visualization.PieChart(
        document.getElementById("piechart2")
      );

      chart.draw(data, options);
    })
    .catch((error) => {
      console.error(error);
    });
}
