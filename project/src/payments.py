from typing import List, Optional
from datetime import datetime
from .database import db
from .models import Payment
from .invoices import invoice_service

class PaymentService:
    def create_payment(self, payment: Payment) -> int:
        """Enregistre un nouveau paiement"""
        payment_id = db.execute_query(
            """
            INSERT INTO payments (invoice_id, montant_paye, methode, caissier, reference)
            VALUES (?, ?, ?, ?, ?)
            """,
            (payment.invoice_id, payment.montant_paye, payment.methode,
             payment.caissier, payment.reference)
        )
        
        # Vérifier si la facture est entièrement payée
        self._update_invoice_status(payment.invoice_id)
        return payment_id
    
    def _update_invoice_status(self, invoice_id: int):
        """Met à jour le statut de la facture en fonction des paiements"""
        # Récupérer le montant total de la facture
        invoice = db.fetch_one("SELECT montant FROM invoices WHERE id = ?", (invoice_id,))
        if not invoice:
            return
        
        # Calculer le total payé
        total_paid = db.fetch_one(
            "SELECT COALESCE(SUM(montant_paye), 0) as total FROM payments WHERE invoice_id = ?",
            (invoice_id,)
        )['total']
        
        # Déterminer le nouveau statut
        if total_paid >= invoice['montant']:
            status = "payee"
        elif total_paid > 0:
            status = "partiellement_payee"
        else:
            status = "impayee"
        
        # Mettre à jour le statut
        invoice_service.update_invoice_status(invoice_id, status)
    
    def get_payment_history(self, student_id: Optional[int] = None) -> List[dict]:
        """Récupère l'historique des paiements"""
        if student_id:
            query = """
            SELECT p.*, i.montant as invoice_montant,
                   s.nom as student_nom, s.prenom as student_prenom,
                   s.matricule, fc.nom as category_nom
            FROM payments p
            JOIN invoices i ON p.invoice_id = i.id
            JOIN students s ON i.student_id = s.id
            JOIN fee_categories fc ON i.category_id = fc.id
            WHERE s.id = ?
            ORDER BY p.date_paiement DESC
            """
            return [dict(row) for row in db.fetch_all(query, (student_id,))]
        else:
            query = """
            SELECT p.*, i.montant as invoice_montant,
                   s.nom as student_nom, s.prenom as student_prenom,
                   s.matricule, fc.nom as category_nom
            FROM payments p
            JOIN invoices i ON p.invoice_id = i.id
            JOIN students s ON i.student_id = s.id
            JOIN fee_categories fc ON i.category_id = fc.id
            ORDER BY p.date_paiement DESC
            """
            return [dict(row) for row in db.fetch_all(query)]
    
    def get_payment_by_id(self, payment_id: int) -> Optional[dict]:
        """Récupère un paiement par son ID avec détails"""
        query = """
        SELECT p.*, i.montant as invoice_montant,
               s.nom as student_nom, s.prenom as student_prenom,
               s.matricule, fc.nom as category_nom
        FROM payments p
        JOIN invoices i ON p.invoice_id = i.id
        JOIN students s ON i.student_id = s.id
        JOIN fee_categories fc ON i.category_id = fc.id
        WHERE p.id = ?
        """
        row = db.fetch_one(query, (payment_id,))
        return dict(row) if row else None

payment_service = PaymentService()