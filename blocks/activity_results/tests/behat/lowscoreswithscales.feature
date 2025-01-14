@block @block_activity_results
Feature: The activity results block displays student low scores as scales
  In order to be display student scores as scales
  As a user
  I need to see the activity results block

  Background:
    Given the following "users" exist:
      | username | firstname | lastname | email | idnumber |
      | teacher1 | Teacher | 1 | teacher1@example.com | T1 |
      | student1 | Student | 1 | student1@example.com | S1 |
      | student2 | Student | 2 | student2@example.com | S2 |
      | student3 | Student | 3 | student3@example.com | S3 |
      | student4 | Student | 4 | student4@example.com | S4 |
      | student5 | Student | 5 | student5@example.com | S5 |
    And the following "courses" exist:
      | fullname | shortname | category |
      | Course 1 | C1 | 0 |
    And the following "course enrolments" exist:
      | user | course | role |
      | teacher1 | C1 | editingteacher |
      | student1 | C1 | student |
      | student2 | C1 | student |
      | student3 | C1 | student |
      | student4 | C1 | student |
      | student5 | C1 | student |
    Given the following "activity" exists:
      | activity                      | assign                          |
      | name                          | Test assignment                 |
      | intro                         | Offline text                    |
      | course                        | C1                              |
      | idnumber                      | 0001                            |
      | section                       | 1                               |
      | assignsubmission_file_enabled | 0                               |
    And I log in as "teacher1"
    And I am on "Course 1" course homepage
    And I navigate to "Scales" in the course gradebook
    And I press "Add a new scale"
    And I set the following fields to these values:
      | Name | My Scale |
      | Scale | Disappointing, Not good enough, Average, Good, Very good, Excellent! |
    And I press "Save changes"
    And I am on "Course 1" course homepage with editing mode on
    And I follow "Test assignment"
    And I navigate to "Settings" in current page administration
    And I set the following fields to these values:
      | id_grade_modgrade_type | Scale |
      | id_grade_modgrade_scale | My Scale |
    And I press "Save and return to course"
    And I am on "Course 1" course homepage
    And I navigate to "View > Grader report" in the course gradebook
    And I turn editing mode on
    And I give the grade "Excellent!" to the user "Student 1" for the grade item "Test assignment"
    And I give the grade "Very good" to the user "Student 2" for the grade item "Test assignment"
    And I give the grade "Good" to the user "Student 3" for the grade item "Test assignment"
    And I give the grade "Average" to the user "Student 4" for the grade item "Test assignment"
    And I give the grade "Not good enough" to the user "Student 5" for the grade item "Test assignment"
    And I press "Save changes"
    And I am on "Course 1" course homepage

  Scenario: Configure the block on the course page to show 1 low score
    Given I add the "Activity results" block
    When I configure the "Activity results" block
    And I set the following fields to these values:
      | id_config_showbest | 0 |
      | id_config_showworst | 1 |
      | id_config_gradeformat | Percentages |
      | id_config_nameformat | Display full names |
      | id_config_decimalpoints | 0 |
    And I press "Save changes"
    Then I should see "Student 5" in the "Activity results" "block"
    And I should see "Not good enough" in the "Activity results" "block"

  Scenario: Try to configure the block on the course page to show multiple low scores using full names
    Given I add the "Activity results" block
    When I configure the "Activity results" block
    And I set the following fields to these values:
      | id_config_showbest | 0 |
      | id_config_showworst | 3 |
      | id_config_nameformat | Display full names |
    And I press "Save changes"
    Then I should see "Student 5" in the "Activity results" "block"
    And I should see "Not good enough" in the "Activity results" "block"
    And I should see "Student 4" in the "Activity results" "block"
    And I should see "Average" in the "Activity results" "block"
    And I should see "Student 3" in the "Activity results" "block"
    And I should see "Good" in the "Activity results" "block"

  Scenario: Try to configure the block on the course page to show multiple low scores using ID numbers
    Given the following config values are set as admin:
      | showuseridentity | idnumber,email |
    And I add the "Activity results" block
    When I configure the "Activity results" block
    And I set the following fields to these values:
      | id_config_showbest | 0 |
      | id_config_showworst | 3 |
      | id_config_nameformat | Display only ID numbers |
    And I press "Save changes"
    Then I should see "User S5" in the "Activity results" "block"
    And I should see "Not good enough" in the "Activity results" "block"
    And I should see "User S4" in the "Activity results" "block"
    And I should see "Average" in the "Activity results" "block"
    And I should see "User S3" in the "Activity results" "block"
    And I should see "Good" in the "Activity results" "block"

  Scenario: Try to configure the block on the course page to show multiple low scores using anonymous names
    Given I add the "Activity results" block
    When I configure the "Activity results" block
    And I set the following fields to these values:
      | id_config_showbest | 0 |
      | id_config_showworst | 3 |
      | id_config_nameformat | Anonymous results |
    And I press "Save changes"
    Then I should see "User" in the "Activity results" "block"
    And I should not see "Student 5" in the "Activity results" "block"
    And I should see "Not good enough" in the "Activity results" "block"
    And I should not see "Student 4" in the "Activity results" "block"
    And I should see "Average" in the "Activity results" "block"
    And I should not see "Student 3" in the "Activity results" "block"
    And I should see "Good" in the "Activity results" "block"
