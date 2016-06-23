<?php
// $Id$

/**
 * Return a description of the profile for the initial installation screen.
 *
 * @return
 *   An array with keys 'name' and 'description' describing this profile,
 *   and optional 'language' to override the language selection for
 *   language-specific profiles, e.g., 'language' => 'fr'.
 */
function university_profile_details() {
  return array(
    'name' => 'Drupal (Customized for Iowa State University)',
    'description' => 'Select this profile to enable settings typical for a departmental website.',
  );
}

/**
 * Return a list of tasks that this profile supports.
 *
 * @return
 *   A keyed array of tasks the profile will perform during
 *   the final stage. The keys of the array will be used internally,
 *   while the values will be displayed to the user in the installer
 *   task list.
 */
function university_profile_task_list() {
  return array(
    'dept-info' => st('Departmental Info'),
    'support-message' => t('Support'),
  );
}

/**
 * Return an array of the modules to be enabled when this profile is installed.
 *
 * The following required core modules are always enabled:
 * 'block', 'filter', 'node', 'system', 'user'.
 *
 * @return
 *  An array of modules to be enabled.
 */
function university_profile_modules() {
  return array(
    // Enable optional core modules.
    'dblog', 'color', 'help', 'taxonomy', 'throttle', 'search', 'statistics',

    // Enable single signon by enabling a contributed module.
    'pubcookie',
  );
}

/**
 * Perform final installation tasks for this installation profile.
 */
function university_profile_tasks(&$task, $url) {
  if ($task == 'profile') {
    // $task is set to 'profile' the first time this function is called.
    // Set up all the things a default installation profile has.
    require_once 'profiles/default/default.profile';

    // Need constants defined by modules/comment/comment.module
    // to be in scope.
    require_once 'modules/comment/comment.module';
    default_profile_tasks($task, $url);
    
    // But we don't want to use the story node type.
    node_type_delete('story');
    
    // If the administrator enables the comment module, we want
    // to have comments disabled for pages.
    variable_set('comment_page', COMMENT_NODE_DISABLED);

    // Define a node type, 'news'.
    $node_type = array(
      'type' => 'news',
      'name' => st('News Item'),
      'module' => 'node',
      'description' => st('A news item for the front page.'),
      'custom' => TRUE,
      'modified' => TRUE,
      'locked' => FALSE,
      'has_title' => TRUE,
      'title_label' => st('Title'),
      'has_body' => TRUE,
      'orig_type' => 'news',
      'is_new' => TRUE,
    );
    node_type_save((object) $node_type);

    // News items should be published and promoted to front page by default.
    // News items should create new revisions by default.
    variable_set('node_options_news', array('status', 'revision', 'promote'));

    // If the administrator enables the comment module, we want
    // to have comments enabled for news items.
    variable_set('comment_news', COMMENT_NODE_READ_WRITE);

    // Create a News Categories vocabulary so news can be classified.
    $vocabulary = array(
      'name' => t('News Categories'),
      'description' => st('Select the appropriate audience for your news item.'),
      'help' => st('You may select multiple audiences.'),
      'nodes' => array('news' => st('News Item')),
      'hierarchy' => 0,
      'relations' => 0,
      'tags' => 0,
      'multiple' => 1,
      'required' => 0,
    );
    taxonomy_save_vocabulary($vocabulary);

    // Define some terms to categorize news items.
    $terms = array(
      st('Departmental News'),
      st('Faculty News'),
      st('Staff News'),
      st('Student News'),
    );

    // Submit the "Add term" form programmatically for each term.
    $form_id = 'taxonomy_form_term';
    // The taxonomy_form_term form is not in taxonomy.module, so need
    // to bring it into scope by loading taxonomy.admin.inc.
    require_once 'modules/taxonomy/taxonomy.admin.inc';
    foreach ($terms as $name) {
      $form_state['values']['name'] = $name;
      $form_state['clicked_button']['#value'] = st('Save');
      drupal_execute($form_id, $form_state, (object)$vocabulary);
    }

    // Add a role.
    db_query("INSERT INTO {role} (name) VALUES ('%s')", 'site administrator');

    // Configure the pubcookie module.
    variable_set('pubcookie_login_dir', 'login');
    variable_set('pubcookie_id_is_email', 1);
    // ...other settings go here

    // Set $task to next task so the UI will be correct.
    $task = 'dept-info';
    drupal_set_title(st('Departmental Information'));
    return drupal_get_form('university_department_info', $url);
  }

  if ($task == 'dept-info') {
    // Report by email that a new Drupal site has been installed.
    $to = 'administrator@example.com';
    $from = ini_get('sendmail_from');
    $subject = st('New Drupal site created!');
    $body = st('A new Drupal site was created: @site', array('@site' => base_path()));
   // drupal_mail('university-profile', $to, $subject, $body, $from);
    $task = 'support-message';
    drupal_set_title(st('Support'));
    $output = '<p>'. st('For support, please contact the Drupal Support Desk at 123-4567.') .'</p>';
    $output .= '<p>'. l(st('Continue'), $url) .'</p>';
    return $output;
  }

  if ($task == 'support-message') {
    // Change to our custom theme.
    $themes = system_theme_data();
    $theme = 'university';
    if (isset($themes[$theme])) {
      system_initialize_theme_blocks($theme);
      db_query("UPDATE {system} SET status = 1 WHERE type = 'theme' and name = '%s'", $theme);
      variable_set('theme_default', $theme);
      menu_rebuild();
      drupal_rebuild_theme_registry();
    }
    
    // Return control to the installer.
    $task = 'profile-finished';
  }
}

/**
 * Defines form used by our dept-info installer task.
 *
 * @param $form_state
 * @param $url
 *   URL of current installer page, provided by installer.
 */
function university_department_info($form_state, $url) {
  $form['#action'] = $url;
  $form['#redirect'] = FALSE;
  $form['department_code'] = array(
    '#type' => 'select',
    '#title' => st('Departmental code'),
    '#description' => st('Please select the correct code for your department.'),
    '#options' => array('BIOL', 'CHEM', 'COMP', 'ENGI', 'ENGL', 'HIST', 'MATH', 'LANG', 'PHYS', 'PHIL'),
  );
  $form['submit'] = array(
    '#type' => 'submit',
    '#value' => st('Save and Continue'),
  );
  return $form;
}

/**
 * Handles form submission for university_department_info form.
 */
function university_department_info_submit($form, &$form_state) {
  variable_set('department_code', $form_state['values']['department_code']);
}
