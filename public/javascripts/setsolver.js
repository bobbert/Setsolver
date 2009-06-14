// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

  // toggle_chk( int ): toggles checked status of card at index
  // number passed in as argument
  function toggle_chk( indx ) {
    cell_el  = $('cell' + indx);
    field_el = $('card' + indx);
    // toggle CSS class tags
    if (cell_el.hasClassName('selected'))  {
      cell_el.removeClassName('selected');
      cell_el.addClassName('unselected');
      field_el.value = null;
    } else {
      cell_el.removeClassName('unselected');
      cell_el.addClassName('selected');
      field_el.value = 'SELECTED';
    }
    do_ajax_if_set_selected();
  }

  // num_checked_cards(): returns the number of checked cards
  function num_checked_cards() {
    return $$('td.selected').length;
  }
  // do_ajax_if_set_selected(): sends Ajax request if three cards were selected
  function do_ajax_if_set_selected() {
    if (num_checked_cards == 3) {
      // creating new Ajax request
      new Ajax.Request(document.location, {
        method: 'post',
        onSuccess: parseResponse,
        onFailure: function(xhr) {
          alert(' Error retrieving setsolver data:\n' + xhr.statusText);
        }
      });
    }
  }
