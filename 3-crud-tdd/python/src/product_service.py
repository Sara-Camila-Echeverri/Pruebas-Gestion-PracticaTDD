import uuid
from dataclasses import dataclass
from typing import Dict, List, Optional


class ProductNotFoundError(Exception):
    """Raised when a product with the given ID does not exist."""
    pass


class ValidationError(Exception):
    """Raised when input validation fails."""
    pass


@dataclass
class Product:
    id: str
    name: str
    price: float
    stock: int


class ProductService:
    """
    CRUD Service for managing products in inventory.
    Implements Create, Read, Update, Delete with validation.
    """

    def __init__(self):
        self._products: Dict[str, Product] = {}

    def create(self, name: str, price: float, stock: int) -> Product:
        if not name or not name.strip():
            raise ValidationError("El nombre del producto no puede estar vacío.")
        if price < 0:
            raise ValidationError("El precio no puede ser negativo.")
        if stock < 0:
            raise ValidationError("El stock no puede ser negativo.")

        product_id = str(uuid.uuid4())
        product = Product(id=product_id, name=name.strip(), price=float(price), stock=int(stock))
        self._products[product_id] = product
        return product

    def get_by_id(self, product_id: str) -> Product:
        if product_id not in self._products:
            raise ProductNotFoundError(f"Producto con ID {product_id} no encontrado.")
        return self._products[product_id]

    def get_all(self) -> List[Product]:
        return list(self._products.values())

    def update(
        self,
        product_id: str,
        name: Optional[str] = None,
        price: Optional[float] = None,
        stock: Optional[int] = None,
    ) -> Product:
        product = self.get_by_id(product_id)

        if name is not None:
            if not name.strip():
                raise ValidationError("El nombre del producto no puede estar vacío.")
            product.name = name.strip()

        if price is not None:
            if price < 0:
                raise ValidationError("El precio no puede ser negativo.")
            product.price = float(price)

        if stock is not None:
            if stock < 0:
                raise ValidationError("El stock no puede ser negativo.")
            product.stock = int(stock)

        return product

    def delete(self, product_id: str) -> bool:
        self.get_by_id(product_id)
        del self._products[product_id]
        return True
