Feature: Market Overview Dashboard

  Scenario: Successful loading of the Dashboard
    Given the app is running
    When I wait for the "MarketOverviewScreen" to load
    Then I should see the text "Розподіл за Брендами"
    And I should see the widget "BrandPieChart"