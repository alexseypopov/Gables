Feature: Search field with filtered results
  As a user of the gables mobile site
  I want the ability to type in query and receive filtered results
  So that I may select only the important property to me

  Scenario:
    Given a search field
    When I type in "Atlanta"
    Then I should see a filtered set of results


Feature Navigation button
  As a user of the Gables mobile site
  I want the ability to select a predetermined set of places to visit
  So that I may minimize the time needed to navigate the site


Feature Find Near Me button
  As a user of the Gables mobile site
  I want the ability to find properties near my current location
  So the I may see only the closest properties to me


Feature Find By
  As a user of the Gables mobile site
  I want to find properties by property name
  So that I may find a specific property

Feature
  As a user of the Gables mobile site