$(document).ready(function() {

  $(':checkbox').hide();
  $('input:submit').hide();

  $('#setboard ul.setboard-row li img').click(function() {
    selectSetCard($(this).parent());
  });

  selectSetCard = function(cell) {
    var chk = cell.find('input:checkbox');
    if (chk.length > 0) {
      was_checked = chk.attr('checked');
      chk.attr('checked', !was_checked);
      was_checked ? cell.removeClass('selected') : cell.addClass('selected');
      if ( $('#setboard ul.setboard-row li.selected input:checkbox:checked').length >= 3 ) {
        sendSetRequest();
      }
    }
  }

  sendSetRequest = function() {
    var checked_params = $.param($('li.selected input:checkbox:checked'));
    var xml_url = $('form').attr('action').replace(/[A-Za-z_]+$/,'refresh');
    $('#submitbar').show();
    $.ajax({
      type: "GET",
      url: (checked_params ? (xml_url + '?' + checked_params): xml_url),
      success: function(xhr) { 
        parseGameXml(xhr);
        resetBoard();
        //$('#setgame').attr('innerHTML', xhr);
      },
      error: function(xml) { 
        resetBoard();
      }
    });
  }

  resetBoard = function() {
    $('#submitbar').hide();
    $('input:checkbox:checked').each(function() {
      selectSetCard($(this).parent());
    });
  }

  // saving image into DOM then loading previewer
  parseGameXml = function(xml) {
    var num_cards = $(xml).find("field_size").text();
    var indx = 0;

    // calculate difference between number of XML cards and number of cards in browser
    var new_field_size_diff = parseInt(num_cards) - $('#setboard ul.setboard-row li').length;

    // call routine to add or remove cards, if new gamefield contains a different number of cards
    while (new_field_size_diff > 0) {
      addCells();
      new_field_size_diff = new_field_size_diff - 3;
    }
    while (new_field_size_diff < 0) {
      removeCells();
      new_field_size_diff = new_field_size_diff + 3;
    }

    $('#notice, #error, #remaining, #num_sets').each(function() {
      $(this).text( $(xml).find(this.id).text() );
    });

    $('#score_listing li span').each(function() {
      $(this).text( $(xml).find('points').text() );
    });

    var img_list = $('#setboard ul.setboard-row li img');

    // find picture and append contents to image viewer
    $(xml).find('card').each(function() {
      //var field_position = $(this).find("field_id").text();
      var set_card_name = $(this).find("name").text();
      var set_card_imgpath = $(this).find("image_path").text();
  
      // run previewer-loading code after image loads
      img_list.eq(indx).attr('title', set_card_name).attr('src', set_card_imgpath);
      indx += 1;
      
    });

    // update activity log on right if new set is found
    if ( $(xml).find('found_set') ) {
      updateActivityLog( $(xml).find('found_set') );
    }

  }

  // adds new column to the right of Set gamefield
  addCells = function() {
    var num_cards = $('#setboard ul.setboard-row li').length;
    $('#setboard').css('width',((num_cards * 101 / 3) + 101) + 'px');
    $('#setboard ul.setboard-row').each(function() {
      var new_item = $(this).find('li').last().clone().attr('id','c_card'+num_cards);
      new_item.appendTo($(this));
      new_item.click = function() { selectSetCard($(new_item).parent()) }
      num_cards += 1;
    });
  }

  // removes rightmost column of Set cards
  removeCells = function() {
    var num_cards = $('#setboard ul.setboard-row li').length;
    $('#setboard').css('width',((num_cards * 101 / 3) - 101) + 'px');
    $('#setboard ul.setboard-row li:last-child').remove();
  }

  // updates activity log: remove set at end of list, and add newly
  updateActivityLog = function(setcard_xml) {
    if ( $('ul#set_records li').length < 4 ) { return true; }  // RWP: temporary hack
    $('ul#set_records li:last').remove();
    var new_col = $('ul#set_records li:first').clone();
    new_col.find('h5').text( $(setcard_xml).find('created_at').text() );
    var set_images = new_col.find('p.setlisting img');
    var indx = 0;

    $(setcard_xml).find('setcard').each(function() {
      var set_card_name = $(this).find('name').text();
      var set_card_imgpath = $(this).find('image_path').text();
      set_images.eq(indx).attr('title', set_card_name).attr('src', set_card_imgpath);
      indx += 1;
    });
    new_col.insertBefore($('ul#set_records li:first'));  // RWP: does not account for first element
    return true;
  }


});

