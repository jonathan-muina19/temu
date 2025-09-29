import hashlib
from typing import Optional
from .database import db
from .models import User

class AuthService:
    def __init__(self):
        self.current_user = None
    
    def hash_password(self, password: str) -> str:
        """Hache le mot de passe avec MD5 (pour la simplicité)"""
        return hashlib.md5(password.encode()).hexdigest()
    
    def login(self, username: str, password: str) -> Optional[User]:
        """Authentifie un utilisateur"""
        password_hash = self.hash_password(password)
        user_data = db.fetch_one(
            "SELECT * FROM users WHERE username = ? AND password_hash = ?",
            (username, password_hash)
        )
        
        if user_data:
            self.current_user = User(
                id=user_data['id'],
                username=user_data['username'],
                password_hash=user_data['password_hash'],
                role=user_data['role'],
                created_at=user_data['created_at']
            )
            return self.current_user
        return None
    
    def logout(self):
        """Déconnecte l'utilisateur actuel"""
        self.current_user = None
    
    def is_authenticated(self) -> bool:
        """Vérifie si un utilisateur est connecté"""
        return self.current_user is not None
    
    def is_admin(self) -> bool:
        """Vérifie si l'utilisateur actuel est admin"""
        return self.current_user and self.current_user.role == 'admin'

# Instance globale du service d'authentification
auth_service = AuthService()