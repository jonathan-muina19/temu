from dataclasses import dataclass
from datetime import datetime
from typing import Optional

@dataclass
class User:
    id: Optional[int]
    username: str
    password_hash: str
    role: str
    created_at: Optional[datetime] = None

@dataclass
class Student:
    id: Optional[int]
    matricule: str
    nom: str
    prenom: str
    filiere: str
    annee_academique: str
    created_at: Optional[datetime] = None

@dataclass
class FeeCategory:
    id: Optional[int]
    nom: str
    montant: float
    description: Optional[str] = None
    created_at: Optional[datetime] = None

@dataclass
class Invoice:
    id: Optional[int]
    student_id: int
    category_id: int
    montant: float
    statut: str = "impayee"
    date_creation: Optional[datetime] = None

@dataclass
class Payment:
    id: Optional[int]
    invoice_id: int
    montant_paye: float
    date_paiement: Optional[datetime] = None
    methode: str = "especes"
    caissier: Optional[str] = None
    reference: Optional[str] = None