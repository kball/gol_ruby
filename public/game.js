$(function() {
  var canvas = $("#game").get(0);
  var context = canvas.getContext("2d");


  // renderGrid taken from http://devhammer.net/blog/visualizing-layout-in-html5-canvas-with-gridlines/
  function renderGrid(gridPixelSize, color) {
    context.save();
    context.lineWidth = 0.5;
    context.strokeStyle = color;

    // horizontal grid lines
    for(var i = 0; i <= canvas.height; i = i + gridPixelSize)
    {
      context.beginPath();
      context.moveTo(0, i);
      context.lineTo(canvas.width, i);
      context.closePath();
      context.stroke();
    }

    // vertical grid lines
    for(var j = 0; j <= canvas.width; j = j + gridPixelSize) {
      context.beginPath();
      context.moveTo(j, 0);
      context.lineTo(j, canvas.height);
      context.closePath();
      context.stroke();
    }

    context.restore();
  }

  function addCell(x, y, gridPixelSize) {
    context.fillRect(x * gridPixelSize, y * gridPixelSize, gridPixelSize, gridPixelSize)
  }

  function drawBoard() {
    $.getJSON('/board', function(resp) {
      resp.board.forEach(function(cell) {
        addCell(cell.x, cell.y, 10);
      });
    });
  }

  function loadGame() {
    context.clearRect(0, 0, canvas.width, canvas.height)
    renderGrid(10, "#444");
    drawBoard();
  }

  function runGeneration() {
    $.post('/board/run', function() {
      loadGame();
    });
  }


  loadGame();

  $('#next').click(runGeneration);
  //addCell(3, 3, 10);
});
