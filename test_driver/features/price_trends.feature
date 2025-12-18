Gherkin
Feature: Price Trends Analytics
  As an analyst
  I want to view price dynamics over time
  So that I can identify the best time to buy or sell

  Scenario: Navigating to Price Trends
    Given I am on the "MarketOverviewScreen"
    When I tap the "TrendsTab" button
    Then I should be on the "TrendsRatingsScreen"
    And I should see the text "Динаміка середньої ціни"
