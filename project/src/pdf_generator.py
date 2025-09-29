from fpdf import FPDF
from datetime import datetime
from typing import Dict, Any

class ReceiptGenerator:
    def __init__(self):
        self.pdf = FPDF()
        
    def generate_receipt(self, payment_data: Dict[str, Any], filename: str):
        """Génère un reçu de paiement en PDF"""
        self.pdf.add_page()
        
        # Configuration de la police
        self.pdf.set_font('Arial', 'B', 16)
        
        # En-tête
        self.pdf.cell(0, 10, 'REÇU DE PAIEMENT', ln=True, align='C')
        self.pdf.ln(10)
        
        # Informations de l'établissement
        self.pdf.set_font('Arial', 'B', 12)
        self.pdf.cell(0, 8, 'UNIVERSITÉ EXEMPLE', ln=True, align='C')
        self.pdf.set_font('Arial', '', 10)
        self.pdf.cell(0, 6, 'Service de Gestion des Frais Académiques', ln=True, align='C')
        self.pdf.ln(10)
        
        # Numéro de reçu et date
        self.pdf.set_font('Arial', 'B', 10)
        self.pdf.cell(100, 6, f"N° Reçu: {payment_data.get('id', 'N/A'):06d}")
        self.pdf.cell(0, 6, f"Date: {datetime.now().strftime('%d/%m/%Y %H:%M')}", ln=True, align='R')
        self.pdf.ln(5)
        
        # Informations de l'étudiant
        self.pdf.set_font('Arial', 'B', 11)
        self.pdf.cell(0, 8, 'INFORMATIONS ÉTUDIANT', ln=True)
        self.pdf.set_font('Arial', '', 10)
        self.pdf.cell(0, 6, f"Matricule: {payment_data.get('matricule', 'N/A')}", ln=True)
        self.pdf.cell(0, 6, f"Nom: {payment_data.get('student_nom', 'N/A')} {payment_data.get('student_prenom', 'N/A')}", ln=True)
        self.pdf.ln(5)
        
        # Détails du paiement
        self.pdf.set_font('Arial', 'B', 11)
        self.pdf.cell(0, 8, 'DÉTAILS DU PAIEMENT', ln=True)
        
        # Tableau des détails
        self.pdf.set_font('Arial', 'B', 10)
        self.pdf.cell(80, 8, 'Catégorie de frais', 1, 0, 'C')
        self.pdf.cell(40, 8, 'Montant facturé', 1, 0, 'C')
        self.pdf.cell(40, 8, 'Montant payé', 1, 1, 'C')
        
        self.pdf.set_font('Arial', '', 10)
        self.pdf.cell(80, 8, payment_data.get('category_nom', 'N/A'), 1, 0, 'L')
        self.pdf.cell(40, 8, f"{payment_data.get('invoice_montant', 0):,.0f} FCFA", 1, 0, 'R')
        self.pdf.cell(40, 8, f"{payment_data.get('montant_paye', 0):,.0f} FCFA", 1, 1, 'R')
        
        self.pdf.ln(5)
        
        # Informations supplémentaires
        self.pdf.set_font('Arial', '', 10)
        self.pdf.cell(0, 6, f"Méthode de paiement: {payment_data.get('methode', 'N/A')}", ln=True)
        if payment_data.get('reference'):
            self.pdf.cell(0, 6, f"Référence: {payment_data.get('reference')}", ln=True)
        self.pdf.cell(0, 6, f"Caissier: {payment_data.get('caissier', 'N/A')}", ln=True)
        self.pdf.ln(10)
        
        # Total en lettres (simplifié)
        montant = payment_data.get('montant_paye', 0)
        self.pdf.set_font('Arial', 'B', 10)
        self.pdf.cell(0, 6, f"Arrêté le présent reçu à la somme de: {int(montant):,} FCFA", ln=True)
        self.pdf.ln(10)
        
        # Signature
        self.pdf.cell(0, 6, 'Signature du caissier: ____________________', ln=True, align='R')
        
        # Sauvegarder le PDF
        self.pdf.output(filename)
        return filename

pdf_generator = ReceiptGenerator()