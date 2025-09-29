import flet as ft
from datetime import datetime
from ..payments import payment_service
from ..invoices import invoice_service
from ..students import student_service
from ..fees import fee_service
from ..models import Payment, Invoice
from ..pdf_generator import pdf_generator
from ..auth import auth_service
import os

class PaymentManagementView:
    def __init__(self, page: ft.Page):
        self.page = page
        self.students = []
        self.fee_categories = []
        self.payments = []
        
        # Dropdowns
        self.student_dropdown = ft.Dropdown(label="Sélectionner un étudiant", width=300)
        self.fee_dropdown = ft.Dropdown(label="Sélectionner un frais", width=300)
        
        # Champs
        self.montant_field = ft.TextField(label="Montant à payer", width=200)
        self.methode_dropdown = ft.Dropdown(
            label="Méthode de paiement",
            width=200,
            options=[
                ft.dropdown.Option("especes", "Espèces"),
                ft.dropdown.Option("cheque", "Chèque"),
                ft.dropdown.Option("virement", "Virement"),
                ft.dropdown.Option("carte", "Carte bancaire")
            ],
            value="especes"
        )
        self.reference_field = ft.TextField(label="Référence (optionnel)", width=200)
        
        # Tableau des paiements
        self.payments_table = ft.DataTable(
            columns=[
                ft.DataColumn(ft.Text("Date")),
                ft.DataColumn(ft.Text("Étudiant")),
                ft.DataColumn(ft.Text("Frais")),
                ft.DataColumn(ft.Text("Montant")),
                ft.DataColumn(ft.Text("Méthode")),
                ft.DataColumn(ft.Text("Actions")),
            ],
            rows=[]
        )
    
    def load_data(self):
        """Charge les données nécessaires"""
        self.students = student_service.get_all_students()
        self.fee_categories = fee_service.get_all_categories()
        self.payments = payment_service.get_payment_history()
        
        # Met à jour les dropdowns
        self.student_dropdown.options = [
            ft.dropdown.Option(str(s.id), f"{s.matricule} - {s.prenom} {s.nom}")
            for s in self.students
        ]
        
        self.fee_dropdown.options = [
            ft.dropdown.Option(str(f.id), f"{f.nom} ({f.montant:,.0f} FCFA)")
            for f in self.fee_categories
        ]
        
        self.update_payments_table()
        self.page.update()
    
    def update_payments_table(self):
        """Met à jour le tableau des paiements"""
        self.payments_table.rows.clear()
        for payment in self.payments[:20]:  # Derniers 20 paiements
            self.payments_table.rows.append(
                ft.DataRow(
                    cells=[
                        ft.DataCell(ft.Text(payment['date_paiement'][:10])),
                        ft.DataCell(ft.Text(f"{payment['student_prenom']} {payment['student_nom']}")),
                        ft.DataCell(ft.Text(payment['category_nom'])),
                        ft.DataCell(ft.Text(f"{payment['montant_paye']:,.0f} FCFA")),
                        ft.DataCell(ft.Text(payment['methode'].title())),
                        ft.DataCell(ft.IconButton(
                            icon=ft.icons.PRINT,
                            tooltip="Imprimer reçu",
                            on_click=lambda e, p=payment: self.generate_receipt(p)
                        ))
                    ]
                )
            )
    
    def process_payment(self, e):
        """Traite un nouveau paiement"""
        if not all([self.student_dropdown.value, self.fee_dropdown.value, self.montant_field.value]):
            self.page.show_snack_bar(ft.SnackBar(content=ft.Text("Veuillez remplir tous les champs obligatoires")))
            return
        
        try:
            montant = float(self.montant_field.value)
            if montant <= 0:
                self.page.show_snack_bar(ft.SnackBar(content=ft.Text("Le montant doit être positif")))
                return
            
            # Créer d'abord une facture si elle n'existe pas
            student_id = int(self.student_dropdown.value)
            category_id = int(self.fee_dropdown.value)
            
            # Récupérer le montant de la catégorie
            category = fee_service.get_category_by_id(category_id)
            
            # Créer une facture
            invoice = Invoice(
                id=None,
                student_id=student_id,
                category_id=category_id,
                montant=category.montant,
                statut="impayee"
            )
            
            invoice_id = invoice_service.create_invoice(invoice)
            
            # Créer le paiement
            payment = Payment(
                id=None,
                invoice_id=invoice_id,
                montant_paye=montant,
                methode=self.methode_dropdown.value,
                caissier=auth_service.current_user.username if auth_service.current_user else "Anonyme",
                reference=self.reference_field.value if self.reference_field.value else None
            )
            
            payment_id = payment_service.create_payment(payment)
            
            self.page.show_snack_bar(ft.SnackBar(content=ft.Text("Paiement enregistré avec succès")))
            
            # Générer automatiquement le reçu
            payment_data = payment_service.get_payment_by_id(payment_id)
            if payment_data:
                self.generate_receipt(payment_data)
            
            self.clear_form()
            self.load_data()
            
        except ValueError:
            self.page.show_snack_bar(ft.SnackBar(content=ft.Text("Montant invalide")))
        except Exception as ex:
            self.page.show_snack_bar(ft.SnackBar(content=ft.Text(f"Erreur: {str(ex)}")))
    
    def generate_receipt(self, payment_data):
        """Génère un reçu PDF"""
        try:
            os.makedirs("exports", exist_ok=True)
            filename = f"exports/recu_{payment_data['id']:06d}.pdf"
            
            pdf_generator.generate_receipt(payment_data, filename)
            
            self.page.show_snack_bar(
                ft.SnackBar(content=ft.Text(f"Reçu généré: {filename}"))
            )
            
        except Exception as ex:
            self.page.show_snack_bar(ft.SnackBar(content=ft.Text(f"Erreur génération PDF: {str(ex)}")))
    
    def clear_form(self):
        """Vide le formulaire"""
        self.student_dropdown.value = None
        self.fee_dropdown.value = None
        self.montant_field.value = ""
        self.methode_dropdown.value = "especes"
        self.reference_field.value = ""
        self.page.update()
    
    def build(self):
        self.load_data()
        
        # Section formulaire de paiement
        payment_form = ft.Card(
            content=ft.Container(
                content=ft.Column([
                    ft.Text("Nouveau Paiement", size=18, weight=ft.FontWeight.BOLD),
                    ft.Row([
                        self.student_dropdown,
                        self.fee_dropdown
                    ], wrap=True),
                    ft.Row([
                        self.montant_field,
                        self.methode_dropdown,
                        self.reference_field
                    ], wrap=True),
                    ft.Row([
                        ft.ElevatedButton(
                            text="Enregistrer Paiement",
                            icon=ft.icons.PAYMENT,
                            on_click=self.process_payment,
                            style=ft.ButtonStyle(bgcolor=ft.colors.GREEN_600)
                        ),
                        ft.ElevatedButton(
                            text="Nouveau",
                            icon=ft.icons.ADD,
                            on_click=lambda e: self.clear_form(),
                            style=ft.ButtonStyle(bgcolor=ft.colors.BLUE_600)
                        )
                    ])
                ]),
                padding=ft.padding.all(20)
            )
        )
        
        # Section historique des paiements
        history_section = ft.Card(
            content=ft.Container(
                content=ft.Column([
                    ft.Text("Historique des Paiements", size=18, weight=ft.FontWeight.BOLD),
                    ft.Container(
                        content=self.payments_table,
                        scroll=ft.ScrollMode.AUTO,
                        height=400
                    )
                ]),
                padding=ft.padding.all(20)
            )
        )
        
        return ft.Column([
            ft.Container(
                content=ft.Text(
                    "GESTION DES PAIEMENTS",
                    size=24,
                    weight=ft.FontWeight.BOLD,
                    color=ft.colors.BLUE_700
                ),
                padding=ft.padding.all(20)
            ),
            payment_form,
            history_section
        ], scroll=ft.ScrollMode.AUTO)