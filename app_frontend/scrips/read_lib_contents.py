import os

def read_files_in_directory(directory, output_file):
    with open(output_file, 'w', encoding='utf-8') as out:
        for root, dirs, files in os.walk(directory):
            for file in files:
                if file.endswith('.dart'):
                    file_path = os.path.join(root, file)
                    relative_path = os.path.relpath(file_path, directory)
                    out.write(f"\n## Contenido de: `{relative_path}`\n\n")
                    out.write("```dart\n")
                    try:
                        with open(file_path, 'r', encoding='utf-8') as f:
                            out.write(f.read() + "\n")
                    except Exception as e:
                        out.write(f"Error leyendo el archivo {file_path}: {e}\n")
                    out.write("```\n")

def main():
    # Ajustar la ruta para que apunte a la carpeta 'lib'
    script_dir = os.path.dirname(os.path.realpath(__file__))
    lib_directory = os.path.join(script_dir, '../lib')
    output_file = os.path.join(script_dir, 'output.md')

    if os.path.exists(lib_directory) and os.path.isdir(lib_directory):
        read_files_in_directory(lib_directory, output_file)
        print(f"El contenido de los archivos .dart ha sido exportado a {output_file} en formato Markdown.")
    else:
        print(f"No se encontró el directorio '{lib_directory}'.")

if __name__ == "__main__":
    main()
