from typing import List, Optional
from .database import db
from .models import Student

class StudentService:
    def create_student(self, student: Student) -> int:
        """Crée un nouvel étudiant"""
        query = """
        INSERT INTO students (matricule, nom, prenom, filiere, annee_academique)
        VALUES (?, ?, ?, ?, ?)
        """
        return db.execute_query(query, (
            student.matricule, student.nom, student.prenom,
            student.filiere, student.annee_academique
        ))
    
    def get_all_students(self) -> List[Student]:
        """Récupère tous les étudiants"""
        rows = db.fetch_all("SELECT * FROM students ORDER BY nom, prenom")
        return [Student(
            id=row['id'],
            matricule=row['matricule'],
            nom=row['nom'],
            prenom=row['prenom'],
            filiere=row['filiere'],
            annee_academique=row['annee_academique'],
            created_at=row['created_at']
        ) for row in rows]
    
    def get_student_by_id(self, student_id: int) -> Optional[Student]:
        """Récupère un étudiant par son ID"""
        row = db.fetch_one("SELECT * FROM students WHERE id = ?", (student_id,))
        if row:
            return Student(
                id=row['id'],
                matricule=row['matricule'],
                nom=row['nom'],
                prenom=row['prenom'],
                filiere=row['filiere'],
                annee_academique=row['annee_academique'],
                created_at=row['created_at']
            )
        return None
    
    def search_students(self, search_term: str) -> List[Student]:
        """Recherche des étudiants par nom, prénom ou matricule"""
        query = """
        SELECT * FROM students 
        WHERE nom LIKE ? OR prenom LIKE ? OR matricule LIKE ?
        ORDER BY nom, prenom
        """
        term = f"%{search_term}%"
        rows = db.fetch_all(query, (term, term, term))
        return [Student(
            id=row['id'],
            matricule=row['matricule'],
            nom=row['nom'],
            prenom=row['prenom'],
            filiere=row['filiere'],
            annee_academique=row['annee_academique'],
            created_at=row['created_at']
        ) for row in rows]
    
    def update_student(self, student: Student):
        """Met à jour un étudiant"""
        query = """
        UPDATE students SET matricule = ?, nom = ?, prenom = ?, 
        filiere = ?, annee_academique = ? WHERE id = ?
        """
        db.execute_query(query, (
            student.matricule, student.nom, student.prenom,
            student.filiere, student.annee_academique, student.id
        ))
    
    def delete_student(self, student_id: int):
        """Supprime un étudiant"""
        db.execute_query("DELETE FROM students WHERE id = ?", (student_id,))

student_service = StudentService()