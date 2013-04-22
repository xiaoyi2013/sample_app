Feature: Signing in

Scenario: Unsuccessful signin
    Given a user visits the signin page
    When he sumbits invalid signin information
    Then he should see an error message

Scenario: Successful signin
    Given a user visits the signin page
        And the user has a count
        And he submits valid signin information
    Then he should see his profile page
        And he should see a signout link
