import flet as ft
from ..reports import report_service

class DashboardView:
    def __init__(self, page: ft.Page):
        self.page = page
        self.stats = {}
    
    def refresh_stats(self):
        """Met à jour les statistiques"""
        self.stats = report_service.get_dashboard_stats()
    
    def build(self):
        self.refresh_stats()
        
        # Cartes statistiques
        stats_cards = ft.Row([
            self._create_stat_card(
                "Étudiants", 
                str(self.stats.get('total_students', 0)),
                ft.icons.PEOPLE,
                ft.colors.BLUE_600
            ),
            self._create_stat_card(
                "Total Factures", 
                str(self.stats.get('total_invoices', 0)),
                ft.icons.RECEIPT,
                ft.colors.GREEN_600
            ),
            self._create_stat_card(
                "Total Encaissé", 
                f"{self.stats.get('total_collected', 0):,.0f} FCFA",
                ft.icons.PAYMENTS,
                ft.colors.ORANGE_600
            ),
            self._create_stat_card(
                "Impayés", 
                f"{self.stats.get('total_outstanding', 0):,.0f} FCFA",
                ft.icons.WARNING,
                ft.colors.RED_600
            ),
        ], wrap=True)
        
        return ft.Column([
            ft.Container(
                content=ft.Text(
                    "TABLEAU DE BORD",
                    size=24,
                    weight=ft.FontWeight.BOLD,
                    color=ft.colors.BLUE_700
                ),
                padding=ft.padding.all(20)
            ),
            ft.Container(
                content=stats_cards,
                padding=ft.padding.all(20)
            ),
            ft.Container(
                content=ft.Column([
                    ft.Text(
                        "Actions Rapides",
                        size=18,
                        weight=ft.FontWeight.BOLD
                    ),
                    ft.Row([
                        ft.ElevatedButton(
                            text="Nouveau Paiement",
                            icon=ft.icons.ADD_CARD,
                            on_click=lambda _: self.page.go("/payments"),
                            style=ft.ButtonStyle(bgcolor=ft.colors.GREEN_600)
                        ),
                        ft.ElevatedButton(
                            text="Gérer Étudiants",
                            icon=ft.icons.PEOPLE_ALT,
                            on_click=lambda _: self.page.go("/students"),
                            style=ft.ButtonStyle(bgcolor=ft.colors.BLUE_600)
                        ),
                        ft.ElevatedButton(
                            text="Rapports",
                            icon=ft.icons.ANALYTICS,
                            on_click=lambda _: self.page.go("/reports"),
                            style=ft.ButtonStyle(bgcolor=ft.colors.PURPLE_600)
                        ),
                    ], wrap=True)
                ]),
                padding=ft.padding.all(20)
            )
        ])
    
    def _create_stat_card(self, title, value, icon, color):
        return ft.Card(
            content=ft.Container(
                content=ft.Column([
                    ft.Row([
                        ft.Icon(icon, color=color, size=30),
                        ft.Column([
                            ft.Text(title, size=12, color=ft.colors.GREY_600),
                            ft.Text(value, size=18, weight=ft.FontWeight.BOLD)
                        ], spacing=2)
                    ], alignment=ft.MainAxisAlignment.SPACE_BETWEEN)
                ], spacing=10),
                padding=ft.padding.all(20),
                width=250
            ),
            elevation=4
        )