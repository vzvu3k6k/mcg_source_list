$(function(){updateResult()});

var $sources = $('#sources');

$sources.on('click', 'input[name^="source-"]', function() {
  updateResult();
});

$('#result .reload').on('click', function() {
  updateResult();
});

function getSelectedSources() {
  var sources = $.map(['source-a', 'source-b'], function(name) {
    var input = $sources.find('input[name="' + name + '"]:checked');
    if (input.length > 0) {
      return { id_str: input.attr('value'), title: input.data("title") };
    } else {
      return null;
    }
  });
  return sources.filter(function(i){return i !== null});
}

function sourcesToUrl(sources) {
  return 'http://mcg.herokuapp.com/' +
    sources.map(function(i){return i.id_str}).join('/') + '/';
}

function updateResult(sources) {
  if(!sources) sources = getSelectedSources();
  if(sources.length == 0) return;
  var $result = $('#result');
  var url = sourcesToUrl(sources);

  $result.addClass('loading');

  $.getJSON(url + 'json')
    .always(function (){
      // Update title
      $result.find('.title').empty()
        .append($('<a />')
                .attr('href', url)
                .text(sources.map(function(i){return i.title}).join(' + ')));

      $result.removeClass('loading');
      $result.removeClass('init');
    })
    .done(function(json) {
      // Update text
      $result.find('.text').empty()
        .text(json.result);

      // Update tweet
      var iframeUrl = 'http://platform.twitter.com/widgets/tweet_button.html?' +
            $.param({
              text: json.result,
              url: url,
              count: 'horizontal'
            });
      $result.find('.tweet iframe').attr('src', iframeUrl);
    })
    .fail(function() {
      // Update text
      $result.find('.text').empty()
        .text('エラー: 更新失敗');

      $result.addClass('failed');
    });
}
