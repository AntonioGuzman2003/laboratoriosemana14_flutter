import 'package:flutter/material.dart';
import 'package:flutter_application_1/note.dart';
import 'package:flutter_application_1/note_database.dart';

class NoteDetailsView extends StatefulWidget {
  const NoteDetailsView({Key? key, this.noteId});
  final int? noteId;

  @override
  State<NoteDetailsView> createState() => _NoteDetailsViewState();
}

class _NoteDetailsViewState extends State<NoteDetailsView> {
  EquipoFutbolDatabase equipoFutbolDatabase = EquipoFutbolDatabase.instance;

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  DateTime selectedDate = DateTime.now(); // Fecha seleccionada por defecto

  late EquipoFutbolModel equipo;
  bool isLoading = false;
  bool isNewEquipo = false;
  bool isFavorite = false;

  @override
  void initState() {
    refreshEquipo();
    super.initState();
  }

  /// Obtiene el equipo de la base de datos y actualiza el estado si el noteId no es nulo; de lo contrario, establece isNewEquipo en true
  refreshEquipo() {
    if (widget.noteId == null) {
      setState(() {
        isNewEquipo = true;
      });
      return;
    }
    equipoFutbolDatabase.read(widget.noteId!).then((value) {
      setState(() {
        equipo = value;
        titleController.text = equipo.name;
        contentController.text = equipo.year.toString();
        selectedDate = equipo.dateTime; // Asignar la fecha guardada del equipo
        isFavorite = false; // Aquí debes manejar correctamente isFavorite según la lógica de tu aplicación
      });
    });
  }

  /// Muestra el selector de fecha y actualiza selectedDate cuando el usuario selecciona una fecha
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  /// Crea un nuevo equipo si isNewEquipo es true; de lo contrario, actualiza el equipo existente
  createEquipo() {
    setState(() {
      isLoading = true;
    });
    final model = EquipoFutbolModel(
      name: titleController.text,
      year: int.parse(contentController.text),
      dateTime: selectedDate, // Usar la fecha seleccionada
    );
    if (isNewEquipo) {
      equipoFutbolDatabase.create(model).then((createdEquipo) {
        setState(() {
          isLoading = false;
          equipo = createdEquipo;
          isNewEquipo = false;
        });
      });
    } else {
      model.id = equipo.id;
      equipoFutbolDatabase.update(model).then((updatedCount) {
        setState(() {
          isLoading = false;
          equipo = model;
        });
      });
    }
  }

  /// Elimina el equipo de la base de datos y navega de vuelta a la pantalla anterior
  deleteEquipo() {
    equipoFutbolDatabase.delete(equipo.id!).then((deletedCount) {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(141, 182, 131, 0.867),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(221, 15, 78, 3),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
            },
            icon: Icon(!isFavorite ? Icons.favorite_border : Icons.favorite,color:Color.fromARGB(221, 255, 217, 2)),
          ),
          Visibility(
            visible: !isNewEquipo,
            child: IconButton(
              onPressed: deleteEquipo,
              icon: const Icon(Icons.delete,color:Color.fromARGB(221, 255, 217, 2)),
            ),
          ),
          IconButton(
            onPressed: createEquipo,
            icon: const Icon(Icons.save,color:Color.fromARGB(221, 255, 217, 2)),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    TextField(
                      controller: titleController,
                      cursorColor: Colors.white,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Name Team',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextField(
                      controller: contentController,
                      cursorColor: Colors.white,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Year',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    // Selector de fecha
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'DateTime',
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          border: InputBorder.none,
                        ),
                        child: Text(
                          "${selectedDate.toLocal()}".split(' ')[0],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
