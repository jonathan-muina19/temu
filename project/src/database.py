import sqlite3
import os
from contextlib import contextmanager

class Database:
    def __init__(self, db_path="data/database.db"):
        self.db_path = db_path
        os.makedirs(os.path.dirname(db_path), exist_ok=True)
        self.initialize_database()
    
    @contextmanager
    def get_connection(self):
        conn = sqlite3.connect(self.db_path)
        conn.row_factory = sqlite3.Row
        try:
            yield conn
        finally:
            conn.close()
    
    def initialize_database(self):
        """Initialise la base de données avec le script SQL"""
        with self.get_connection() as conn:
            # Lire et exécuter le script d'initialisation
            with open('init_db.sql', 'r', encoding='utf-8') as f:
                script = f.read()
            conn.executescript(script)
            conn.commit()
    
    def execute_query(self, query, params=None):
        """Exécute une requête de modification (INSERT, UPDATE, DELETE)"""
        with self.get_connection() as conn:
            cursor = conn.cursor()
            if params:
                cursor.execute(query, params)
            else:
                cursor.execute(query)
            conn.commit()
            return cursor.lastrowid
    
    def fetch_all(self, query, params=None):
        """Exécute une requête de sélection et retourne tous les résultats"""
        with self.get_connection() as conn:
            cursor = conn.cursor()
            if params:
                cursor.execute(query, params)
            else:
                cursor.execute(query)
            return cursor.fetchall()
    
    def fetch_one(self, query, params=None):
        """Exécute une requête de sélection et retourne un résultat"""
        with self.get_connection() as conn:
            cursor = conn.cursor()
            if params:
                cursor.execute(query, params)
            else:
                cursor.execute(query)
            return cursor.fetchone()

# Instance globale de la base de données
db = Database()