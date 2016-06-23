// $Id$

/**
 * Hide blocks in sidebars, then make them visible at the click of a button.
 */
if (Drupal.jsEnabled) {
  $(document).ready(function() {
    // Get all div elements of class block inside the left sidebar.
    // Add to that all div elements of class block inside the right sidebar.
    var blocks = $('#sidebar-left div.block, #sidebar-right div.block');

    // Hide them.
    blocks.hide();

    // Add a button that, when clicked, will make them reappear.
    // Translate strings with Drupal.t(), just like t() in PHP code.
    var text = Drupal.t('Show Blocks');
    $('#sidebar-left').prepend('<div id="collapsibutton">' + text + '</div>');
    $('#collapsibutton').css({
      'width': '90px',
      'border': 'solid',
      'border-width': '1px',
      'padding': '5px',
      'background-color': '#fff'
    });

    // Add a handler that runs once when the button is clicked.
    $('#collapsibutton').one('click', function() {
      // Button clicked! Get rid of the button.
      $('#collapsibutton').remove();
      // Display all our hidden blocks using an effect.
      blocks.slideDown("slow");
    });
  });
}