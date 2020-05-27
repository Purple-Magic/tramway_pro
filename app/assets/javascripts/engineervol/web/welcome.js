var height = $(window).height() * 0.9

function getWidth(height) {
  return height * 0.704 * 2;
};

function turnPageTo(page) {
  $flipbook = $('#flipbook');
  const pagesToTurn = page - $flipbook.turn('page');
  const turnActions = Math.abs(pagesToTurn / 2);
  if (turnActions > 10) {
    $flipbook.turn('page', page);
  } else {
    for (let turn = 0; turn < turnActions; turn++) {
      setTimeout(function() {
        if (pagesToTurn > 0) {
          $flipbook.turn('next');
        } else {
          $flipbook.turn('previous');
        }
      }, 350 * turn);
    } 
  } 
}

function init() {
  $flipbook = $('#flipbook');
  const width = getWidth(height);
  $flipbook.turn({
    width: width,
    height: height
  });

  const $description = $('#description');
  $flipbook.bind('start', function(event, page, view) {
    if (page.page == 1) {
      $description.css('z-index', '-1');
    }
  });
  $flipbook.bind('turned', function(event, page, view) {
    if (page == 1) {
      $description.css('z-index', '999');
    }
  });
  $description.width(width / 3);
  $description.css('top', `${height / 3}px`);
  $description.css('left', `${width / 16}px`);

  const $buttons = $('#buttons');
  $buttons.width(width / 4);
  $buttons.css('top', `${height / 4}px`);
  $buttons.css('right', `${width / 8}px`);

  const $turnThePage = $('#turnThePage');
  $turnThePage.css('bottom', '100px');
  $turnThePage.css('right', `${width / 8}px`);

  $('button.turn-page').click(function(event) {
    turnPageTo($(event.target).data('page'));
  });
  setTimeout(function() {
    $flipbook = $('#flipbook');
    $flipbook.turn('peel', 'br');
  }, 2000);
}

window.addEventListener('resize', function() {
  window_height = $(window).height(); 
  if (window_height < height) {
    $flipbook = $('#flipbook');
    $flipbook.height(window_height);
    $flipbook.turn('size', getWidth(window_height), window_height);
  }
  if ($(window).height() < $(window).width()) {
    $('#rotateDevice').hide();
    $('#rotateBackground').hide();
  } else {
    $('#rotateDevice').show();
    $('#rotateBackground').show();
  }
});

setInterval(function() {
  if ($(window).height() < $(window).width()) {
    $('#rotateDevice').hide();
    $('#rotateBackground').hide();
    $flipbook = $('#flipbook');
    $flipbook.height(window_height);
    $flipbook.turn('size', getWidth(window_height), window_height);
  } else {
    $('#rotateDevice').show();
    $('#rotateBackground').show();
  }
}, 1000);

window.addEventListener('load', function(){
  $('.loader').hide();
  $('.loading').hide();
  $('#description').show();
  $('#buttons').show();
  $('#turnThePage').show();
  init();
});

window.addEventListener('orientationchange', function(){
  location.reload();
});

var isSafari = /^((?!chrome|android).)*safari/i.test(navigator.userAgent);
if (isSafari) {
  $('#safariiOS').show();

  $('#rotateDevice').hide();
  $('#rotateBackground').hide();
  $('#description').hide();
  $('#buttons').hide();
  $('#turnThePage').hide();
  $('.loader').hide();
  $('.loading').hide();
}
