-- Script d'initialisation de la base de données
-- Création des tables pour l'application de gestion des frais académiques

-- Table des utilisateurs
CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) DEFAULT 'user',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Table des étudiants
CREATE TABLE IF NOT EXISTS students (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    matricule VARCHAR(20) UNIQUE NOT NULL,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    filiere VARCHAR(100) NOT NULL,
    annee_academique VARCHAR(20) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Table des catégories de frais
CREATE TABLE IF NOT EXISTS fee_categories (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nom VARCHAR(100) NOT NULL,
    montant DECIMAL(10,2) NOT NULL,
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Table des factures
CREATE TABLE IF NOT EXISTS invoices (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    student_id INTEGER NOT NULL,
    category_id INTEGER NOT NULL,
    montant DECIMAL(10,2) NOT NULL,
    statut VARCHAR(20) DEFAULT 'impayee',
    date_creation DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students (id),
    FOREIGN KEY (category_id) REFERENCES fee_categories (id)
);

-- Table des paiements
CREATE TABLE IF NOT EXISTS payments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    invoice_id INTEGER NOT NULL,
    montant_paye DECIMAL(10,2) NOT NULL,
    date_paiement DATETIME DEFAULT CURRENT_TIMESTAMP,
    methode VARCHAR(50) DEFAULT 'especes',
    caissier VARCHAR(100),
    reference VARCHAR(50),
    FOREIGN KEY (invoice_id) REFERENCES invoices (id)
);

-- Insertion des données de test
INSERT OR IGNORE INTO users (username, password_hash, role) VALUES 
('admin', 'e3afed0047b08059d0fada10f400c1e5', 'admin'),
('caissier1', '5d41402abc4b2a76b9719d911017c592', 'user');

INSERT OR IGNORE INTO fee_categories (nom, montant, description) VALUES 
('Frais de scolarité', 500000, 'Frais de scolarité annuelle'),
('Frais d''inscription', 50000, 'Frais d''inscription administrative'),
('Frais de bibliothèque', 25000, 'Accès à la bibliothèque'),
('Frais de laboratoire', 75000, 'Utilisation des laboratoires');

INSERT OR IGNORE INTO students (matricule, nom, prenom, filiere, annee_academique) VALUES 
('ETU001', 'KAMDEM', 'Jean', 'Informatique', '2024-2025'),
('ETU002', 'MBALLA', 'Marie', 'Génie Civil', '2024-2025'),
('ETU003', 'FOKOU', 'Paul', 'Électronique', '2024-2025'),
('ETU004', 'NJOYA', 'Sarah', 'Informatique', '2024-2025');