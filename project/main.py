import flet as ft
from src.ui.login import LoginView
from src.ui.dashboard import DashboardView
from src.ui.student_management import StudentManagementView
from src.ui.payment_management import PaymentManagementView
from src.auth import auth_service

def main(page: ft.Page):
    page.title = "Gestion des Frais Académiques"
    page.theme_mode = ft.ThemeMode.LIGHT
    page.window_width = 1200
    page.window_height = 800
    page.window_min_width = 800
    page.window_min_height = 600
    page.scroll = ft.ScrollMode.AUTO
    
    # Navigation
    def route_change(route):
        page.views.clear()
        
        if not auth_service.is_authenticated() and page.route != "/":
            page.go("/")
            return
        
        # Page de connexion
        if page.route == "/":
            if auth_service.is_authenticated():
                page.go("/dashboard")
                return
            
            login_view = LoginView(page, on_login_success)
            page.views.append(
                ft.View(
                    "/",
                    [login_view.build()],
                    bgcolor=ft.colors.GREY_100
                )
            )
        
        # Tableau de bord
        elif page.route == "/dashboard":
            dashboard_view = DashboardView(page)
            page.views.append(create_main_view("/dashboard", dashboard_view.build()))
        
        # Gestion des étudiants
        elif page.route == "/students":
            student_view = StudentManagementView(page)
            page.views.append(create_main_view("/students", student_view.build()))
        
        # Gestion des paiements
        elif page.route == "/payments":
            payment_view = PaymentManagementView(page)
            page.views.append(create_main_view("/payments", payment_view.build()))
        
        page.update()
    
    def on_login_success(user):
        """Callback après connexion réussie"""
        page.show_snack_bar(
            ft.SnackBar(content=ft.Text(f"Bienvenue {user.username}!"))
        )
        page.go("/dashboard")
    
    def logout_clicked(e):
        """Déconnexion"""
        auth_service.logout()
        page.go("/")
    
    def create_main_view(route, content):
        """Crée une vue avec navigation"""
        # Barre de navigation
        nav_bar = ft.NavigationBar(
            destinations=[
                ft.NavigationDestination(
                    icon=ft.icons.DASHBOARD,
                    label="Tableau de bord"
                ),
                ft.NavigationDestination(
                    icon=ft.icons.PEOPLE,
                    label="Étudiants"
                ),
                ft.NavigationDestination(
                    icon=ft.icons.PAYMENT,
                    label="Paiements"
                ),
            ],
            selected_index=get_nav_index(route),
            on_change=nav_changed
        )
        
        # En-tête
        header = ft.AppBar(
            title=ft.Text("Gestion des Frais Académiques"),
            bgcolor=ft.colors.BLUE_700,
            color=ft.colors.WHITE,
            actions=[
                ft.PopupMenuButton(
                    items=[
                        ft.PopupMenuItem(
                            text=f"Utilisateur: {auth_service.current_user.username if auth_service.current_user else 'Anonyme'}"
                        ),
                        ft.PopupMenuItem(),  # Séparateur
                        ft.PopupMenuItem(
                            text="Déconnexion",
                            icon=ft.icons.LOGOUT,
                            on_click=logout_clicked
                        )
                    ]
                )
            ]
        )
        
        return ft.View(
            route,
            [
                header,
                ft.Container(content=content, expand=True),
                nav_bar
            ],
            scroll=ft.ScrollMode.AUTO
        )
    
    def get_nav_index(route):
        """Retourne l'index de navigation selon la route"""
        routes = {
            "/dashboard": 0,
            "/students": 1,
            "/payments": 2
        }
        return routes.get(route, 0)
    
    def nav_changed(e):
        """Gère les changements de navigation"""
        routes = ["/dashboard", "/students", "/payments"]
        if e.control.selected_index < len(routes):
            page.go(routes[e.control.selected_index])
    
    def view_pop(view):
        """Gère le retour arrière"""
        page.views.pop()
        top_view = page.views[-1]
        page.go(top_view.route)
    
    # Configuration des événements
    page.on_route_change = route_change
    page.on_view_pop = view_pop
    
    # Démarrage de l'application
    page.go(page.route or "/")

if __name__ == "__main__":
    ft.app(target=main)