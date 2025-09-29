import flet as ft
from ..auth import auth_service

class LoginView:
    def __init__(self, page: ft.Page, on_login_success):
        self.page = page
        self.on_login_success = on_login_success
        self.username_field = ft.TextField(
            label="Nom d'utilisateur",
            width=300,
            prefix_icon=ft.icons.PERSON
        )
        self.password_field = ft.TextField(
            label="Mot de passe",
            password=True,
            can_reveal_password=True,
            width=300,
            prefix_icon=ft.icons.LOCK
        )
        self.error_text = ft.Text("", color=ft.colors.RED)
    
    def login_clicked(self, e):
        username = self.username_field.value
        password = self.password_field.value
        
        if not username or not password:
            self.error_text.value = "Veuillez remplir tous les champs"
            self.page.update()
            return
        
        user = auth_service.login(username, password)
        if user:
            self.on_login_success(user)
        else:
            self.error_text.value = "Nom d'utilisateur ou mot de passe incorrect"
            self.page.update()
    
    def build(self):
        return ft.Container(
            content=ft.Column([
                ft.Container(height=50),
                ft.Text(
                    "GESTION DES FRAIS ACADÉMIQUES",
                    size=24,
                    weight=ft.FontWeight.BOLD,
                    color=ft.colors.BLUE_700
                ),
                ft.Text(
                    "Connexion au système",
                    size=16,
                    color=ft.colors.GREY_700
                ),
                ft.Container(height=30),
                self.username_field,
                self.password_field,
                self.error_text,
                ft.Container(height=20),
                ft.ElevatedButton(
                    text="Se connecter",
                    on_click=self.login_clicked,
                    width=300,
                    height=50,
                    style=ft.ButtonStyle(
                        bgcolor=ft.colors.BLUE_700,
                        color=ft.colors.WHITE,
                        text_style=ft.TextStyle(size=16, weight=ft.FontWeight.BOLD)
                    )
                ),
                ft.Container(height=20),
                ft.Text(
                    "Comptes de test:\nadmin / admin\ncaissier1 / hello",
                    size=12,
                    color=ft.colors.GREY_500,
                    text_align=ft.TextAlign.CENTER
                )
            ], 
            alignment=ft.MainAxisAlignment.CENTER,
            horizontal_alignment=ft.CrossAxisAlignment.CENTER),
            alignment=ft.alignment.center,
            expand=True,
            bgcolor=ft.colors.GREY_100
        )