Feature: Definitions translations
  In order to be able to use predefined steps in native language
  As a step definitions developer
  I need to be able to write definition translations

  Scenario: In place translations
    Given a file named "features/calc_ru.feature" with:
      """
      # language: ru
      Фича: Базовая калькуляция

        Сценарий:
          Допустим Я набрал число 10 на калькуляторе
          И Я набрал число 4 на калькуляторе
          И Я нажал "+"
          То Я должен увидеть на экране 14
      """
    And a file named "features/bootstrap/FeaturesContext.php" with:
      """
      <?php

      require_once 'PHPUnit/Autoload.php';
      require_once 'PHPUnit/Framework/Assert/Functions.php';

      use Behat\Behat\Context\BehatContext, Behat\Behat\Exception\Pending;
      use Behat\Gherkin\Node\PyStringNode,  Behat\Gherkin\Node\TableNode;

      class FeaturesContext extends BehatContext implements Behat\Behat\Context\AnnotatedContextInterface
      {
          private $numbers = array();
          private $result = 0;

          /**
           * @Given /^I have entered (\d+) into calculator$/
           */
          public function iHaveEnteredIntoCalculator($number) {
              $this->numbers[] = intval($number);
          }

          /**
           * @Given /^I have clicked "+"$/
           */
          public function iHaveClickedPlus() {
              $this->result = array_sum($this->numbers);
          }

          /**
           * @Then /^I should see (\d+) on the screen$/
           */
          public function iShouldSeeOnTheScreen($result) {
              assertEquals(intval($result), $this->result);
          }

          public function getI18nResources() {
              return array(__DIR__ . DIRECTORY_SEPARATOR . 'i18n' . DIRECTORY_SEPARATOR . 'ru.xliff');
          }
      }
      """
    And a file named "features/bootstrap/i18n/ru.xliff" with:
      """
      <xliff version="1.2" xmlns="urn:oasis:names:tc:xliff:document:1.2">
        <file original="global" source-language="en" target-language="ru" datatype="plaintext">
          <header />
          <body>
            <trans-unit id="i-have-entered">
              <source>/^I have entered (\d+) into calculator$/</source>
              <target>/^Я набрал число (\d+) на калькуляторе$/</target>
            </trans-unit>
            <trans-unit id="i-have-clicked-plus">
              <source>/^I have clicked "+"$/</source>
              <target>/^Я нажал "([^"]*)"$/</target>
            </trans-unit>
            <trans-unit id="i-should-see">
              <source>/^I should see (\d+) on the screen$/</source>
              <target>/^Я должен увидеть на экране (\d+)$/</target>
            </trans-unit>
          </body>
        </file>
      </xliff>
      """
    When I run "behat -f progress features/calc_ru.feature"
    Then it should pass with:
      """
      ....
      
      1 scenario (1 passed)
      4 steps (4 passed)
      """