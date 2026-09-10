import unittest
from src.product_service import ProductService, ProductNotFoundError, ValidationError


class TestProductServiceTDD(unittest.TestCase):
    """
    Test suite for Product Management CRUD applying TDD.
    Covers:
    - Create: successful creation and validations (price, stock, empty name).
    - Read: get by ID and list all products.
    - Update: updating details, validations, and not found error.
    - Delete: deleting product and not found error.
    """

    def setUp(self):
        self.service = ProductService()

    # --- CREATE TESTS ---
    def test_create_product_success(self):
        product = self.service.create(name="Laptop Pro", price=1299.99, stock=10)
        self.assertIsNotNone(product.id)
        self.assertEqual(product.name, "Laptop Pro")
        self.assertEqual(product.price, 1299.99)
        self.assertEqual(product.stock, 10)

    def test_create_product_empty_name_raises_validation_error(self):
        with self.assertRaises(ValidationError):
            self.service.create(name="   ", price=100.0, stock=5)

    def test_create_product_negative_price_raises_validation_error(self):
        with self.assertRaises(ValidationError):
            self.service.create(name="Mouse", price=-15.0, stock=5)

    def test_create_product_negative_stock_raises_validation_error(self):
        with self.assertRaises(ValidationError):
            self.service.create(name="Keyboard", price=50.0, stock=-1)

    # --- READ TESTS ---
    def test_get_product_by_id_success(self):
        created = self.service.create(name="Monitor 4K", price=399.99, stock=8)
        found = self.service.get_by_id(created.id)
        self.assertEqual(found.id, created.id)
        self.assertEqual(found.name, "Monitor 4K")

    def test_get_product_by_id_not_found(self):
        with self.assertRaises(ProductNotFoundError):
            self.service.get_by_id("non-existent-id")

    def test_get_all_products(self):
        self.assertEqual(len(self.service.get_all()), 0)
        self.service.create(name="Item A", price=10.0, stock=1)
        self.service.create(name="Item B", price=20.0, stock=2)
        all_products = self.service.get_all()
        self.assertEqual(len(all_products), 2)

    # --- UPDATE TESTS ---
    def test_update_product_success(self):
        created = self.service.create(name="Desk Chair", price=150.0, stock=4)
        updated = self.service.update(created.id, name="Ergonomic Desk Chair", price=180.0, stock=6)
        self.assertEqual(updated.name, "Ergonomic Desk Chair")
        self.assertEqual(updated.price, 180.0)
        self.assertEqual(updated.stock, 6)

    def test_update_product_not_found(self):
        with self.assertRaises(ProductNotFoundError):
            self.service.update("fake-id", name="New Name")

    def test_update_product_invalid_price(self):
        created = self.service.create(name="Desk Lamp", price=25.0, stock=10)
        with self.assertRaises(ValidationError):
            self.service.update(created.id, price=-5.0)

    # --- DELETE TESTS ---
    def test_delete_product_success(self):
        created = self.service.create(name="Webcam HD", price=75.0, stock=12)
        result = self.service.delete(created.id)
        self.assertTrue(result)
        with self.assertRaises(ProductNotFoundError):
            self.service.get_by_id(created.id)

    def test_delete_product_not_found(self):
        with self.assertRaises(ProductNotFoundError):
            self.service.delete("unknown-id")


if __name__ == "__main__":
    unittest.main()
