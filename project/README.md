# Application de Gestion des Frais Académiques

Une application desktop moderne développée en Python avec Flet pour la gestion des frais académiques d'étudiants.

## 📋 Fonctionnalités

### ✅ Authentification
- Écran de connexion sécurisé
- Gestion des utilisateurs avec rôles (admin/utilisateur)
- Session persistante

### 👥 Gestion des Étudiants
- Ajout, modification, suppression d'étudiants
- Recherche avancée par nom, prénom ou matricule
- Gestion des filières et années académiques

### 💰 Gestion des Frais et Paiements
- Création et gestion des catégories de frais
- Enregistrement des paiements (partiels ou totaux)
- Méthodes de paiement multiples (espèces, chèque, virement, carte)
- Génération automatique de reçus PDF

### 📊 Tableau de Bord et Rapports
- Statistiques en temps réel (étudiants, factures, encaissements)
- Historique des paiements
- Liste des factures impayées
- Export CSV des données

### 🎨 Interface Utilisateur
- Interface moderne et intuitive avec Flet
- Design responsive et professionnel
- Navigation facile entre les modules
- Tableaux interactifs pour l'affichage des données

## 🚀 Installation et Exécution

### Prérequis
- Python 3.8 ou supérieur
- pip (gestionnaire de packages Python)

### Installation des Dépendances
```bash
pip install -r requirements.txt
```

### Lancement de l'Application
```bash
python main.py
```

## 🗄️ Base de Données

L'application utilise SQLite avec les tables suivantes :
- `users` : Gestion des utilisateurs et authentification
- `students` : Informations des étudiants
- `fee_categories` : Catégories de frais académiques
- `invoices` : Factures générées pour les étudiants
- `payments` : Historique des paiements effectués

### Initialisation Automatique
La base de données est automatiquement créée et initialisée au premier lancement avec des données de test.

## 👤 Comptes de Test

L'application est fournie avec des comptes de test :

### Administrateur
- **Nom d'utilisateur :** `admin`
- **Mot de passe :** `admin`

### Caissier
- **Nom d'utilisateur :** `caissier1`
- **Mot de passe :** `hello`

## 📁 Structure du Projet

```
├── main.py                     # Point d'entrée de l'application
├── init_db.sql                 # Script d'initialisation de la base de données
├── requirements.txt            # Dépendances Python
├── README.md                   # Documentation
├── data/                       # Dossier de la base de données
│   └── database.db
├── exports/                    # Dossier des exports (reçus PDF, CSV)
└── src/                        # Code source
    ├── database.py             # Gestion de la base de données
    ├── auth.py                 # Service d'authentification
    ├── models.py               # Modèles de données
    ├── students.py             # Gestion des étudiants
    ├── fees.py                 # Gestion des frais
    ├── invoices.py             # Gestion des factures
    ├── payments.py             # Gestion des paiements
    ├── reports.py              # Génération de rapports
    ├── pdf_generator.py        # Génération de PDF
    └── ui/                     # Interface utilisateur
        ├── login.py            # Page de connexion
        ├── dashboard.py        # Tableau de bord
        ├── student_management.py    # Gestion des étudiants
        └── payment_management.py   # Gestion des paiements
```

## 🛠️ Fonctionnalités Techniques

### Sécurité
- Mots de passe hachés (MD5 pour la simplicité)
- Sessions utilisateurs sécurisées
- Validation des données d'entrée

### Performance
- Architecture modulaire pour une meilleure maintenabilité
- Gestion efficace des connexions à la base de données
- Interface responsive et fluide

### Export et Impression
- Génération automatique de reçus PDF
- Export CSV des données de paiement
- Sauvegarde dans le dossier `exports/`

## 🔄 Développement et Extension

### Ajout de Nouvelles Fonctionnalités
1. Créer un nouveau service dans `src/`
2. Ajouter la vue correspondante dans `src/ui/`
3. Intégrer la route dans `main.py`
4. Mettre à jour la base de données si nécessaire

### Packaging avec PyInstaller
Pour créer un exécutable standalone :
```bash
pip install pyinstaller
pyinstaller --onedir --windowed --add-data "init_db.sql;." main.py
```

## 📝 Données de Test Incluses

L'application inclut :
- 2 utilisateurs de test (admin et caissier)
- 4 étudiants exemples
- 4 catégories de frais standards
- Structure complète pour commencer immédiatement

## 🎯 Utilisation

1. **Connexion :** Utilisez les comptes de test fournis
2. **Tableau de bord :** Vue d'ensemble des statistiques
3. **Gestion des étudiants :** Ajouter/modifier les informations
4. **Enregistrement des paiements :** Sélectionner étudiant et frais, saisir le montant
5. **Génération de reçus :** Automatique après chaque paiement
6. **Consultation des rapports :** Historique et statistiques

## 🤝 Support

Pour toute question ou amélioration, consultez le code source bien documenté et modulaire qui facilite la compréhension et l'extension de l'application.

---

**Développé avec ❤️ en Python et Flet**