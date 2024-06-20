import 'package:flutter_application_1/note.dart';
import 'package:flutter_application_1/note_database.dart';
import 'package:flutter_application_1/note_details_view.dart';
import 'package:flutter/material.dart';


class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  EquipoFutbolDatabase equipoFutbolDatabase = EquipoFutbolDatabase.instance;

  List<EquipoFutbolModel> equipos = [];

  @override
  void initState() {
    refreshEquipos();
    super.initState();
  }

  @override
  void dispose() {
    equipoFutbolDatabase.close();
    super.dispose();
  }

  void refreshEquipos() {
    equipoFutbolDatabase.readAll().then((value) {
      setState(() {
        equipos = value;
      });
    });
  }

  void goToEquipoDetailsView({int? id}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteDetailsView(noteId: id)),
    );
    refreshEquipos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(141, 182, 131, 0.867),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(221, 15, 78, 3),
        actions: [
          Text(
              "Equipo de Futbol",
              style: TextStyle(
                color: Colors.white,
                fontSize: 25, // Tamaño de fuente más grande
                fontWeight: FontWeight.bold, // Negrita para enfatizar
              ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Center(
        child: equipos.isEmpty
            ? const Text(
                'No hay equipos aún',
                style: TextStyle(color: Colors.white),
              )
            : ListView.builder(
                itemCount: equipos.length,
                itemBuilder: (context, index) {
                  final equipo = equipos[index];
                  return GestureDetector(
                    onTap: () => goToEquipoDetailsView(id: equipo.id),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Year: ${equipo.year}',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Date-Time: ${equipo.dateTime.toLocal().toString().split(' ')[0]}',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              Text(
                                equipo.name,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => goToEquipoDetailsView(),
        tooltip: 'Crear Equipo',
        child: const Icon(Icons.add),
      ),
    );
  }
}
