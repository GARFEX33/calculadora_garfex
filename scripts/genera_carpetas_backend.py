import os
import tkinter as tk
from tkinter import filedialog, messagebox

def create_project_structure(base_directory, project_name):
    # Define the base directory based on the provided project name
    project_directory = os.path.join(base_directory, project_name)

    # Define the structure of the directories within the project
    directories = [
        f"{project_directory}/core/entities",
        f"{project_directory}/core/services",
        f"{project_directory}/ports",
        f"{project_directory}/adapters/persistence",
        f"{project_directory}/adapters/web",
        f"{project_directory}/data"
    ]

    # Create the directories
    for directory in directories:
        os.makedirs(directory, exist_ok=True)

    # Create an empty __init__.py file in each directory to make them Python packages
    for directory in directories:
        with open(os.path.join(directory, '__init__.py'), 'w') as f:
            pass

    # Return a confirmation message
    return f"All directories for project '{project_name}' have been created successfully."

def seleccionar_directorio():
    directorio = filedialog.askdirectory()
    directorio_entrada.delete(0, tk.END)
    directorio_entrada.insert(0, directorio)

def ejecutar_script():
    base_directory = directorio_entrada.get()
    project_name = nombre_proyecto_entrada.get()

    if os.path.exists(base_directory) and os.path.isdir(base_directory):
        mensaje = create_project_structure(base_directory, project_name)
        messagebox.showinfo("Success", mensaje)
    else:
        messagebox.showerror("Error", f"Directory '{base_directory}' not found.")

# Create the main window
ventana = tk.Tk()
ventana.title("Create Project Structure")

# Label and entry for the base directory
tk.Label(ventana, text="Base Directory:").grid(row=0, column=0, padx=10, pady=5)
directorio_entrada = tk.Entry(ventana, width=50)
directorio_entrada.grid(row=0, column=1, padx=10, pady=5)
tk.Button(ventana, text="Select", command=seleccionar_directorio).grid(row=0, column=2, padx=10, pady=5)

# Label and entry for the project name
tk.Label(ventana, text="Project Name:").grid(row=1, column=0, padx=10, pady=5)
nombre_proyecto_entrada = tk.Entry(ventana, width=50)
nombre_proyecto_entrada.grid(row=1, column=1, padx=10, pady=5)

# Button to execute the script
tk.Button(ventana, text="Create Project", command=ejecutar_script).grid(row=2, column=1, padx=10, pady=20)

# Start the GUI loop
ventana.mainloop()
