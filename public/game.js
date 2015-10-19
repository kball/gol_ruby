$(function() {
  var canvas = $("#game").get(0);
  var context = canvas.getContext("2d");

  var min = 0, max = 100;
  var gridPixelSize = 8;

  var runningInterval = null;


  // renderGrid taken from http://devhammer.net/blog/visualizing-layout-in-html5-canvas-with-gridlines/
  function renderGrid(color) {
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

  function addCell(x, y) {
    if (x >= min && x <= max && y >= min && y <= max) {
      var offsetX = x - min;
      var offsetY = y - min;
      context.fillRect(offsetX * gridPixelSize, offsetY * gridPixelSize, gridPixelSize, gridPixelSize)
    }
  }

  function drawBoard() {
    $.getJSON('/board', {min: min, max: max}, function(resp) {
      resp.board.forEach(function(cell) {
        addCell(cell.x, cell.y);
      });
    });
  }

  // TODO:  Bother with error checking on non-integer values and flipflopped min/max
  function setPixelSize() {
    min = parseInt($('#min').val());
    max = parseInt($('#max').val());
    gridPixelSize = canvas.width / (max - min);
  }

  function loadGame() {
    context.clearRect(0, 0, canvas.width, canvas.height)
    setPixelSize();
    renderGrid("#444");
    drawBoard();
  }

  function runGeneration() {
    $.post('/board/run', function() {
      loadGame();
    });
  }

  function changeMaxAndLoad() {
    min = parseInt($('#min').val());
    max = parseInt($('#max').val());
    if ((max < min) || ((max - min) > 200)) {
      min = max - 200;
      $('#min').val(min);
    }
    loadGame();
  }

  function changeMinAndLoad() {
    min = parseInt($('#min').val());
    max = parseInt($('#max').val());
    if ((max < min) || ((max - min) > 200)) {
      max = min + 200;
      $('#max').val(max);
    }
    loadGame();
  }

  function togglePlay() {
    if ($('#play').is(':visible')) {
      $('#play').hide();
      $('#stop').show();
      playInterval = setInterval(runGeneration, 300);
    } else {
      $('#stop').hide();
      $('#play').show();
      clearInterval(playInterval);
    }
  }


  loadGame();

  $('#next').click(runGeneration);
  $('#max').change(changeMaxAndLoad);
  $('#min').change(changeMinAndLoad);

  $('#play,#stop').click(togglePlay);
});
