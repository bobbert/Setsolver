$(document).ready(function() {

  $(':checkbox').hide();
  $('input:submit').hide();

  $('#setgame table tr td').click(function() {
    selectSetCard($(this));
  });

  $('#setgame table tr td input:checkbox').change(function() {
    is_checked = $(this).attr('checked');
  });

  selectSetCard = function(cell) {
    var chk = cell.find('input:checkbox');
    if (chk.length > 0) {
      was_checked = chk.attr('checked');
      chk.attr('checked', !was_checked);
      was_checked ? cell.removeClass('selected') : cell.addClass('selected');
      if ( $('td.selected input:checkbox:checked').length >= 3 ) {
        sendSetRequest();
      }
    }
  }

  sendSetRequest = function() {
    var checked_params = $.param($('td.selected input:checkbox:checked'));
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

    $('#notice, #error, #remaining, #num_sets').each(function() {
      $(this).text( $(xml).find(this.id).text() );
    });

    // RWP TEMP: if num_cards != number of nodes in webpage: call routine to add/remove nodes

    // get list of all set card images
    var img_list = $('#setboard tr td img');

    // find picture and append contents to image viewer
    $(xml).find("card").each(function()
    {
      //var field_position = $(this).find("field_id").text();
      var set_card_name = $(this).find("name").text();
      var set_card_imgpath = $(this).find("image_path").text();
  
      // run previewer-loading code after image loads
      img_list.eq(indx).attr('title', set_card_name).attr('src', set_card_imgpath);
      indx += 1;
      
    });
  }

});

// application.js: Setsolver-specific JavaScript functions and classes.
/* This file is automatically included by javascript_include_tag :defaults

  // toggle_chk( int ): toggles checked status of card at index
  // number passed in as argument
  function toggle_chk( indx ) {
    cell_el  = $('cell' + indx);
    field_el = $('card' + indx);

    selectCard( cell_el, field_el, !(cell_el.hasClassName('selected')) );
     doAjaxIfSetSelected();
  }

  // function selectCard( el, isSelected ): handles selection or unselection of a card element
  function selectCard( cell_el, form_el, isSelected ) {
    cell_el.removeClassName((isSelected ? 'unselected' : 'selected'));
    cell_el.addClassName((isSelected ? 'selected' : 'unselected'));
    form_el.value = ((isSelected ? 'SELECTED' : null))
    }

  // num_checked_cards(): returns the number of checked cards
  function num_checked_cards() {
    return $$('td.selected').length;
  }
  // doAjaxIfSetSelected(): sends Ajax request if three cards were selected
  function doAjaxIfSetSelected() {
    if ((num_checked_cards() == 3) && ($$('form').length == 1)) {
      // creating new Ajax request, and setting XML response to replace old table if
      // successful
      var frm = $$('form')[0];
      frm.request({
        onComplete: function(xhr) {
          $('setgame').innerHTML = xhr.responseText;
        }
      });
    }
  }

*/

