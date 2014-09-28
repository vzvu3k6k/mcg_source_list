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

  if (sources[0] && sources[1] && sources[0].id_str === sources[1].id_str) {
    sources = [sources[0]];
  }

  return sources.filter(function(i){return i !== null});
}

function sourcesToUrl(sources) {
  return 'http://mcg.herokuapp.com/' +
    sources.map(function(i){return i.id_str}).join('/') + '/';
}

var lastXHR;
function updateResult(sources) {
  if (!sources) sources = getSelectedSources();
  if (sources.length == 0) return;
  if (lastXHR) lastXHR.abort();
  var $result = $('#result');
  var url = sourcesToUrl(sources);

  $result.attr('data-status', 'loading');

  lastXHR = $.getJSON(url + 'json')
    .always(function (){
      // Update title
      $result.find('.title').empty()
        .append($('<a />')
                .attr('href', url)
                .text(sources.map(function(i){return i.title}).join(' + ')));

      lastXHR = null;
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

      $result.attr('data-status', 'succeeded');
    })
    .fail(function() {
      // Update text
      $result.find('.text').empty()
        .text('エラー: 更新失敗');

      $result.attr('data-status', 'failed');
    });
}
