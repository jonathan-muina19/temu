import flet as ft
from ..students import student_service
from ..models import Student

class StudentManagementView:
    def __init__(self, page: ft.Page):
        self.page = page
        self.students = []
        self.selected_student = None
        
        # Champs du formulaire
        self.matricule_field = ft.TextField(label="Matricule", width=200)
        self.nom_field = ft.TextField(label="Nom", width=200)
        self.prenom_field = ft.TextField(label="Prénom", width=200)
        self.filiere_field = ft.TextField(label="Filière", width=200)
        self.annee_field = ft.TextField(label="Année Académique", width=200, value="2024-2025")
        
        # Champ de recherche
        self.search_field = ft.TextField(
            label="Rechercher un étudiant",
            prefix_icon=ft.icons.SEARCH,
            on_change=self.search_students,
            width=300
        )
        
        self.data_table = ft.DataTable(
            columns=[
                ft.DataColumn(ft.Text("Matricule")),
                ft.DataColumn(ft.Text("Nom")),
                ft.DataColumn(ft.Text("Prénom")),
                ft.DataColumn(ft.Text("Filière")),
                ft.DataColumn(ft.Text("Année")),
                ft.DataColumn(ft.Text("Actions")),
            ],
            rows=[]
        )
        
    def load_students(self):
        """Charge la liste des étudiants"""
        self.students = student_service.get_all_students()
        self.update_table()
    
    def search_students(self, e):
        """Recherche des étudiants"""
        if e.control.value.strip():
            self.students = student_service.search_students(e.control.value.strip())
        else:
            self.students = student_service.get_all_students()
        self.update_table()
    
    def update_table(self):
        """Met à jour le tableau des étudiants"""
        self.data_table.rows.clear()
        for student in self.students:
            self.data_table.rows.append(
                ft.DataRow(
                    cells=[
                        ft.DataCell(ft.Text(student.matricule)),
                        ft.DataCell(ft.Text(student.nom)),
                        ft.DataCell(ft.Text(student.prenom)),
                        ft.DataCell(ft.Text(student.filiere)),
                        ft.DataCell(ft.Text(student.annee_academique)),
                        ft.DataCell(ft.Row([
                            ft.IconButton(
                                icon=ft.icons.EDIT,
                                tooltip="Modifier",
                                on_click=lambda e, s=student: self.edit_student(s)
                            ),
                            ft.IconButton(
                                icon=ft.icons.DELETE,
                                tooltip="Supprimer",
                                on_click=lambda e, s=student: self.delete_student(s)
                            )
                        ]))
                    ]
                )
            )
        self.page.update()
    
    def clear_form(self):
        """Vide le formulaire"""
        self.matricule_field.value = ""
        self.nom_field.value = ""
        self.prenom_field.value = ""
        self.filiere_field.value = ""
        self.annee_field.value = "2024-2025"
        self.selected_student = None
        self.page.update()
    
    def save_student(self, e):
        """Sauvegarde un étudiant"""
        if not all([self.matricule_field.value, self.nom_field.value, 
                   self.prenom_field.value, self.filiere_field.value]):
            self.page.show_snack_bar(ft.SnackBar(content=ft.Text("Veuillez remplir tous les champs")))
            return
        
        try:
            student = Student(
                id=self.selected_student.id if self.selected_student else None,
                matricule=self.matricule_field.value,
                nom=self.nom_field.value.upper(),
                prenom=self.prenom_field.value.title(),
                filiere=self.filiere_field.value,
                annee_academique=self.annee_field.value
            )
            
            if self.selected_student:
                student_service.update_student(student)
                self.page.show_snack_bar(ft.SnackBar(content=ft.Text("Étudiant modifié avec succès")))
            else:
                student_service.create_student(student)
                self.page.show_snack_bar(ft.SnackBar(content=ft.Text("Étudiant ajouté avec succès")))
            
            self.clear_form()
            self.load_students()
        except Exception as ex:
            self.page.show_snack_bar(ft.SnackBar(content=ft.Text(f"Erreur: {str(ex)}")))
    
    def edit_student(self, student):
        """Édite un étudiant"""
        self.selected_student = student
        self.matricule_field.value = student.matricule
        self.nom_field.value = student.nom
        self.prenom_field.value = student.prenom
        self.filiere_field.value = student.filiere
        self.annee_field.value = student.annee_academique
        self.page.update()
    
    def delete_student(self, student):
        """Supprime un étudiant"""
        def confirm_delete(e):
            student_service.delete_student(student.id)
            self.page.show_snack_bar(ft.SnackBar(content=ft.Text("Étudiant supprimé")))
            self.load_students()
            dialog.open = False
            self.page.update()
        
        dialog = ft.AlertDialog(
            title=ft.Text("Confirmer la suppression"),
            content=ft.Text(f"Voulez-vous vraiment supprimer {student.prenom} {student.nom}?"),
            actions=[
                ft.TextButton("Annuler", on_click=lambda e: setattr(dialog, 'open', False) or self.page.update()),
                ft.TextButton("Supprimer", on_click=confirm_delete)
            ]
        )
        
        self.page.dialog = dialog
        dialog.open = True
        self.page.update()
    
    def build(self):
        self.load_students()
        
        form_section = ft.Card(
            content=ft.Container(
                content=ft.Column([
                    ft.Text("Formulaire Étudiant", size=18, weight=ft.FontWeight.BOLD),
                    ft.Row([
                        self.matricule_field,
                        self.nom_field,
                        self.prenom_field
                    ], wrap=True),
                    ft.Row([
                        self.filiere_field,
                        self.annee_field
                    ], wrap=True),
                    ft.Row([
                        ft.ElevatedButton(
                            text="Enregistrer",
                            icon=ft.icons.SAVE,
                            on_click=self.save_student,
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
        
        table_section = ft.Card(
            content=ft.Container(
                content=ft.Column([
                    ft.Row([
                        ft.Text("Liste des Étudiants", size=18, weight=ft.FontWeight.BOLD),
                        self.search_field
                    ], alignment=ft.MainAxisAlignment.SPACE_BETWEEN),
                    ft.Container(
                        content=self.data_table,
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
                    "GESTION DES ÉTUDIANTS",
                    size=24,
                    weight=ft.FontWeight.BOLD,
                    color=ft.colors.BLUE_700
                ),
                padding=ft.padding.all(20)
            ),
            form_section,
            table_section
        ], scroll=ft.ScrollMode.AUTO)