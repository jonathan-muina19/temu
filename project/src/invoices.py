from typing import List, Optional
from .database import db
from .models import Invoice

class InvoiceService:
    def create_invoice(self, invoice: Invoice) -> int:
        """Crée une nouvelle facture"""
        query = """
        INSERT INTO invoices (student_id, category_id, montant, statut)
        VALUES (?, ?, ?, ?)
        """
        return db.execute_query(query, (
            invoice.student_id, invoice.category_id,
            invoice.montant, invoice.statut
        ))
    
    def get_all_invoices(self) -> List[dict]:
        """Récupère toutes les factures avec les détails"""
        query = """
        SELECT i.*, s.nom as student_nom, s.prenom as student_prenom,
               s.matricule, fc.nom as category_nom
        FROM invoices i
        JOIN students s ON i.student_id = s.id
        JOIN fee_categories fc ON i.category_id = fc.id
        ORDER BY i.date_creation DESC
        """
        return [dict(row) for row in db.fetch_all(query)]
    
    def get_unpaid_invoices(self) -> List[dict]:
        """Récupère les factures impayées"""
        query = """
        SELECT i.*, s.nom as student_nom, s.prenom as student_prenom,
               s.matricule, fc.nom as category_nom
        FROM invoices i
        JOIN students s ON i.student_id = s.id
        JOIN fee_categories fc ON i.category_id = fc.id
        WHERE i.statut = 'impayee'
        ORDER BY i.date_creation ASC
        """
        return [dict(row) for row in db.fetch_all(query)]
    
    def get_student_invoices(self, student_id: int) -> List[dict]:
        """Récupère les factures d'un étudiant"""
        query = """
        SELECT i.*, fc.nom as category_nom
        FROM invoices i
        JOIN fee_categories fc ON i.category_id = fc.id
        WHERE i.student_id = ?
        ORDER BY i.date_creation DESC
        """
        return [dict(row) for row in db.fetch_all(query, (student_id,))]
    
    def update_invoice_status(self, invoice_id: int, status: str):
        """Met à jour le statut d'une facture"""
        db.execute_query(
            "UPDATE invoices SET statut = ? WHERE id = ?",
            (status, invoice_id)
        )
    
    def get_invoice_by_id(self, invoice_id: int) -> Optional[dict]:
        """Récupère une facture par son ID avec détails"""
        query = """
        SELECT i.*, s.nom as student_nom, s.prenom as student_prenom,
               s.matricule, fc.nom as category_nom
        FROM invoices i
        JOIN students s ON i.student_id = s.id
        JOIN fee_categories fc ON i.category_id = fc.id
        WHERE i.id = ?
        """
        row = db.fetch_one(query, (invoice_id,))
        return dict(row) if row else None

invoice_service = InvoiceService()