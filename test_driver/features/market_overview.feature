Gherkin
Feature: Market Overview Dashboard
  As a user interested in car analytics
  I want to see the general market statistics
  So that I can understand brand distribution quickly

  Scenario: Successful loading of the Dashboard
    Given the app is running
    When I wait for the "MarketOverviewScreen" to load
    Then I should see the text "Розподіл за Брендами"
    And I should see the widget "BrandPieChart"
