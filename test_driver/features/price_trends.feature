Feature: Price Trends Analytics

  Scenario: Navigating to Price Trends
    Given I am on the "MarketOverviewScreen"
    When I tap the "TrendsTab" button
    Then I should be on the "TrendsRatingsScreen"
    And I should see the text "Динаміка середньої ціни"