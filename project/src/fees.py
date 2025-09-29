from typing import List, Optional
from .database import db
from .models import FeeCategory

class FeeService:
    def create_fee_category(self, category: FeeCategory) -> int:
        """Crée une nouvelle catégorie de frais"""
        query = """
        INSERT INTO fee_categories (nom, montant, description)
        VALUES (?, ?, ?)
        """
        return db.execute_query(query, (
            category.nom, category.montant, category.description
        ))
    
    def get_all_categories(self) -> List[FeeCategory]:
        """Récupère toutes les catégories de frais"""
        rows = db.fetch_all("SELECT * FROM fee_categories ORDER BY nom")
        return [FeeCategory(
            id=row['id'],
            nom=row['nom'],
            montant=row['montant'],
            description=row['description'],
            created_at=row['created_at']
        ) for row in rows]
    
    def get_category_by_id(self, category_id: int) -> Optional[FeeCategory]:
        """Récupère une catégorie par son ID"""
        row = db.fetch_one("SELECT * FROM fee_categories WHERE id = ?", (category_id,))
        if row:
            return FeeCategory(
                id=row['id'],
                nom=row['nom'],
                montant=row['montant'],
                description=row['description'],
                created_at=row['created_at']
            )
        return None
    
    def update_category(self, category: FeeCategory):
        """Met à jour une catégorie de frais"""
        query = """
        UPDATE fee_categories SET nom = ?, montant = ?, description = ?
        WHERE id = ?
        """
        db.execute_query(query, (
            category.nom, category.montant, category.description, category.id
        ))
    
    def delete_category(self, category_id: int):
        """Supprime une catégorie de frais"""
        db.execute_query("DELETE FROM fee_categories WHERE id = ?", (category_id,))

fee_service = FeeService()