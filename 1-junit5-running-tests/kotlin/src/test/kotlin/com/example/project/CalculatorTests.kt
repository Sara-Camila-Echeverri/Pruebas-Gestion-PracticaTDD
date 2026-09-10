package com.example.project

import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Assertions.assertTrue
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Tag
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.assertAll
import org.junit.jupiter.api.assertThrows
import org.junit.jupiter.params.ParameterizedTest
import org.junit.jupiter.params.provider.CsvSource

@DisplayName("Calculator Tests - Kotlin (JUnit 5)")
class CalculatorKotlinTests {

    private lateinit var calculator: Calculator

    @BeforeEach
    fun setUp() {
        calculator = Calculator()
    }

    @Test
    @DisplayName("1 + 1 = 2")
    @Tag("fast")
    fun `adds two numbers correctly`() {
        assertEquals(2, calculator.add(1, 1), "1 + 1 should equal 2")
    }

    @ParameterizedTest(name = "{0} + {1} = {2}")
    @CsvSource(
        "0,    1,   1",
        "1,    2,   3",
        "49,  51, 100",
        "1,  100, 101"
    )
    fun `add parameterized`(first: Int, second: Int, expectedResult: Int) {
        assertEquals(expectedResult, calculator.add(first, second)) {
            "$first + $second should equal $expectedResult"
        }
    }

    @Test
    @DisplayName("Grouped Assertions with Kotlin assertAll")
    fun `grouped assertions`() {
        assertAll(
            "Operaciones básicas en Kotlin",
            { assertEquals(5, calculator.add(2, 3)) },
            { assertEquals(1, calculator.subtract(3, 2)) },
            { assertEquals(6, calculator.multiply(2, 3)) },
            { assertEquals(2, calculator.divide(6, 3)) }
        )
    }

    @Test
    @DisplayName("Exception Testing with Kotlin assertThrows")
    fun `exception on division by zero`() {
        val exception = assertThrows<IllegalArgumentException> {
            calculator.divide(10, 0)
        }
        assertTrue(exception.message!!.contains("Division by zero"))
    }
}
