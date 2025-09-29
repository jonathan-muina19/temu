import csv
from datetime import datetime
from typing import Dict, Any
from .database import db

class ReportService:
    def get_dashboard_stats(self) -> Dict[str, Any]:
        """Récupère les statistiques pour le tableau de bord"""
        # Total des étudiants
        total_students = db.fetch_one("SELECT COUNT(*) as count FROM students")['count']
        
        # Total des factures
        total_invoices = db.fetch_one("SELECT COUNT(*) as count FROM invoices")['count']
        
        # Total encaissé
        total_collected = db.fetch_one(
            "SELECT COALESCE(SUM(montant_paye), 0) as total FROM payments"
        )['total']
        
        # Total des factures impayées
        total_unpaid = db.fetch_one(
            """
            SELECT COALESCE(SUM(i.montant), 0) as total 
            FROM invoices i 
            WHERE i.statut = 'impayee'
            """
        )['total']
        
        # Total en cours (partiellement payé)
        total_partial = db.fetch_one(
            """
            SELECT COALESCE(SUM(i.montant - COALESCE(p.paid, 0)), 0) as total
            FROM invoices i
            LEFT JOIN (
                SELECT invoice_id, SUM(montant_paye) as paid
                FROM payments
                GROUP BY invoice_id
            ) p ON i.id = p.invoice_id
            WHERE i.statut = 'partiellement_payee'
            """
        )['total']
        
        return {
            'total_students': total_students,
            'total_invoices': total_invoices,
            'total_collected': total_collected,
            'total_unpaid': total_unpaid,
            'total_partial': total_partial,
            'total_outstanding': total_unpaid + total_partial
        }
    
    def export_payments_csv(self, filename: str):
        """Exporte l'historique des paiements en CSV"""
        query = """
        SELECT p.date_paiement, s.matricule, s.nom, s.prenom,
               fc.nom as categorie, p.montant_paye, p.methode, p.caissier
        FROM payments p
        JOIN invoices i ON p.invoice_id = i.id
        JOIN students s ON i.student_id = s.id
        JOIN fee_categories fc ON i.category_id = fc.id
        ORDER BY p.date_paiement DESC
        """
        
        payments = db.fetch_all(query)
        
        with open(filename, 'w', newline='', encoding='utf-8') as csvfile:
            fieldnames = ['Date', 'Matricule', 'Nom', 'Prénom', 'Catégorie', 
                         'Montant Payé', 'Méthode', 'Caissier']
            writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
            
            writer.writeheader()
            for payment in payments:
                writer.writerow({
                    'Date': payment['date_paiement'],
                    'Matricule': payment['matricule'],
                    'Nom': payment['nom'],
                    'Prénom': payment['prenom'],
                    'Catégorie': payment['categorie'],
                    'Montant Payé': payment['montant_paye'],
                    'Méthode': payment['methode'],
                    'Caissier': payment['caissier']
                })
    
    def export_unpaid_invoices_csv(self, filename: str):
        """Exporte la liste des factures impayées en CSV"""
        query = """
        SELECT s.matricule, s.nom, s.prenom, fc.nom as categorie,
               i.montant, i.date_creation
        FROM invoices i
        JOIN students s ON i.student_id = s.id
        JOIN fee_categories fc ON i.category_id = fc.id
        WHERE i.statut = 'impayee'
        ORDER BY i.date_creation ASC
        """
        
        invoices = db.fetch_all(query)
        
        with open(filename, 'w', newline='', encoding='utf-8') as csvfile:
            fieldnames = ['Matricule', 'Nom', 'Prénom', 'Catégorie', 
                         'Montant', 'Date Création']
            writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
            
            writer.writeheader()
            for invoice in invoices:
                writer.writerow({
                    'Matricule': invoice['matricule'],
                    'Nom': invoice['nom'],
                    'Prénom': invoice['prenom'],
                    'Catégorie': invoice['categorie'],
                    'Montant': invoice['montant'],
                    'Date Création': invoice['date_creation']
                })

report_service = ReportService()